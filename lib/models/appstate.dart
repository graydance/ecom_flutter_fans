import 'package:meta/meta.dart';

import 'package:fans/store/states.dart';

@immutable
class AppState {
  final VerifyEmailState verifyEmail;
  final LoginOrSignupState auth;
  final InterestListState interests;
  final HomeState feeds;

  final bool isLoading;
  final String error;

  AppState({
    this.verifyEmail = const VerifyEmailState(),
    this.auth = const LoginOrSignupState(),
    this.interests = const InterestListState(),
    this.feeds = const HomeState(),
    this.isLoading = false,
    this.error,
  });

  factory AppState.loading() => AppState(isLoading: true);

  AppState copyWith({
    VerifyEmailState verifyEmail,
    LoginOrSignupState auth,
    InterestListState interests,
    bool isLoading,
    String error,
  }) {
    return AppState(
      verifyEmail: verifyEmail ?? this.verifyEmail,
      auth: auth ?? this.auth,
      interests: interests ?? this.interests,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  String toString() {
    return 'AppState(verifyEmail: $verifyEmail, auth: $auth, interests: $interests, isLoading: $isLoading, error: $error)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is AppState &&
        o.verifyEmail == verifyEmail &&
        o.auth == auth &&
        o.interests == interests &&
        o.isLoading == isLoading &&
        o.error == error;
  }

  @override
  int get hashCode {
    return verifyEmail.hashCode ^
        auth.hashCode ^
        interests.hashCode ^
        isLoading.hashCode ^
        error.hashCode;
  }
}
