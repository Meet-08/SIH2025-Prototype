import 'package:lakshya/core/provider/current_user_notifier.dart';
import 'package:lakshya/features/auth/model/user_model.dart';
import 'package:lakshya/features/auth/repository/auth_remote_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_view_model.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  late AuthRemoteRepository _authRemoteRepository;
  late CurrentUserNotifier _currentUserNotifier;

  @override
  AsyncValue<UserModel>? build() {
    _authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
    _currentUserNotifier = ref.watch(currentUserNotifierProvider.notifier);
    return null;
  }

  Future<void> register({
    required String email,
    required String password,
    required String name,
    required int age,
    required String className,
    required String city,
  }) async {
    state = const AsyncValue.loading();
    final result = await _authRemoteRepository.register(
      email: email,
      password: password,
      name: name,
      age: age,
      className: className,
      city: city,
    );

    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (user) => _signinSuccess(user),
    );
  }

  Future<void> login({required String email, required String password}) async {
    state = const AsyncValue.loading();
    final result = await _authRemoteRepository.login(
      email: email,
      password: password,
    );

    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (user) => _signinSuccess(user),
    );
  }

  AsyncValue<UserModel>? _signinSuccess(UserModel user) {
    _currentUserNotifier.addUser(user);
    return state = AsyncValue.data(user);
  }
}
