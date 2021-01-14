import 'dart:async';

import 'package:fans/models/models.dart';

class StartLoadingAction {}

class StopLoadingAction {}

// Verify Email Actions

class LocalVerifyEmailAction {
  final String email;

  LocalVerifyEmailAction(this.email);
}

class VerifyEmailAction {
  final String email;

  VerifyEmailAction(this.email);
}

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

class LoginAction {
  final String email;
  final String password;

  LoginAction(this.email, this.password);
}

class LoginSuccessAction {
  final User user;

  LoginSuccessAction(this.user);
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

class SignupSuccessAction {
  final User user;

  SignupSuccessAction(this.user);
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

class FetchFeedsStartLoadingAction {
  /// 类型选择( 0:following , 1:for you)
  final int type;

  FetchFeedsStartLoadingAction(this.type);
}

class FetchFeedsAction {
  /// 类型选择( 0:following , 1:for you)
  final int type;
  final int page;
  final Completer completer;

  FetchFeedsAction(this.type, this.page, this.completer);
}

class FeedsResponseAction {
  /// 类型选择( 0:following , 1:for you)
  final int type;
  final int totalPage;
  final int currentPage;
  final List<Goods> feeds;

  FeedsResponseAction(this.type, this.totalPage, this.currentPage, this.feeds);
}

class FeedsResponseFailedAction {
  /// 类型选择( 0:following , 1:for you)
  final int type;
  final String error;

  FeedsResponseFailedAction(this.type, this.error);
}

class FetchRecommendUsersAction {}

class RecommendUsersResponseAction {
  final List<User> users;

  RecommendUsersResponseAction(this.users);
}

class SearchByTagAction {
  final String userId;
  final int page;
  final String tag;
  final int limit;

  SearchByTagAction(
    this.userId,
    this.page,
    this.tag,
    this.limit,
  );
}
