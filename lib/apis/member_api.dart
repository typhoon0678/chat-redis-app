import 'package:chat_redis_app/models/login_request.dart';
import 'package:chat_redis_app/models/member.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MemberApi {
  final Dio dio = Dio();
  final String apiUrl = dotenv.get("API_URL");

  Future<Member> login(LoginRequest loginRequest) async {
    final response = await dio.post(
      "$apiUrl/member/login",
      data: loginRequest,
      options: Options(headers: {"Content-Type": "application/json"}),
    );
    if (response.statusCode == 200) {
      return Member.fromJson(response.data);
    } else {
      throw Exception("Failed to login");
    }
  }
}
