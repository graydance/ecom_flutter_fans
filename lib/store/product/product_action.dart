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

class FetchFeedsSuccessAction {
  /// 类型选择( 0:following , 1:for you)
  final int type;
  final int totalPage;
  final int currentPage;
  final List<Feed> feeds;

  FetchFeedsSuccessAction(
      this.type, this.totalPage, this.currentPage, this.feeds);
}

class FetchFeedsFailedAction {
  /// 类型选择( 0:following , 1:for you)
  final int type;
  final String error;

  FetchFeedsFailedAction(this.type, this.error);
}

class FetchRecommendSellersAction {}

class FetchRecommendSellersSuccessAction {
  final List<Feed> sellers;

  FetchRecommendSellersSuccessAction(this.sellers);
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

class FetchShopDetailSuccessAction {
  final Feed seller;

  FetchShopDetailSuccessAction({this.seller});
}

class FetchShopDetailFailedAction {
  final String error;

  FetchShopDetailFailedAction({this.error});
}

class FetchGoodsAction {
  /// 0=商品分组(左)，1=标签分组(右)
  final int type;
  final String userId;
  final int page;
  final int limit;
  final Completer completer;

  FetchGoodsAction(
      {this.type, this.userId, this.page, this.limit, this.completer});
}

class FetchGoodsSuccessAction {
  final int type;
  final int totalPage;
  final int currentPage;
  final List<Goods> list;

  FetchGoodsSuccessAction(
      {this.type, this.totalPage, this.currentPage, this.list});
}

class FetchGoodsFailedAction {
  final int type;
  final String error;

  FetchGoodsFailedAction({this.type, this.error});
}
