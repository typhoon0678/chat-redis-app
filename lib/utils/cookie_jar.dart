import 'dart:convert';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:chat_redis_app/models/entities/cookie_info.dart';

Future<CookieJar> customCookieJar() async {
  if (kIsWeb) {
    // 웹 환경에서는 메모리 기반 쿠키 저장소 사용
    return CookieJar();
  } else {
    // 모바일 환경에서는 파일 기반 쿠키 저장소 사용
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    return PersistCookieJar(storage: FileStorage("$appDocPath/.cookies/"));
  }
}

Future<void> listCookies() async {
  if (kIsWeb) {
    debugPrint("웹 환경에서는 쿠키 목록을 확인할 수 없습니다.");
    return;
  }

  Directory appDocDir = await getApplicationDocumentsDirectory();
  String appDocPath = appDocDir.path;
  Directory cookiesDir = Directory("$appDocPath/.cookies/");

  if (cookiesDir.existsSync()) {
    List<FileSystemEntity> files = cookiesDir.listSync();
    for (var entity in files) {
      if (entity is Directory) {
        // 서브디렉토리의 파일들을 탐색
        List<FileSystemEntity> subFiles = entity.listSync();
        for (var subEntity in subFiles) {
          if (subEntity is File) {
            // 파일 내용을 읽기
            String fileContent = await subEntity.readAsString();

            // JSON 형식으로 파싱
            var cookies = jsonDecode(fileContent);

            // 쿠키 내용을 출력
            debugPrint("Cookies in file ${subEntity.path}:");

            // 중첩된 Map에서 refreshToken 추출
            if (cookies is Map) {
              for (var domain in cookies.keys) {
                var domainCookies = cookies[domain];
                if (domainCookies is Map) {
                  for (var path in domainCookies.keys) {
                    var pathCookies = domainCookies[path];
                    if (pathCookies is Map &&
                        pathCookies.containsKey('refreshToken')) {
                      String cookieString = pathCookies['refreshToken'];
                      CookieInfo cookieInfo = CookieInfo.fromString(
                        cookieString,
                      );
                      debugPrint("Parsed Cookie Info: $cookieInfo");
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  } else {
    debugPrint("쿠키 디렉토리가 존재하지 않습니다.");
  }
}

/// 모든 쿠키를 삭제합니다.
Future<void> deleteAllCookies() async {
  if (kIsWeb) {
    debugPrint("웹 환경에서는 쿠키가 자동으로 관리됩니다.");
    return;
  }

  Directory appDocDir = await getApplicationDocumentsDirectory();
  String appDocPath = appDocDir.path;
  Directory cookiesDir = Directory("$appDocPath/.cookies/");

  if (cookiesDir.existsSync()) {
    try {
      // 모든 파일과 디렉토리 삭제
      await cookiesDir.delete(recursive: true);
      debugPrint("모든 쿠키가 삭제되었습니다.");
    } catch (e) {
      debugPrint("쿠키 삭제 중 오류 발생: $e");
    }
  } else {
    debugPrint("쿠키 디렉토리가 존재하지 않습니다.");
  }
}
