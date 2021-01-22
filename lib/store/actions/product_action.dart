import 'dart:async';

import 'package:fans/models/models.dart';
import 'package:fans/models/feed.dart';

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

class FetchRecommendSellersAction {}

class RecommendSellersResponseAction {
  final List<Feed> sellers;

  RecommendSellersResponseAction(this.sellers);
}
