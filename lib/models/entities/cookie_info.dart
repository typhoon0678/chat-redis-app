import 'package:flutter/material.dart';

class CookieInfo {
  final String refreshToken;
  final DateTime expires;
  final int maxAge;
  final String domain;
  final String path;
  final bool httpOnly;

  CookieInfo({
    required this.refreshToken,
    required this.expires,
    required this.maxAge,
    required this.domain,
    required this.path,
    required this.httpOnly,
  });

  factory CookieInfo.fromString(String cookieString) {
    final parts = cookieString.split(';');
    String token = '';
    DateTime expires = DateTime.now();
    int maxAge = 0;
    String domain = '';
    String path = '';
    bool httpOnly = false;

    for (var part in parts) {
      part = part.trim();
      if (part.startsWith('refreshToken=')) {
        token = part.split('=')[1];
      } else if (part.startsWith('Expires=')) {
        try {
          // RFC 1123 형식의 날짜를 파싱
          String dateStr = part.split('=')[1];
          debugPrint('원본 날짜 문자열: $dateStr');

          // 요일 제거 (예: "Thu, " 부분)
          dateStr = dateStr.replaceAll(RegExp(r'^[A-Za-z]+, '), '');

          // 날짜 형식 변환
          final dateParts = dateStr.split(' ');
          if (dateParts.length == 5) {
            final day = dateParts[0];
            final month = dateParts[1];
            final year = dateParts[2];
            final time = dateParts[3];

            // 월 이름을 숫자로 변환
            final monthMap = {
              'Jan': '01',
              'Feb': '02',
              'Mar': '03',
              'Apr': '04',
              'May': '05',
              'Jun': '06',
              'Jul': '07',
              'Aug': '08',
              'Sep': '09',
              'Oct': '10',
              'Nov': '11',
              'Dec': '12',
            };

            final monthNum = monthMap[month] ?? '01';
            // UTC 시간대를 +0000으로 표현
            final formattedDate = '$year-$monthNum-$day $time+0000';
            debugPrint('최종 변환된 날짜 문자열: $formattedDate');

            expires = DateTime.parse(formattedDate);
          } else {
            throw FormatException('날짜 형식이 올바르지 않습니다: $dateStr');
          }
        } catch (e) {
          debugPrint('날짜 파싱 오류: $e');
          expires = DateTime.now();
        }
      } else if (part.startsWith('Max-Age=')) {
        maxAge = int.parse(part.split('=')[1]);
      } else if (part.startsWith('Domain=')) {
        domain = part.split('=')[1];
      } else if (part.startsWith('Path=')) {
        path = part.split('=')[1];
      } else if (part == 'HttpOnly') {
        httpOnly = true;
      }
    }

    return CookieInfo(
      refreshToken: token,
      expires: expires,
      maxAge: maxAge,
      domain: domain,
      path: path,
      httpOnly: httpOnly,
    );
  }

  @override
  String toString() {
    return 'CookieInfo(refreshToken: $refreshToken, expires: $expires, maxAge: $maxAge, domain: $domain, path: $path, httpOnly: $httpOnly)';
  }
}
