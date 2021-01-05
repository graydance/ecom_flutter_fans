import 'package:fans/store/actions.dart';
import 'package:redux/redux.dart';

final authReducer = combineReducers<bool>([
  TypedReducer<bool, EmailCheckedAction>(_setIsRegist),
]);

bool _setIsRegist(bool state, EmailCheckedAction action) {
  return action.isRegist;
}

final clientValidEmailReducer = combineReducers<String>([
  TypedReducer<String, LocalCheckEmailAction>(_setCheckEmailError),
]);

String _setCheckEmailError(String state, LocalCheckEmailAction action) {
  if (action.email.isEmpty || _validateEmail(action.email)) {
    return null;
  }
  return 'The email is invalid';
}

bool _validateEmail(String email) {
  return RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
}

final setEmailReducer = combineReducers<String>([
  TypedReducer<String, LocalCheckEmailAction>(_setEmail),
]);

String _setEmail(String state, LocalCheckEmailAction action) {
  if (!_validateEmail(action.email)) {
    return state;
  }
  return action.email;
}

final errorReducer = combineReducers<String>([
  TypedReducer<String, RemoteCheckEmailFailureAction>(
      _setRemoteCheckEmailError),
  TypedReducer<String, CheckPasswordAction>(_setCheckPasswordError),
  TypedReducer<String, LoginFailureAction>(_setLoginError),
  TypedReducer<String, SendEmailFailureAction>(_setSendEmailError),
]);

String _setRemoteCheckEmailError(
    String state, RemoteCheckEmailFailureAction action) {
  return action.error;
}

String _setLoginError(String state, LoginFailureAction action) {
  return action.error;
}

String _setSendEmailError(String state, SendEmailFailureAction action) {
  return action.error;
}

String _setCheckPasswordError(String state, CheckPasswordAction action) {
  String password = action.password;
  if (password.isEmpty || password.length >= 8) {
    return null;
  }
  return 'Make sure it’s at least 8 characters';
}
