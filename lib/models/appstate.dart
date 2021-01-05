import 'package:fans/models/models.dart';
import 'package:meta/meta.dart';

@immutable
class AppState {
  final bool isLoading;
  final String error;
  final String hotLoadError;
  final List<Idol> hotIdols;
  final List<Goods> hotGoods;
  final int cart;
  final bool isRegist;
  final String emailCheckError;
  final String email;
  final String passwordCheckError;

  AppState(
      {this.isLoading = false,
      this.error,
      this.hotLoadError = '',
      this.hotIdols = const [],
      this.hotGoods = const [],
      this.cart = 0,
      this.isRegist = false,
      this.emailCheckError,
      this.email = '',
      this.passwordCheckError});

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
      isRegist: isRegist ?? this.isRegist,
      emailCheckError: emailValidError ?? this.emailCheckError,
      email: email ?? this.email,
      passwordCheckError: passwordCheckError ?? this.passwordCheckError,
    );
  }

  @override
  int get hashCode =>
      isLoading.hashCode ^
      hotLoadError.hashCode ^
      hotIdols.hashCode ^
      hotGoods.hashCode ^
      cart.hashCode ^
      isRegist.hashCode ^
      emailCheckError.hashCode ^
      email.hashCode ^
      passwordCheckError.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          hotLoadError == other.hotLoadError &&
          hotIdols == other.hotIdols &&
          hotGoods == other.hotGoods &&
          cart == other.cart &&
          isRegist == other.isRegist &&
          emailCheckError == other.emailCheckError &&
          email == other.email &&
          passwordCheckError == other.passwordCheckError;

  @override
  String toString() {
    return 'AppState{isLoading: $isLoading, hotLoadError:$hotLoadError hotIdols: $hotIdols hotGoods:$hotGoods cart:$cart isRegist:$isRegist emailValidError:$emailCheckError email:$email passwordCheckError:$passwordCheckError}';
  }
}
