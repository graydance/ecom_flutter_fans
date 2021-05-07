import 'dart:convert';

import 'package:flutter/foundation.dart';

class Feed {
  /// 商品id
  final String id;
  final String idolGoodsId;

  /// 用户id
  final String userId;
  final int responseType;
  final String portrait;
  final String nickName;
  final String aboutMe;
  final int followStatus;
  final String productName;
  final int originalPrice;
  final String originalPriceStr;
  final int currentPrice;
  final String currentPriceStr;
  final String goodsDescription;
  final String discount;
  final int shoppingCar;
  final int collectNum;
  final int followNum;
  final String bioLink;
  final List<String> tagNormal;
  final List<String> tagSelected;
  final List<String> goods;
  final int products;
  final int followers;
  final int isOfficial;
  final String userName;
  final int stock;

  const Feed({
    this.id = '',
    this.idolGoodsId = '',
    this.userId = '',
    this.responseType = 0,
    this.portrait = '',
    this.nickName = '',
    this.aboutMe = '',
    this.followStatus = 0,
    this.productName = '',
    this.originalPrice = 0,
    this.originalPriceStr = '',
    this.currentPrice = 0,
    this.currentPriceStr = '',
    this.goodsDescription = '',
    this.discount = '',
    this.shoppingCar = 0,
    this.collectNum = 0,
    this.followNum = 0,
    this.bioLink = '',
    this.tagNormal = const [],
    this.tagSelected = const [],
    this.goods = const [],
    this.products = 0,
    this.followers = 0,
    this.isOfficial = 0,
    this.userName = '',
    this.stock = 0,
  });

