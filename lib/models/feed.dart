import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'goods.dart';

class Feed {
  final String id;
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
  final String shoppingCar;
  final String collectNum;
  final String followNum;
  final String bioLink;
  final List<String> tagNormal;
  final List<String> tagSelected;
  final List<Goods> goods;
  final int products;
  final int followers;
  final int isOfficial;
  final String userName;

  const Feed({
    this.id = '',
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
    this.shoppingCar = '',
    this.collectNum = '',
    this.followNum = '',
    this.bioLink = '',
    this.tagNormal = const [],
    this.tagSelected = const [],
    this.goods = const [],
    this.products = 0,
    this.followers = 0,
    this.isOfficial = 0,
    this.userName = '',
  });

  Feed copyWith({
    String id,
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
    String shoppingCar,
    String collectNum,
    String followNum,
    String bioLink,
    List<String> tagNormal,
    List<String> tagSelected,
    List<Goods> goods,
    int products,
    int followers,
    int isOfficial,
    String userName,
  }) {
    return Feed(
        id: id ?? this.id,
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
        userName: userName ?? this.userName);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
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
      'goods': goods?.map((x) => x?.toMap())?.toList(),
      'products': products,
      'followers': followers,
      'isOfficial': isOfficial,
      'userName': userName,
    };
  }

  factory Feed.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Feed(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      responseType: map['responseType'] ?? 0,
      portrait: map['portrait'] ?? '',
      nickName: map['nickName'] ?? '',
      aboutMe: map['aboutMe'] ?? '',
      followStatus: map['followStatus'] ?? 0,
      productName: map['productName'] ?? '',
      originalPrice: map['originalPrice'] ?? 0,
      originalPriceStr: map['originalPriceStr'] ?? '',
      currentPrice: map['currentPrice'] ?? 0,
      currentPriceStr: map['currentPriceStr'] ?? '',
      goodsDescription: map['goodsDescription'] ?? '',
      discount: map['discount'] ?? '',
      shoppingCar: map['shoppingCar'] ?? '',
      collectNum: map['collectNum'] ?? '',
      followNum: map['followNum'] ?? '',
      bioLink: map['bioLink'] ?? '',
      tagNormal: map['tagNormal'] ?? [],
      tagSelected: map['tagSelected'] ?? [],
      goods: (map['goods'])?.map((x) => Goods.fromMap(x)) ?? [],
      products: map['products'] ?? 0,
      followers: map['followers'] ?? 0,
      isOfficial: map['isOfficial'] ?? 0,
      userName: map['userName'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Feed.fromJson(String source) => Feed.fromMap(json.decode(source));

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Feed &&
        o.id == id &&
        o.userId == userId &&
        o.responseType == responseType &&
        o.portrait == portrait &&
        o.nickName == nickName &&
        o.aboutMe == aboutMe &&
        o.followStatus == followStatus &&
        o.productName == productName &&
        o.originalPrice == originalPrice &&
        o.originalPriceStr == originalPriceStr &&
        o.currentPrice == currentPrice &&
        o.currentPriceStr == currentPriceStr &&
        o.goodsDescription == goodsDescription &&
        o.discount == discount &&
        o.shoppingCar == shoppingCar &&
        o.collectNum == collectNum &&
        o.followNum == followNum &&
        o.bioLink == bioLink &&
        listEquals(o.tagNormal, tagNormal) &&
        listEquals(o.tagSelected, tagSelected) &&
        listEquals(o.goods, goods) &&
        o.products == products &&
        o.followers == followers &&
        o.isOfficial == isOfficial &&
        o.userName == userName;
  }

  @override
  int get hashCode {
    return id.hashCode ^
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
        userName.hashCode;
  }

  @override
  String toString() {
    return 'Feed(id: $id, userId: $userId, responseType: $responseType, portrait: $portrait, nickName: $nickName, aboutMe: $aboutMe, followStatus: $followStatus, productName: $productName, originalPrice: $originalPrice, originalPriceStr: $originalPriceStr, currentPrice: $currentPrice, currentPriceStr: $currentPriceStr, goodsDescription: $goodsDescription, discount: $discount, shoppingCar: $shoppingCar, collectNum: $collectNum, followNum: $followNum, bioLink: $bioLink, tagNormal: $tagNormal, tagSelected: $tagSelected, goods: $goods, products: $products, followers: $followers, isOfficial: $isOfficial, userName: $userName)';
  }
}
