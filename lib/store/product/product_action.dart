import 'dart:async';

import 'package:flutter/material.dart';

import 'package:fans/models/feed.dart';
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

class ShowProductDetailAction {
  final String idolGoodsId;

  ShowProductDetailAction(this.idolGoodsId);
}

class FetchProductDetailAction {
  final String idolGoodsId;
  final Completer completer;

  FetchProductDetailAction(this.idolGoodsId, this.completer);
}

class FetchProductDetailSuccessAction {
  final Product product;

  FetchProductDetailSuccessAction(this.product);
}

class PreOrderAction {
  final List<OrderParameters> buyGoods;
  final Completer completer;

  PreOrderAction({@required this.buyGoods, this.completer});
}

class PreOrderSuccessAction {
  final OrderDetail orderDetail;

  PreOrderSuccessAction({
    this.orderDetail,
  });
}

class OrderAction {
  final List<OrderParameters> buyGoods;
  final String shippingAddressId;
  final String billingAddressId;
  final Completer completer;

  OrderAction(this.buyGoods, this.shippingAddressId, this.billingAddressId,
      this.completer);
}

class PayAction {
  final String orderId;
  final String payName;
  final Completer completer;

  PayAction(this.orderId, this.payName, this.completer);
}

class AddCartAction {
  final OrderParameters parameters;
  final Completer completer;

  AddCartAction(this.parameters, this.completer);
}

class FetchCartListAction {
  final Completer completer;

  FetchCartListAction(this.completer);
}

class OnUpdateCartAction {
  final Cart cart;

  OnUpdateCartAction(this.cart);
}