  Feed copyWith({
    String id,
    String idolGoodsId,
    String userId,
    int responseType,
    String portrait,
    String nickName,
    String aboutMe,
    int followStatus,
    String productName,
    int originalPrice,
    String originalPriceStr,
    int currentPrice,
    String currentPriceStr,
    String goodsDescription,
    String discount,
    int shoppingCar,
    int collectNum,
    int followNum,
    String bioLink,
    List<String> tagNormal,
    List<String> tagSelected,
    List<String> goods,
    int products,
    int followers,
    int isOfficial,
    String userName,
    int stock,
  }) {
    return Feed(
        id: id ?? this.id,
        idolGoodsId: idolGoodsId ?? this.idolGoodsId,
        userId: userId ?? this.userId,
        responseType: responseType ?? this.responseType,
        portrait: portrait ?? this.portrait,
        nickName: nickName ?? this.nickName,
        aboutMe: aboutMe ?? this.aboutMe,
        followStatus: followStatus ?? this.followStatus,
        productName: productName ?? this.productName,
        originalPrice: originalPrice ?? this.originalPrice,
        originalPriceStr: originalPriceStr ?? this.originalPriceStr,
        currentPrice: currentPrice ?? this.currentPrice,
        currentPriceStr: currentPriceStr ?? this.currentPriceStr,
        goodsDescription: goodsDescription ?? this.goodsDescription,
        discount: discount ?? this.discount,
        shoppingCar: shoppingCar ?? this.shoppingCar,
        collectNum: collectNum ?? this.collectNum,
        followNum: followNum ?? this.followNum,
        bioLink: bioLink ?? this.bioLink,
        tagNormal: tagNormal ?? this.tagNormal,
        tagSelected: tagSelected ?? this.tagSelected,
        goods: goods ?? this.goods,
        products: products ?? this.products,
        followers: followers ?? this.followers,
        isOfficial: isOfficial ?? this.isOfficial,
        userName: userName ?? this.userName,
        stock: stock ?? this.stock);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idolGoodsId': idolGoodsId,
      'userId': userId,
      'responseType': responseType,
      'portrait': portrait,
      'nickName': nickName,
      'aboutMe': aboutMe,
      'followStatus': followStatus,
      'productName': productName,
      'originalPrice': originalPrice,
      'originalPriceStr': originalPriceStr,
      'currentPrice': currentPrice,
      'currentPriceStr': currentPriceStr,
      'goodsDescription': goodsDescription,
      'discount': discount,
      'shoppingCar': shoppingCar,
      'collectNum': collectNum,
      'followNum': followNum,
      'bioLink': bioLink,
      'tagNormal': tagNormal,
      'tagSelected': tagSelected,
      'goods': goods,
      'products': products,
      'followers': followers,
      'isOfficial': isOfficial,
      'userName': userName,
      'stock': stock,
    };
  }

  factory Feed.fromMap(Map<String, dynamic> map) {
    return Feed(
      id: map['id'],
      idolGoodsId: map['idolGoodsId'],
      userId: map['userId'],
      responseType: map['responseType'],
      portrait: map['portrait'],
      nickName: map['nickName'],
      aboutMe: map['aboutMe'],
      followStatus: map['followStatus'],
      productName: map['productName'],
      originalPrice: map['originalPrice'],
      originalPriceStr: map['originalPriceStr'],
      currentPrice: map['currentPrice'],
      currentPriceStr: map['currentPriceStr'],
      goodsDescription: map['goodsDescription'],
      discount: map['discount'],
      shoppingCar: map['shoppingCar'],
      collectNum: map['collectNum'],
      followNum: map['followNum'],
      bioLink: map['bioLink'],
      tagNormal: List<String>.from(map['tagNormal']),
      tagSelected: List<String>.from(map['tagSelected']),
      goods: List<String>.from(map['goods']),
      products: map['products'],
      followers: map['followers'],
      isOfficial: map['isOfficial'],
      userName: map['userName'],
      stock: map['stock'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Feed.fromJson(String source) => Feed.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Feed &&
        other.id == id &&
        other.idolGoodsId == idolGoodsId &&
        other.userId == userId &&
        other.responseType == responseType &&
        other.portrait == portrait &&
        other.nickName == nickName &&
        other.aboutMe == aboutMe &&
        other.followStatus == followStatus &&
        other.productName == productName &&
        other.originalPrice == originalPrice &&
        other.originalPriceStr == originalPriceStr &&
        other.currentPrice == currentPrice &&
        other.currentPriceStr == currentPriceStr &&
        other.goodsDescription == goodsDescription &&
        other.discount == discount &&
        other.shoppingCar == shoppingCar &&
        other.collectNum == collectNum &&
        other.followNum == followNum &&
        other.bioLink == bioLink &&
        listEquals(other.tagNormal, tagNormal) &&
        listEquals(other.tagSelected, tagSelected) &&
        listEquals(other.goods, goods) &&
        other.products == products &&
        other.followers == followers &&
        other.isOfficial == isOfficial &&
        other.userName == userName &&
        other.stock == stock;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        idolGoodsId.hashCode ^
        userId.hashCode ^
        responseType.hashCode ^
        portrait.hashCode ^
        nickName.hashCode ^
        aboutMe.hashCode ^
        followStatus.hashCode ^
        productName.hashCode ^
        originalPrice.hashCode ^
        originalPriceStr.hashCode ^
        currentPrice.hashCode ^
        currentPriceStr.hashCode ^
        goodsDescription.hashCode ^
        discount.hashCode ^
        shoppingCar.hashCode ^
        collectNum.hashCode ^
        followNum.hashCode ^
        bioLink.hashCode ^
        tagNormal.hashCode ^
        tagSelected.hashCode ^
        goods.hashCode ^
        products.hashCode ^
        followers.hashCode ^
        isOfficial.hashCode ^
        userName.hashCode ^
        stock.hashCode;
  }

  @override
  String toString() {
    return 'Feed(id: $id, idolGoodsId: $idolGoodsId, userId: $userId, responseType: $responseType, portrait: $portrait, nickName: $nickName, aboutMe: $aboutMe, followStatus: $followStatus, productName: $productName, originalPrice: $originalPrice, originalPriceStr: $originalPriceStr, currentPrice: $currentPrice, currentPriceStr: $currentPriceStr, goodsDescription: $goodsDescription, discount: $discount, shoppingCar: $shoppingCar, collectNum: $collectNum, followNum: $followNum, bioLink: $bioLink, tagNormal: $tagNormal, tagSelected: $tagSelected, goods: $goods, products: $products, followers: $followers, isOfficial: $isOfficial, userName: $userName, stock: $stock)';
  }
}
