import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:redux/redux.dart';

import 'package:fans/api.dart';
import 'package:fans/app.dart';
import 'package:fans/models/models.dart';
import 'package:fans/store/actions.dart';

List<Middleware<AppState>> createStoreMiddleware() {
  final verifyEmail = _createVerifyEmail();
  final login = _createLogin();
  final sendEmail = _createSendEmail();
  final signup = _createSignup();

  return [
    TypedMiddleware<AppState, VerifyEmailAction>(verifyEmail),
    TypedMiddleware<AppState, LoginAction>(login),
    TypedMiddleware<AppState, SignupAction>(signup),
    TypedMiddleware<AppState, SendEmailAction>(sendEmail),
  ];
}

Middleware<AppState> _createVerifyEmail() {
  return (Store<AppState> store, action, NextDispatcher next) {
    if (action is VerifyEmailAction) {
      EasyLoading.show();
      var email = action.email;
      api('/user/login', {'email': email, 'password': ''})
          .whenComplete(() => EasyLoading.dismiss())
          .then(
        (data) {
          var code = data['code'];
          if (code == 401) {
            // 用户不存在
            store.dispatch(VerifyEmailSuccessAction(email));
            Keys.navigatorKey.currentState.pushNamed(Routes.signup);
          } else if (code == 402) {
            // 邮箱已注册
            store.dispatch(VerifyEmailSuccessAction(email));
            Keys.navigatorKey.currentState.pushNamed(Routes.login);
          } else {
            EasyLoading.showToast(data['msg'].toString());
          }
        },
      ).catchError((error) => EasyLoading.showToast(error.toString()));
    }
    next(action);
  };
}

Middleware<AppState> _createLogin() {
  return (Store<AppState> store, action, NextDispatcher next) {
    if (action is LoginAction) {
      EasyLoading.show();
      api('/user/login', {'email': action.email, 'password': action.password})
          .whenComplete(() => EasyLoading.dismiss())
          .then(
        (data) {
          if (data['code'] == 0) {
            store.dispatch(LoginSuccessAction(User.fromJson(data['data'])));
            Keys.navigatorKey.currentState.pushReplacementNamed(Routes.home);
          } else {
            // store.dispatch(LoginFailureAction(data['msg'].toString()));
            EasyLoading.showToast(data['msg'].toString());
          }
        },
      ).catchError((err) => EasyLoading.showToast(err.toString()));
    }
    next(action);
  };
}

Middleware<AppState> _createSignup() {
  return (Store<AppState> store, action, NextDispatcher next) {
    if (action is SignupAction) {
      EasyLoading.show();
      api('/user/login', {'email': action.email, 'password': action.password})
          .whenComplete(() => EasyLoading.dismiss())
          .then(
        (data) {
          if (data['code'] == 0) {
            store.dispatch(SignupSuccessAction(User.fromJson(data['data'])));
            Keys.navigatorKey.currentState.pushReplacementNamed(Routes.home);
          } else {
            EasyLoading.showToast(data['msg'].toString());
            // store.dispatch(SignupFailureAction(data['msg'].toString()));
          }
        },
      ).catchError((err) => EasyLoading.showToast(err.toString()));
    }
    next(action);
  };
}

Middleware<AppState> _createSendEmail() {
  return (Store<AppState> store, action, NextDispatcher next) {
    if (action is SendEmailAction) {
      // String email = action.email;
      store.dispatch(SendEmailFailureAction('Send email failure'));
    }
    next(action);
  };
}
