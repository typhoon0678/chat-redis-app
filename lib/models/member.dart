class Member {
  String? email;
  String? accessToken;

  Member({this.email, this.accessToken});

  Member.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    accessToken = json['accessToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['email'] = email;
    data['accessToken'] = accessToken;
    return data;
  }
}
