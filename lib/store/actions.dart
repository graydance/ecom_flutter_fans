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

class ClientCheckEmailAction {
  final String email;
  ClientCheckEmailAction(this.email);
}

class CheckEmailAction {
  final String email;
  CheckEmailAction(this.email);
}

class CheckEmailFailureAction {
  final String error;
  CheckEmailFailureAction(this.error);
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

class SetEmailAction {
  final String email;

  SetEmailAction(this.email);
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

class SendEmailFailureAction {
  final String error;

  SendEmailFailureAction(this.error);
}

class SendEmailAction {
  final String email;
  final String password;

  SendEmailAction(this.email, this.password);
}
