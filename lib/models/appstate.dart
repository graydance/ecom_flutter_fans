import 'package:meta/meta.dart';

import 'package:fans/models/models.dart';
import 'package:fans/store/states.dart';

@immutable
class AppState {
  final VerifyEmailState verifyEmail;
  final LoginOrSignupState auth;

  final bool isLoading;
  final String error;
  final String hotLoadError;
  final List<Idol> hotIdols;
  final List<Goods> hotGoods;
  final int cart;

  AppState({
    this.verifyEmail = const VerifyEmailState(),
    this.auth = const LoginOrSignupState(),
    this.isLoading = false,
    this.error,
    this.hotLoadError = '',
    this.hotIdols = const [],
    this.hotGoods = const [],
    this.cart = 0,
  });

  factory AppState.loading() => AppState(isLoading: true);

  AppState copyWith(
      {bool isLoading,
      String error,
      String hotLoadError,
      List<Idol> hotIdols,
      List<Goods> hotGoods,
      int cart,
      bool isRegist,
      String emailValidError,
      String email,
      String passwordCheckError}) {
    return AppState(
      isLoading: isLoading ?? this.isLoading,
      hotLoadError: hotLoadError ?? this.hotLoadError,
      hotIdols: hotIdols ?? this.hotIdols,
      hotGoods: hotGoods ?? this.hotGoods,
      cart: cart ?? this.cart,
    );
  }

  @override
  int get hashCode =>
      isLoading.hashCode ^
      hotLoadError.hashCode ^
      hotIdols.hashCode ^
      hotGoods.hashCode ^
      cart.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          hotLoadError == other.hotLoadError &&
          hotIdols == other.hotIdols &&
          hotGoods == other.hotGoods &&
          cart == other.cart;

  @override
  String toString() {
    return 'AppState(verifyEmail: $verifyEmail, login: $auth, isLoading: $isLoading, error: $error, hotLoadError: $hotLoadError, hotIdols: $hotIdols, hotGoods: $hotGoods, cart: $cart)';
  }
}
