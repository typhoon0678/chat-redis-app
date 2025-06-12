import 'package:chat_redis_app/models/requests/login_request.dart';
import 'package:chat_redis_app/models/entities/member.dart';
import 'package:chat_redis_app/utils/cookie_jar.dart';
import 'package:chat_redis_app/utils/dio_api.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MemberApi {
  final DioApi dioApi = DioApi();
  final String apiUrl = dotenv.get("API_URL");

  final Dio dio = Dio();

  Future<Member> login(LoginRequest loginRequest) async {
    try {
      late final Response response;

      if (!kIsWeb) {
        response = await _sendRequestWithCookieJar(loginRequest);
      } else {
        response = await _sendRequest(loginRequest);
      }

      return Member.fromResponse(response);
    } catch (e, stackTrace) {
      debugPrint("$e, $stackTrace");
      return Member();
    }
  }

  Future<Response> _sendRequestWithCookieJar(LoginRequest loginRequest) async {
    final CookieJar cookieJar = await customCookieJar();
    dio.interceptors.add(CookieManager(cookieJar));

    try {
      return await dio.post(
        "$apiUrl/member/login",
        data: loginRequest,
        options: Options(headers: {"Content-Type": "application/json"}),
      );
    } finally {
      dio.interceptors.remove(CookieManager(cookieJar));
    }
  }

  Future<Response> _sendRequest(LoginRequest loginRequest) async {
    return await dio.post(
      "$apiUrl/member/login",
      data: loginRequest,
      options: Options(
        headers: {"Content-Type": "application/json"},
        extra: {
          'withCredentials': true, // 쿠키를 포함하여 요청
        },
      ),
    );
  }
}
