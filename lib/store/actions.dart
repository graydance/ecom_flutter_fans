import 'package:fans/models/models.dart';

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

class LocalCheckEmailAction {
  final String email;

  LocalCheckEmailAction(this.email);
}

class RemoteCheckEmailAction {
  final String email;

  RemoteCheckEmailAction(this.email);
}

class RemoteCheckEmailFailureAction {
  final String error;

  RemoteCheckEmailFailureAction(this.error);
}

class EmailCheckedAction {
  final bool isRegist;
  final String error;

  EmailCheckedAction(this.isRegist, this.error);

  @override
  String toString() {
    return 'EmailCheckedAction{is_regist: $isRegist error: $error}';
  }
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

class LoginFailureAction {
  final String error;

  LoginFailureAction(this.error);
}

class SignupAction {
  final String email;
  final String password;

  SignupAction(this.email, this.password);
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
