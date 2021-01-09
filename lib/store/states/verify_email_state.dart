import 'package:flutter/cupertino.dart';

@immutable
class VerifyEmailState {
  final bool isLoading;
  final String error;
  final String email;

  const VerifyEmailState({
    this.isLoading = false,
    this.error = '',
    this.email = '',
  });

  VerifyEmailState copyWith({
    bool isLoading,
    String error,
    String email,
  }) {
    return VerifyEmailState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      email: email ?? this.email,
    );
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is VerifyEmailState &&
        o.isLoading == isLoading &&
        o.error == error &&
        o.email == email;
  }

  @override
  int get hashCode => isLoading.hashCode ^ error.hashCode ^ email.hashCode;

  @override
  String toString() =>
      'VerifyEmailState(isLoading: $isLoading, error: $error, email: $email)';
}
