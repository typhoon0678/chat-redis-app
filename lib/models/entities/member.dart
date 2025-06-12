import 'package:dio/dio.dart';

class Member {
  String? email;
  String? accessToken;
  List<String>? roles;

  Member({this.email, this.accessToken, this.roles});

  Member.fromResponse(Response response) {
    Map<String, dynamic> json = response.data;
    Headers headers = response.headers;

    email = json['email'];
    accessToken = headers['Authorization']?.first ?? '';
    roles = json['roles'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['email'] = email;
    data['accessToken'] = accessToken;
    data['roles'] = roles;
    return data;
  }
}
