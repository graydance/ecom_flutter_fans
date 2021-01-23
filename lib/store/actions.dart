export './actions/auth_action.dart';
export './actions/product_action.dart';

import 'dart:async';

import 'package:fans/models/models.dart';

class ShowSearchByTagAction {
  final String userId;
  final String tag;

  ShowSearchByTagAction({this.userId, this.tag});
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

class SearchByTagSuccessAction {
  final int totalPage;
  final int currentPage;
  final List<Feed> feeds;

  SearchByTagSuccessAction(this.totalPage, this.currentPage, this.feeds);
}
