import 'package:meta/meta.dart';

import 'package:fans/store/states.dart';

@immutable
class AppState {
  final VerifyEmailState verifyEmail;
  final LoginOrSignupState auth;
  final InterestListState interests;
  final HomeState feeds;
  final SearchByTagState tagSearch;
  final ShopDetailState shopDetail;

  AppState({
    this.verifyEmail = const VerifyEmailState(),
    this.auth = const LoginOrSignupState(),
    this.interests = const InterestListState(),
    this.feeds = const HomeState(),
    this.tagSearch = const SearchByTagState(),
    this.shopDetail = const ShopDetailState(),
  });

  factory AppState.init() => AppState();

  AppState copyWith({
    VerifyEmailState verifyEmail,
    LoginOrSignupState auth,
    InterestListState interests,
    HomeState feeds,
    SearchByTagState tagSearch,
    ShopDetailState shopDetail,
    bool isLoading,
    String error,
  }) {
    return AppState(
      verifyEmail: verifyEmail ?? this.verifyEmail,
      auth: auth ?? this.auth,
      interests: interests ?? this.interests,
      feeds: feeds ?? this.feeds,
      tagSearch: tagSearch ?? this.tagSearch,
      shopDetail: shopDetail ?? this.shopDetail,
    );
  }

  @override
  String toString() {
    return 'AppState(verifyEmail: $verifyEmail, auth: $auth, interests: $interests, feeds: $feeds, tagSearch: $tagSearch, shopDetail: $shopDetail)';
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
        o.shopDetail == shopDetail;
  }

  @override
  int get hashCode {
    return verifyEmail.hashCode ^
        auth.hashCode ^
        interests.hashCode ^
        feeds.hashCode ^
        tagSearch.hashCode ^
        shopDetail.hashCode;
  }
}
