import 'package:chat_redis_app/models/requests/login_request.dart';
import 'package:chat_redis_app/models/entities/member.dart';
import 'package:chat_redis_app/utils/cookie_jar.dart';
import 'package:chat_redis_app/utils/dio_api.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MemberApi {
  // final DioApi dioApi = DioApi();
  final String apiUrl = dotenv.get("API_URL");

  final Dio dio = Dio();

  Future<Member> login(LoginRequest loginRequest) async {
    try {
      final CookieJar cookieJar = await customCookieJar();
      dio.interceptors.add(CookieManager(cookieJar));

      final response = await dio.post(
        "$apiUrl/member/login",
        data: loginRequest,
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      dio.interceptors.remove(CookieManager(cookieJar));

      return Member.fromResponse(response);
    } catch (e, stackTrace) {
      debugPrint("$e, $stackTrace");
      return Member();
    }
  }
}
