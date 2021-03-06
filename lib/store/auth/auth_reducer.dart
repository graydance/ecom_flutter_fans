import 'package:fans/storage/auth_storage.dart';
import 'package:redux/redux.dart';

import 'package:fans/store/actions.dart';
import 'package:fans/store/states.dart';
import 'package:fans/store/auth/login_signup_state.dart';
import 'package:fans/store/auth/verify_email_state.dart';

final verifyEmailReducer = combineReducers<VerifyEmailState>([
  TypedReducer<VerifyEmailState, LocalVerifyEmailAction>(
      _setLocalVerifyEmailError),
  TypedReducer<VerifyEmailState, VerifyEmailLoadingAction>(_setLoading),
  TypedReducer<VerifyEmailState, VerifyEmailSuccessAction>(_setEmail),
  TypedReducer<VerifyEmailState, VerifyEmailFailedAction>(_setVerifyEmailError),
]);

VerifyEmailState _setLocalVerifyEmailError(
    VerifyEmailState state, LocalVerifyEmailAction action) {
  var error = _validateEmail(action.email) ? '' : 'The email is invalid';
  return state.copyWith(error: error);
}

VerifyEmailState _setLoading(
    VerifyEmailState state, VerifyEmailLoadingAction action) {
  return state.copyWith(isLoading: true, error: '');
}

VerifyEmailState _setEmail(
    VerifyEmailState state, VerifyEmailSuccessAction action) {
  return state.copyWith(email: action.email, isLoading: false, error: '');
}

VerifyEmailState _setVerifyEmailError(
    VerifyEmailState state, VerifyEmailFailedAction action) {
  return state.copyWith(isLoading: false, error: action.error);
}

bool _validateEmail(String email) {
  return RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
}

// Login

final authReducer = combineReducers<LoginOrSignupState>([
  TypedReducer<LoginOrSignupState, OnAuthenticatedAction>(_setAuthed),
  TypedReducer<LoginOrSignupState, CheckPasswordAction>(
      _setAuthCheckPasswordError),
  TypedReducer<LoginOrSignupState, AuthLoadingAction>(
      _setAuthCheckPasswordLoading),
  TypedReducer<LoginOrSignupState, LoginOrSignupFailureAction>(_setAuthError),
  TypedReducer<LoginOrSignupState, SendEmailFailureAction>(_setSendEmailError),
  TypedReducer<LoginOrSignupState, LocalUpdateUserAction>(_onUserLocalUpdate),
  TypedReducer<LoginOrSignupState, UpdateUserAction>(_onUserUpdate),
]);

LoginOrSignupState _setAuthed(
    LoginOrSignupState state, OnAuthenticatedAction action) {
  return state.copyWith(user: action.user, isLoading: false, error: '');
}

LoginOrSignupState _setAuthCheckPasswordError(
    LoginOrSignupState state, CheckPasswordAction action) {
  String password = action.password;
  return state.copyWith(
      error: password.length < 8 ? 'Make sure it’s at least 8 characters' : '',
      isLoading: false);
}

LoginOrSignupState _setAuthCheckPasswordLoading(
    LoginOrSignupState state, AuthLoadingAction action) {
  return state.copyWith(isLoading: true, error: '');
}

LoginOrSignupState _setAuthError(
    LoginOrSignupState state, LoginOrSignupFailureAction action) {
  return state.copyWith(isLoading: false, error: action.error);
}

LoginOrSignupState _setSendEmailError(
    LoginOrSignupState state, SendEmailFailureAction action) {
  return state.copyWith(isLoading: false, error: action.error);
}

// Interests

final interestReducer = combineReducers<InterestListState>([
  TypedReducer<InterestListState, FetchInterestSuccessAction>(_setInterestList),
  TypedReducer<InterestListState, InterestsFailedAction>(_setInterestListError),
  TypedReducer<InterestListState, FetchInterestStartLoadingAction>(
      _setInterestListLoading),
  TypedReducer<InterestListState, UploadInterestsSuccessAction>(
      _setUploadInterestsSuccess),
]);

InterestListState _setInterestList(
    InterestListState state, FetchInterestSuccessAction action) {
  return state.copyWith(
      interests: action.interests, isLoading: false, error: '');
}

InterestListState _setInterestListError(
    InterestListState state, InterestsFailedAction action) {
  return state.copyWith(isLoading: false, error: action.error);
}

InterestListState _setInterestListLoading(
    InterestListState state, FetchInterestStartLoadingAction action) {
  return state.copyWith(isLoading: true, error: '');
}

InterestListState _setUploadInterestsSuccess(
    InterestListState state, UploadInterestsSuccessAction action) {
  return state.copyWith(isLoading: false, error: '');
}

// User Reducer

LoginOrSignupState _onUserUpdate(
    LoginOrSignupState state, UpdateUserAction action) {
  AuthStorage.setToken(action.user.token);
  AuthStorage.setUser(action.user);
  return state.copyWith(user: action.user);
}

LoginOrSignupState _onUserLocalUpdate(
    LoginOrSignupState state, LocalUpdateUserAction action) {
  AuthStorage.setToken(action.user.token);
  AuthStorage.setUser(action.user);
  return state.copyWith(user: action.user);
}
