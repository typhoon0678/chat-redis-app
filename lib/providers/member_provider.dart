import 'package:chat_redis_app/models/member.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'member_provider.g.dart';

@riverpod
class MemberNotifier extends _$MemberNotifier {
  final _initialMember = Member(email: '', accessToken: '');

  @override
  Member build() {
    return _initialMember;
  }

  bool isLogin() => state.email != '';

  void setMember(Member member) {
    state = member;
  }

  void clearMember() {
    state = _initialMember;
  }
}
