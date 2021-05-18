import 'package:fans/models/address.dart';
import 'package:flutter/material.dart';

import 'package:fans/models/models.dart';

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

class SellerInfoAPI extends API {
  final String userName;

  SellerInfoAPI(this.userName);

  @override
  Map<String, dynamic> get parameters => {'userName': userName};

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

class GoodsListAPI extends API {
  final int type;
  final String userName;
  final int page;
  final int limit;

  GoodsListAPI({this.type, this.userName, this.page, this.limit});

  @override
  Map<String, dynamic> get parameters =>
      {'userName': userName, 'type': type, 'page': page, 'limit': limit};

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

class EditAddressAPI extends API {
  final String id;
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

  EditAddressAPI({
    this.id,
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
        'addressId': id,
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
  String get path => '/user/address/edit';
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
  final String code;

  OrderAPI(this.buyGoods, this.shippingAddressId, this.billingAddressId,
      this.email, this.code);

  @override
  Map<String, dynamic> get parameters => {
        'buyGoods': buyGoods.map((e) => e.toMap()).toList(),
        'addressId': shippingAddressId,
        'billAddressId': billingAddressId,
        'email': email,
        'code': code,
      };

  @override
  String get path => '/user/good/order';
}

class PreOrderNewAPI extends API {
  final List<OrderParameter> buyGoods;
  final Address address;
  final Address billAddress;
  final String email;
  final bool isSame;
  final String code;

  PreOrderNewAPI({
    @required this.buyGoods,
    @required this.address,
    @required this.billAddress,
    @required this.email,
    @required this.isSame,
    this.code,
  });

  @override
  Map<String, dynamic> get parameters => {
        'buyGoods': buyGoods.map((e) => e.toMap()).toList(),
        'address': address.toMap(),
        'billAddress': billAddress.toMap(),
        'email': email,
        'isSame': isSame ?? true,
        'code': code ?? '',
      };

  @override
  String get path => '/user/good/order_pre_new';
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
  Map<String, dynamic> get parameters => params.toMap();

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

class PayCaptureAPI extends API {
  final String payNumber;

  PayCaptureAPI(this.payNumber);

  @override
  Map<String, dynamic> get parameters => {'payNumber': payNumber};

  String get path => '/user/pub/pay_capture';
}

class CheckCouponAPI extends API {
  final String code;
  final int total;

  CheckCouponAPI(this.code, this.total);

  @override
  Map<String, dynamic> get parameters => {'code': code, 'total': total};

  String get path => '/user/pub/coupon_validate';
}

class ShowCouponAPI extends API {
  String get path => '/user/pub/show_coupon';
}

class ConfigAPI extends API {
  String get path => '/user/pub/config';
}

class ProvinceAPI extends API {
  final String country;

  ProvinceAPI(this.country);

  @override
  Map<String, dynamic> get parameters => {'country': country};

  String get path => '/user/pub/province';
}

class CityAPI extends API {
  final String country;
  final String province;

  CityAPI(this.country, this.province);

  @override
  Map<String, dynamic> get parameters =>
      {'country': country, 'province': province};

  String get path => '/user/pub/city';
}

class EditCustomizAPI extends API {
  final String cartItemId;
  final int isCustomiz;
  final String customiz;

  EditCustomizAPI(this.cartItemId, this.isCustomiz, this.customiz);

  @override
  Map<String, dynamic> get parameters =>
      {'id': cartItemId, 'isCustomiz': isCustomiz, 'customiz': customiz};

  String get path => '/user/good/edit_customiz';
}

class PayQueryAPI extends API {
  final String orderId;
  final String payName;

  PayQueryAPI(this.orderId, this.payName);

  @override
  Map<String, dynamic> get parameters =>
      {'orderId': orderId, 'payName': payName};

  String get path => '/user/good/pay_query';
}
