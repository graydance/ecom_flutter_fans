import 'dart:async';

import 'package:fans/models/models.dart';

class FetchSellerInfoAction {
  final String userName;
  final Completer completer;

  FetchSellerInfoAction({
    this.userName,
    this.completer,
  });
}

class FetchIdolLinksAction {
  final String userName;
  final Completer completer;

  FetchIdolLinksAction({
    this.userName,
    this.completer,
  });
}

class FetchIdolGoodsAction {
  /// 0=商品分组(左)，1=标签分组(右)
  final int type;
  final String userName;
  final int page;
  final int limit;
  final Completer completer;

  FetchIdolGoodsAction(
      {this.type = 0, this.userName, this.page, this.limit, this.completer});
}

class ShowCouponAction {
  final Completer completer;

  ShowCouponAction(this.completer);
}

class FetchConfigAction {}

class OnUpdateConfigAction {
  final Config config;

  OnUpdateConfigAction(this.config);
}
