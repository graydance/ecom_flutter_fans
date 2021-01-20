export './actions/auth_action.dart';

import 'dart:async';

import 'package:fans/models/models.dart';

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
  final List<Feed> feeds;

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
  final Completer completer;

  SearchByTagAction(
      {this.userId, this.page, this.tag, this.limit, this.completer});
}

class SearchByTagResponseAction {
  final int totalPage;
  final int currentPage;
  final List<Goods> feeds;

  SearchByTagResponseAction(this.totalPage, this.currentPage, this.feeds);
}

class ShowShopDetailAction {
  final String userId;

  ShowShopDetailAction({
    this.userId,
  });
}

class FetchShopDetailAction {
  final String userId;

  FetchShopDetailAction({
    this.userId,
  });
}

class ShopDetailResponseAction {
  final User user;

  ShopDetailResponseAction({this.user});
}

class ShopDetailFailedAction {
  final String error;

  ShopDetailFailedAction({this.error});
}
