import 'package:fans/api.dart';
import 'package:fans/app.dart';
import 'package:fans/store/actions.dart';
import 'package:redux/redux.dart';
import 'package:fans/models/models.dart';

List<Middleware<AppState>> createStoreMiddleware() {
  final loadHots = _createLoadHots();
  final checkEmail = _createCheckEmail();
  final clientCheckEmail = _createClientCheckEmail();
  final login = _createLogin();
  final checkPasswrod = _createCheckPassword();
  final sendEmail = _createSendEmail();

  return [
    TypedMiddleware<AppState, LoadHotsAction>(loadHots),
    TypedMiddleware<AppState, CheckEmailAction>(checkEmail),
    TypedMiddleware<AppState, ClientCheckEmailAction>(clientCheckEmail),
    TypedMiddleware<AppState, LoginAction>(login),
    TypedMiddleware<AppState, CheckPasswordAction>(checkPasswrod),
    TypedMiddleware<AppState, SendEmailAction>(sendEmail),
  ];
}

Middleware<AppState> _createLoadHots() {
  return (Store<AppState> store, action, NextDispatcher next) {
    api('/hots', {}, '').then(
      (hots) {
        store.dispatch(
            HotsLoadedAction(hots['idols'], hots['goods'], hots['cart']));
      },
    ).catchError((err) => store.dispatch(HotsNotLoadedAction(err.toString())));
    next(action);
  };
}

Middleware<AppState> _createClientCheckEmail() {
  return (Store<AppState> store, action, NextDispatcher next) {
    if (action is ClientCheckEmailAction) {
      String email = action.email;
      bool emailValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(email);
      if (!emailValid) {
        store.dispatch(CheckEmailFailureAction('The email is invalid'));
      } else {
        store.dispatch(CheckEmailFailureAction(null));
      }
    }
    next(action);
  };
}

Middleware<AppState> _createCheckEmail() {
  return (Store<AppState> store, action, NextDispatcher next) {
    if (action is CheckEmailAction) {
      String email = action.email;
      bool emailValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(email);
      if (!emailValid) {
        store.dispatch(CheckEmailFailureAction('The email is invalid'));
      } else if (email == '1@1.com') {
        store.dispatch(CheckEmailFailureAction('The email has been register!'));
      } else {
        store.dispatch(SetEmailAction(email));
        navigatorKey.currentState.pushNamed('/login');
      }
    }
    next(action);
  };
}

Middleware<AppState> _createLogin() {
  return (Store<AppState> store, action, NextDispatcher next) {
    if (action is LoginAction) {
      // String email = action.email;
      String password = action.password;
      if (password.isEmpty || password.length < 8) {
        store.dispatch(LoginFailureAction('Login failure'));
      } else {
        navigatorKey.currentState.pushNamed('/forgotpwd');
      }
    }
    next(action);
  };
}

Middleware<AppState> _createCheckPassword() {
  return (Store<AppState> store, action, NextDispatcher next) {
    if (action is CheckPasswordAction) {
      String password = action.password;
      if (password.isEmpty || password.length < 8) {
        store.dispatch(
            LoginFailureAction('Make sure it’s at least 8 characters'));
      } else {
        store.dispatch(LoginFailureAction(null));
      }
    }
    next(action);
  };
}

Middleware<AppState> _createSendEmail() {
  return (Store<AppState> store, action, NextDispatcher next) {
    if (action is SendEmailAction) {
      // String email = action.email;
      // String password = action.password;
      store.dispatch(SendEmailFailureAction('Send email failure'));
    }
    next(action);
  };
}
