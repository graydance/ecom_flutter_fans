import 'dart:async';

import 'package:fans/models/models.dart';

class VerifyAuthenticationState {}

class AnonymousLoginAction {}

class LocalVerifyEmailAction {
  final String email;

  LocalVerifyEmailAction(this.email);
}

class OnAuthenticatedAction {
  final User user;

  OnAuthenticatedAction(this.user);
}

class LocalUpdateUserAction {
  final User user;

  LocalUpdateUserAction(this.user);
}

class UpdateUserAction {
  final User user;
  final Completer completer;

  UpdateUserAction(this.user, this.completer);
}

class VerifyEmailAction {
  final String email;

  VerifyEmailAction(this.email);
}

class VerifyEmailLoadingAction {}

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

class AuthLoadingAction {}

class LoginAction {
  final String email;
  final String password;

  LoginAction(this.email, this.password);
}

class LoginOrSignupFailureAction {
  final String error;

  LoginOrSignupFailureAction(this.error);
}

class SignupAction {
  final String email;
  final String password;

  SignupAction(this.email, this.password);
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

class UploadInterestsSuccessAction {}

class SignInAction {
  final String email;
  final String password;
  final Completer completer;

  SignInAction(this.email, this.password, this.completer);
}
