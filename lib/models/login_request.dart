class LoginRequest {
  final String platform;
  final String accessToken;

  LoginRequest({required this.platform, required this.accessToken});

  Map<String, dynamic> toJson() => {
    'platform': platform,
    'accessToken': accessToken,
  };
}
