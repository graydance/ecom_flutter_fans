import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import 'package:fans/models/models.dart';
import 'package:fans/store/states.dart';

@immutable
class AppState {
  final VerifyEmailState verifyEmail;
  final LoginOrSignupState auth;
  final InterestListState interests;
  final HomeState feeds;
  final SearchByTagStateList tagSearch;
  final ShopDetailState shopDetail;
  final ProductDetailsOnScreen productDetails;
  final PreOrderState preOrder;
  final Cart cart;

  AppState({
    this.verifyEmail = const VerifyEmailState(),
    this.auth = const LoginOrSignupState(),
    this.interests = const InterestListState(),
    this.feeds = const HomeState(),
    this.tagSearch = const SearchByTagStateList(),
    this.shopDetail = const ShopDetailState(),
    this.productDetails = const ProductDetailsOnScreen(),
    this.preOrder = const PreOrderState(),
    this.cart = const Cart(),
  });

  factory AppState.init() => AppState();

  AppState copyWith({
    User user,
    VerifyEmailState verifyEmail,
    LoginOrSignupState auth,
    InterestListState interests,
    HomeState feeds,
    SearchByTagStateList tagSearch,
    ShopDetailState shopDetail,
    ProductDetailsOnScreen productDetails,
    PreOrderState preOrder,
    Cart cart,
  }) {
    return AppState(
      verifyEmail: verifyEmail ?? this.verifyEmail,
      auth: auth ?? this.auth,
      interests: interests ?? this.interests,
      feeds: feeds ?? this.feeds,
      tagSearch: tagSearch ?? this.tagSearch,
      shopDetail: shopDetail ?? this.shopDetail,
      productDetails: productDetails ?? this.productDetails,
      preOrder: preOrder ?? this.preOrder,
      cart: cart ?? this.cart,
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
        o.shopDetail == shopDetail &&
        o.productDetails == productDetails &&
        o.preOrder == preOrder &&
        o.cart == cart;
  }

  @override
  int get hashCode {
    return verifyEmail.hashCode ^
        auth.hashCode ^
        interests.hashCode ^
        feeds.hashCode ^
        tagSearch.hashCode ^
        shopDetail.hashCode ^
        productDetails.hashCode ^
        preOrder.hashCode ^
        cart.hashCode;
  }

  @override
  String toString() {
    return 'AppState(verifyEmail: $verifyEmail, auth: $auth, interests: $interests, feeds: $feeds, tagSearch: $tagSearch, shopDetail: $shopDetail, productDetails: $productDetails, preOrder: $preOrder, cart: $cart)';
  }
}
