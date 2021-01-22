import 'dart:convert';

import 'package:flutter/foundation.dart';

import "goods.dart";

class Seller {
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
  final int shoppingCar;
  final String collectNum;
  final String followNum;
  final String bioLink;
  final List<String> tagNormal;
  final List<String> tagSelected;
  final List<Goods> goods;

  const Seller({
    this.id,
    this.userId,
    this.responseType,
    this.portrait,
    this.nickName,
    this.aboutMe,
    this.followStatus,
    this.productName,
    this.originalPrice,
    this.originalPriceStr,
    this.currentPrice,
    this.currentPriceStr,
    this.goodsDescription,
    this.discount,
    this.shoppingCar,
    this.collectNum,
    this.followNum,
    this.bioLink,
    this.tagNormal,
    this.tagSelected,
    this.goods,
  });

  Seller copyWith({
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
    int shoppingCar,
    String collectNum,
    String followNum,
    String bioLink,
    List<String> tagNormal,
    List<String> tagSelected,
    List<Goods> goods,
  }) {
    return Seller(
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
    );
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
    };
  }

  factory Seller.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Seller(
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
      shoppingCar: map['shoppingCar'] ?? 0,
      collectNum: map['collectNum'] ?? '',
      followNum: map['followNum'] ?? '',
      bioLink: map['bioLink'] ?? '',
      tagNormal: map['tagNormal'] ?? [],
      tagSelected: map['tagSelected'] ?? [],
      goods: (map['goods'])?.map((x) => Goods.fromMap(x)) ?? [],
    );
  }

  String toJson() => json.encode(toMap());

  factory Seller.fromJson(String source) => Seller.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Seller(id: $id, userId: $userId, responseType: $responseType, portrait: $portrait, nickName: $nickName, aboutMe: $aboutMe, followStatus: $followStatus, productName: $productName, originalPrice: $originalPrice, originalPriceStr: $originalPriceStr, currentPrice: $currentPrice, currentPriceStr: $currentPriceStr, goodsDescription: $goodsDescription, discount: $discount, shoppingCar: $shoppingCar, collectNum: $collectNum, followNum: $followNum, bioLink: $bioLink, tagNormal: $tagNormal, tagSelected: $tagSelected, goods: $goods)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Seller &&
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
        listEquals(o.goods, goods);
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
        goods.hashCode;
  }
}
