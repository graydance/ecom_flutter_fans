export './actions/auth_action.dart';
export './actions/product_action.dart';

import 'dart:async';

import 'package:fans/models/models.dart';

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
  final Seller seller;

  ShopDetailResponseAction({this.seller});
}

class ShopDetailFailedAction {
  final String error;

  ShopDetailFailedAction({this.error});
}
