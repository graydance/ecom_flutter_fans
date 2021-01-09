import 'package:fans/models/models.dart';
import 'package:flutter/foundation.dart';

class StartLoadingAction {}

class StopLoadingAction {}

// Verify Email Actions

class LocalVerifyEmailAction {
  final String email;

  LocalVerifyEmailAction(this.email);
}

class VerifyEmailAction {
  final String email;

  VerifyEmailAction(this.email);
}

class VerifyEmailSuccessAction {
  final String email;

  VerifyEmailSuccessAction(this.email);
}

class VerifyEmailFailedAction {
  final String error;

  VerifyEmailFailedAction(this.error);
}

class CheckPasswordAction {
  final String password;

  CheckPasswordAction(this.password);
}

class LoginAction {
  final String email;
  final String password;

  LoginAction(this.email, this.password);
}

class LoginSuccessAction {
  final User user;

  LoginSuccessAction(this.user);
}

class LoginFailureAction {
  final String error;

  LoginFailureAction(this.error);
}

class SignupAction {
  final String email;
  final String password;

  SignupAction(this.email, this.password);
}

class SignupSuccessAction {
  final User user;

  SignupSuccessAction(this.user);
}

class SignupFailureAction {
  final String error;

  SignupFailureAction(this.error);
}

class SendEmailFailureAction {
  final String error;

  SendEmailFailureAction(this.error);
}

class SendEmailAction {
  final String email;

  SendEmailAction(this.email);
}

class FetchInterestStartLoadingAction {}

class FetchInterestAction {}

class FetchInterestSuccessAction {
  final List<Interest> interests;

  FetchInterestSuccessAction(this.interests);
}

class InterestsFailedAction {
  final String error;

  InterestsFailedAction(this.error);
}

class UploadInterestsAction {
  final List<String> idList;

  UploadInterestsAction(this.idList);
}

// Other

class LoadHotsAction {}

class HotsNotLoadedAction {
  final String msg;
  HotsNotLoadedAction(this.msg);
}

class HotsLoadedAction {
  final List<Idol> hotIdols;
  final List<Goods> hotGoods;
  final int cart;

  HotsLoadedAction(this.hotIdols, this.hotGoods, this.cart);

  @override
  String toString() {
    return 'HotsLoadedAction{hotIdols: $hotIdols hotGoods: $hotGoods cart: $cart}';
  }
}
