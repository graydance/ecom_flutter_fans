import 'package:flutter/foundation.dart';

import 'package:fans/models/user.dart';

@immutable
class LoginOrSignupState {
  final bool isLoading;
  final String error;
  final User user;

  const LoginOrSignupState({
    this.isLoading = false,
    this.error = '',
    this.user = const User(),
  });

  LoginOrSignupState copyWith({
    bool isLoading,
    String error,
    User user,
  }) {
    return LoginOrSignupState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      user: user ?? this.user,
    );
  }

  @override
  String toString() {
    return 'LoginState(isLoading: $isLoading, error: $error, user: $user)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is LoginOrSignupState &&
        o.isLoading == isLoading &&
        o.error == error &&
        o.user == user;
  }

  @override
  int get hashCode {
    return isLoading.hashCode ^ error.hashCode ^ user.hashCode;
  }
}
