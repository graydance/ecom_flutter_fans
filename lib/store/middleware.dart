import 'package:fans/api.dart';
import 'package:fans/app.dart';
import 'package:fans/store/actions.dart';
import 'package:redux/redux.dart';
import 'package:fans/models/models.dart';

List<Middleware<AppState>> createStoreMiddleware() {
  final loadHots = _createLoadHots();
  final checkEmail = _createCheckEmail();
  final login = _createLogin();
  final sendEmail = _createSendEmail();
  final signup = _createSignup();

  return [
    TypedMiddleware<AppState, LoadHotsAction>(loadHots),
    TypedMiddleware<AppState, RemoteCheckEmailAction>(checkEmail),
    TypedMiddleware<AppState, LoginAction>(login),
    TypedMiddleware<AppState, SignupAction>(signup),
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

Middleware<AppState> _createCheckEmail() {
  return (Store<AppState> store, action, NextDispatcher next) {
    if (action is RemoteCheckEmailAction) {
      String email = action.email;
      bool emailValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(email);
      if (!emailValid) {
        store.dispatch(RemoteCheckEmailFailureAction('The email is invalid'));
      } else if (email == '1@1.com') {
        store.dispatch(
            RemoteCheckEmailFailureAction('The email has been register!'));
      } else if (email == '2@2.com') {
        navigatorKey.currentState.pushNamed('/signup');
      } else {
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

Middleware<AppState> _createSignup() {
  return (Store<AppState> store, action, NextDispatcher next) {
    if (action is SignupAction) {
      // String email = action.email;
      String password = action.password;
      if (password.isEmpty || password.length < 8) {
        store.dispatch(SignupFailureAction('Signup failure'));
      } else {
        navigatorKey.currentState.pushNamed('/forgotpwd');
      }
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
