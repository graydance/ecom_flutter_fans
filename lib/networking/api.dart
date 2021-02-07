import 'dart:convert';
import 'dart:math';

import 'package:fans/models/models.dart';
import 'package:flutter/material.dart';

enum HttpMethod { GET, POST }

extension HttpMethodExt on HttpMethod {
  String get value {
    switch (this) {
      case HttpMethod.GET:
        return 'GET';
      case HttpMethod.POST:
        return 'POST';
      default:
        return 'GET';
    }
  }
}

abstract class TargetType {
  String get path;
  HttpMethod get method;
  Map<String, dynamic> get parameters;
}

class API extends TargetType {
  @override
  HttpMethod get method {
    return HttpMethod.POST;
  }

  @override
  Map<String, dynamic> get parameters => Map();

  @override
  String get path => throw UnimplementedError();
}

@immutable
class LoginAPI extends API {
  final String email;
  final String password;

  LoginAPI({@required this.email, this.password = ''});

  @override
  Map<String, dynamic> get parameters => {'email': email, 'password': password};

  @override
  String get path => '/user/pub/login';
}

class InterestListAPI extends API {
  @override
  String get path => '/user/interest_list';
}

class UploadInterestsAPI extends API {
  final List<String> interestIdList;

  UploadInterestsAPI(this.interestIdList);

  @override
  Map<String, dynamic> get parameters => {'interestIdList': interestIdList};

  @override
  String get path => '/user/interest_updata';
}

class FeedsAPI extends API {
  final int type;
  final int page;

  FeedsAPI({
    this.type = 0,
    this.page = 1,
  });

  @override
  Map<String, dynamic> get parameters => {'type': type, 'page': page};

  @override
  String get path => '/user/following';
}

class RecommendSellerAPI extends API {
  @override
  String get path => '/user/recommend';
}

class TagSearchAPI extends API {
  final String tag;
  final String userId;
  final int page;
  final int limit;

  TagSearchAPI({this.tag, this.userId, this.page, this.limit});

  @override
  Map<String, dynamic> get parameters =>
      {'userId': userId, 'tag': tag, 'page': page, 'limit': limit};

  @override
  String get path => '/user/tag_search';
}

class ShopDetailAPI extends API {
  final String userId;

  ShopDetailAPI(this.userId);

  @override
  Map<String, dynamic> get parameters => {'userId': userId};

  @override
  String get path => '/user/pub/detail';
}

class FollowAPI extends API {
  final String userId;

  FollowAPI(this.userId);

  @override
  Map<String, dynamic> get parameters => {'idolId': userId};

  @override
  String get path => '/user/follow_me';
}

class GoodsAPI extends API {
  final int type;
  final String userId;
  final int page;
  final int limit;

  GoodsAPI({this.type, this.userId, this.page, this.limit});

  @override
  Map<String, dynamic> get parameters =>
      {'userId': userId, 'type': type, 'page': page, 'limit': limit};

  @override
  String get path => '/user/pub/good_list';
}

class ProductDetailAPI extends API {
  final String idolGoodsId;

  ProductDetailAPI({this.idolGoodsId});

  @override
  Map<String, dynamic> get parameters => {'idolGoodsId': idolGoodsId};

  @override
  String get path => '/user/good/detail';
}

class AddAddressAPI extends API {
  final String firstName;
  final String lastName;
  final String addressLine1;
  final String addressLine2;
  final String zipCode;
  final String city;
  final String province;
  final String country;
  final String phoneNumber;
  final bool isDefault;
  final bool isBillDefault;

  AddAddressAPI({
    this.firstName,
    this.lastName,
    this.addressLine1,
    this.addressLine2,
    this.zipCode,
    this.city,
    this.province,
    this.country,
    this.phoneNumber,
    this.isDefault,
    this.isBillDefault,
  });

  @override
  Map<String, dynamic> get parameters => {
        'firstName': firstName,
        'lastName': lastName,
        'addressLine1': addressLine1,
        'addressLine2': addressLine2,
        'zipCode': zipCode,
        'city': city,
        'province': province,
        'country': country,
        'phoneNumber': phoneNumber,
        'isDefault': isDefault ? 1 : 0,
        'isBillDefault': isBillDefault ? 1 : 0,
      };

  @override
  String get path => '/user/address/add';
}

class PreOrderAPI extends API {
  final List<OrderParameter> buyGoods;
  final String addressId;

  PreOrderAPI({@required this.buyGoods, this.addressId});

  @override
  Map<String, dynamic> get parameters => {
        'buyGoods': buyGoods.map((e) => e.toMap()).toList(),
        'addressId': addressId ?? ''
      };

  @override
  String get path => '/user/good/order_pre';
}

class OrderAPI extends API {
  final List<OrderParameter> buyGoods;
  final String shippingAddressId;
  final String billingAddressId;
  final String email;

  OrderAPI(
      this.buyGoods, this.shippingAddressId, this.billingAddressId, this.email);

  @override
  Map<String, dynamic> get parameters => {
        'buyGoods': buyGoods.map((e) => e.toMap()).toList(),
        'addressId': shippingAddressId,
        'billAddressId': billingAddressId,
        'email': email,
      };

  @override
  String get path => '/user/good/order';
}

class PayAPI extends API {
  final String orderId;
  final String payName;

  PayAPI({@required this.orderId, @required this.payName});

  @override
  Map<String, dynamic> get parameters => {
        'orderId': orderId,
        'payName': payName,
      };

  @override
  String get path => '/user/good/pay';
}

class AddCartAPI extends API {
  final OrderParameter params;

  AddCartAPI({@required this.params});

  @override
  Map<String, dynamic> get parameters => {
        'idolGoodsId': params.idolGoodsId,
        'skuSpecIds': params.skuSpecIds,
        'number': params.number,
      };

  @override
  String get path => '/user/good/add_cart';
}

class CartListAPI extends API {
  @override
  Map<String, dynamic> get parameters => {};

  @override
  String get path => '/user/good/cart_list';
}

class UpdateCartAPI extends API {
  final OrderParameter params;

  UpdateCartAPI({@required this.params});

  @override
  Map<String, dynamic> get parameters => {
        'idolGoodsId': params.idolGoodsId,
        'skuSpecIds': params.skuSpecIds,
        'number': params.number,
      };

  @override
  String get path => '/user/good/edit_cart';
}

class DeleteCartAPI extends API {
  final List<OrderParameter> params;

  DeleteCartAPI({@required this.params});

  @override
  Map<String, dynamic> get parameters =>
      {'delArr': params.map((e) => e.toMap()).toList()};

  @override
  String get path => '/user/good/del_cart';
}

class IdolLinksAPI extends API {
  final String userId;

  IdolLinksAPI(this.userId);

  @override
  Map<String, dynamic> get parameters => {'userId': userId};

  @override
  String get path => '/user/pub/link';
}

class AnonymousLoginAPI extends API {
  @override
  String get path => '/user/pub/virtual_login';
}
