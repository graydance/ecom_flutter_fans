import 'dart:async';

class FetchSellerInfoAction {
  final String userId;
  final Completer completer;

  FetchSellerInfoAction({
    this.userId,
    this.completer,
  });
}

class FetchIdolLinksAction {
  final String userId;
  final Completer completer;

  FetchIdolLinksAction({
    this.userId,
    this.completer,
  });
}

class FetchIdolGoodsAction {
  /// 0=商品分组(左)，1=标签分组(右)
  final int type;
  final String userId;
  final int page;
  final int limit;
  final Completer completer;

  FetchIdolGoodsAction(
      {this.type = 0, this.userId, this.page, this.limit, this.completer});
}
