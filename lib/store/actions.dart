export './auth/auth_action.dart';
export './product/product_action.dart';
export './shop/shop_action.dart';

import 'dart:async';

import 'package:fans/models/models.dart';

class ShowSearchByTagAction {
  final Feed feed;
  final String tag;

  ShowSearchByTagAction({this.feed, this.tag});
}

class SearchByTagAction {
  final String userId;
  final String tag;
  final int page;
  final int limit;
  final Completer completer;

  SearchByTagAction(
      {this.userId, this.tag, this.page, this.limit, this.completer});
}

class SearchByTagSuccessAction {
  final String userId;
  final String tag;
  final int totalPage;
  final int currentPage;
  final List<Feed> feeds;

  SearchByTagSuccessAction(
      this.userId, this.tag, this.totalPage, this.currentPage, this.feeds);
}

class PayCaptureAction {
  final String payNumber;
  final Completer completer;

  PayCaptureAction(this.payNumber, this.completer);
}

class PayQueryAction {
  final String orderId;
  final String payName;
  final Completer completer;

  PayQueryAction(this.orderId, this.payName, this.completer);
}
