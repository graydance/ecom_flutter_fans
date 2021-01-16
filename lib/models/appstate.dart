import 'package:meta/meta.dart';

import 'package:fans/store/states.dart';
import 'package:fans/store/states/search_by_tag_state.dart';

@immutable
class AppState {
  final VerifyEmailState verifyEmail;
  final LoginOrSignupState auth;
  final InterestListState interests;
  final HomeState feeds;
  final SearchByTagState tagSearch;

  final bool isLoading;
  final String error;

  AppState({
    this.verifyEmail = const VerifyEmailState(),
    this.auth = const LoginOrSignupState(),
    this.interests = const InterestListState(),
    this.feeds = const HomeState(),
    this.tagSearch = const SearchByTagState(),
    this.isLoading = false,
    this.error,
  });

  factory AppState.loading() => AppState(isLoading: true);

  AppState copyWith({
    VerifyEmailState verifyEmail,
    LoginOrSignupState auth,
    InterestListState interests,
    HomeState feeds,
    SearchByTagState tagSearch,
    bool isLoading,
    String error,
  }) {
    return AppState(
      verifyEmail: verifyEmail ?? this.verifyEmail,
      auth: auth ?? this.auth,
      interests: interests ?? this.interests,
      feeds: feeds ?? this.feeds,
      tagSearch: tagSearch ?? this.tagSearch,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is AppState &&
        o.verifyEmail == verifyEmail &&
        o.auth == auth &&
        o.interests == interests &&
        o.feeds == feeds &&
        o.tagSearch == tagSearch &&
        o.isLoading == isLoading &&
        o.error == error;
  }

  @override
  int get hashCode {
    return verifyEmail.hashCode ^
        auth.hashCode ^
        interests.hashCode ^
        feeds.hashCode ^
        tagSearch.hashCode ^
        isLoading.hashCode ^
        error.hashCode;
  }

  @override
  String toString() {
    return 'AppState(verifyEmail: $verifyEmail, auth: $auth, interests: $interests, feeds: $feeds, tagSearch: $tagSearch, isLoading: $isLoading, error: $error)';
  }
}
