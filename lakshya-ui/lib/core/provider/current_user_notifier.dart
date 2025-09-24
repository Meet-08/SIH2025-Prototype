import 'package:lakshya/core/utils/token_storage.dart';
import 'package:lakshya/features/auth/model/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_user_notifier.g.dart';

@Riverpod(keepAlive: true)
class CurrentUserNotifier extends _$CurrentUserNotifier {
  @override
  UserModel? build() {
    return null;
  }

  void addUser(UserModel user) {
    state = user;
  }

  void logout() async {
    await TokenStorage.deleteToken();
    state = null;
  }
}
