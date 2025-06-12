import 'package:chat_redis_app/models/entities/member.dart';
import 'package:chat_redis_app/providers/member_provider.dart';
import 'package:chat_redis_app/utils/cookie_jar.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DioApi {
  late Dio dio;
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final String apiUrl = dotenv.get("API_URL");

  DioApi() {
    dio = Dio(
      BaseOptions(
        contentType: "application/json",
        extra: {
          'withCredentials': true, // 쿠키를 포함하여 요청
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final memberNotifier = ProviderContainer().read(
            memberNotifierProvider,
          );

          options.headers["Authorization"] = memberNotifier.accessToken;

          return handler.next(options);
        },
        onError: (e, handler) async {
          debugPrint("error response: ${e.response}");
          if ((e.response?.statusCode == 401 ||
                  e.response?.statusCode == 403) &&
              !e.requestOptions.extra.containsKey("retry")) {
            e.requestOptions.extra["retry"] = true;

            try {
              late final Response refreshResponse;
              if (!kIsWeb) {
                // 앱 내부 저장소 쿠키 포함 전송
                final CookieJar cookieJar = await customCookieJar();
                dio.interceptors.add(CookieManager(cookieJar));
                refreshResponse = await dio.get("$apiUrl/member/refresh");
                dio.interceptors.remove(CookieManager(cookieJar));
              } else {
                refreshResponse = await dio.get("$apiUrl/member/refresh");
              }

              // member 상태 업데이트
              final memberNotifier = ProviderContainer().read(
                memberNotifierProvider.notifier,
              );
              memberNotifier.setMember(Member()); // todo: 멤버 정보 업데이트

              final accessToken =
                  refreshResponse.headers["Authorization"]?.first;
              e.response?.requestOptions.headers["Authorization"] = accessToken;
              final retryResponse = await dio.fetch(e.requestOptions);
              return handler.resolve(retryResponse);
            } catch (error) {
              debugPrint("error: $error");
              return handler.reject(
                DioException(requestOptions: e.requestOptions),
              );
            }
          }

          return handler.next(e);
        },
      ),
    );
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
    return dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data}) {
    return dio.post(path, data: data);
  }
}
