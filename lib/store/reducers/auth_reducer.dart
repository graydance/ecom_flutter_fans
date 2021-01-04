import 'package:fans/store/actions.dart';
import 'package:redux/redux.dart';

final authReducer = combineReducers<bool>([
  TypedReducer<bool, EmailCheckedAction>(_setIsRegist),
]);

bool _setIsRegist(bool state, EmailCheckedAction action) {
  return action.isRegist;
}

final clientValidEmailReducer = combineReducers<String>([
  TypedReducer<String, CheckEmailFailureAction>(_setEmailError),
]);

String _setEmailError(String state, CheckEmailFailureAction action) {
  return action.error;
}

final setEmailReducer = combineReducers<String>([
  TypedReducer<String, SetEmailAction>(_setEmail),
]);

String _setEmail(String state, SetEmailAction action) {
  return action.email;
}

final errorReducer = combineReducers<String>([
  TypedReducer<String, LoginFailureAction>(_setLoginError),
  TypedReducer<String, SendEmailFailureAction>(_setSendEmailError),
]);

String _setLoginError(String state, LoginFailureAction action) {
  return action.error;
}

String _setSendEmailError(String state, SendEmailFailureAction action) {
  return action.error;
}
