import 'package:chat_redis_app/models/login_request.dart';
import 'package:chat_redis_app/providers/member_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memberInfo = ref.watch(memberNotifierProvider);
    final isLogin = ref.watch(memberNotifierProvider.notifier).isLogin();

    final memberNotifier = ref.read(memberNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: isLogin
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(memberInfo.email ?? ""),
                  Text(memberInfo.accessToken ?? ""),
                  ElevatedButton(
                    onPressed: () {
                      memberNotifier.clearMember();
                    },
                    child: const Text("로그아웃"),
                  ),
                ],
              )
            : ElevatedButton(
                onPressed: () {
                  memberNotifier.login(
                    LoginRequest(platform: "KAKAO", accessToken: "test222"),
                  );
                },
                child: const Text("로그인"),
              ),
      ),
    );
  }
}
