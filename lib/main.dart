import 'package:chat_redis_app/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xff405f91),
          onPrimary: Color(0xffffffff),
          secondary: Color(0xff565f71),
          onSecondary: Color(0xffffffff),
          surface: Color(0xfff9f9ff),
          onSurface: Color(0xFF222222),
          error: Color(0xffba1a1a),
          onError: Color(0xffffffff),
        ),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
