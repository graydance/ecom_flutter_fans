import 'package:fans/store/actions.dart';
import 'package:fans/store/states.dart';
import 'package:fans/store/states/login_signup_state.dart';
import 'package:fans/store/states/verify_email_state.dart';
import 'package:redux/redux.dart';

final verifyEmailReducer = combineReducers<VerifyEmailState>([
  TypedReducer<VerifyEmailState, LocalVerifyEmailAction>(
      _setLocalVerifyEmailError),
  TypedReducer<VerifyEmailState, VerifyEmailSuccessAction>(_setEmail),
  TypedReducer<VerifyEmailState, VerifyEmailFailedAction>(_setVerifyEmailError),
]);

VerifyEmailState _setLocalVerifyEmailError(
    VerifyEmailState state, LocalVerifyEmailAction action) {
  var error = _validateEmail(action.email) ? '' : 'The email is invalid';
  return state.copyWith(error: error);
}

VerifyEmailState _setEmail(
    VerifyEmailState state, VerifyEmailSuccessAction action) {
  return state.copyWith(email: action.email);
}

VerifyEmailState _setVerifyEmailError(
    VerifyEmailState state, VerifyEmailFailedAction action) {
  return state.copyWith(error: action.error);
}

bool _validateEmail(String email) {
  return RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
}

// Login

final authReducer = combineReducers<LoginOrSignupState>([
  TypedReducer<LoginOrSignupState, CheckPasswordAction>(
      _setAuthCheckPasswordError),
]);

LoginOrSignupState _setAuthCheckPasswordError(
    LoginOrSignupState state, CheckPasswordAction action) {
  String password = action.password;
  return state.copyWith(
      error: password.length < 8 ? 'Make sure it’s at least 8 characters' : '');
}

// other

final validPasswordReducer = combineReducers<String>([
  TypedReducer<String, CheckPasswordAction>(_setCheckPasswordError),
]);

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

String _setCheckPasswordError(String state, CheckPasswordAction action) {
  String password = action.password;
  if (password.isEmpty || password.length >= 8) {
    return null;
  }
  return 'Make sure it’s at least 8 characters';
}

// Interests

final interestReducer = combineReducers<InterestListState>([
  TypedReducer<InterestListState, FetchInterestSuccessAction>(_setInterestList),
  TypedReducer<InterestListState, FetchInterestFailedAction>(
      _setInterestListError),
  TypedReducer<InterestListState, FetchInterestStartLoadingAction>(
      _setInterestListLoading),
]);

InterestListState _setInterestList(
    InterestListState state, FetchInterestSuccessAction action) {
  return state.copyWith(interests: action.interests);
}

InterestListState _setInterestListError(
    InterestListState state, FetchInterestFailedAction action) {
  return state.copyWith(error: action.error);
}

InterestListState _setInterestListLoading(
    InterestListState state, FetchInterestStartLoadingAction action) {
  return state.copyWith(isLoading: true);
}
