import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

@immutable
class Goods {
  final String id;
  final String userId;

  /// 列表类型 0商品列表(翻页) 1用户stroe(九宫格)
  final int responseType;
  final String portrait;
  final String nickName;
  final String productName;
  final String originalPrice;
  final String currentPrice;
  final String goodsDescription;
  final int shoppingCar;
  final int collectNum;
  final List<String> tagNormal;
  final List<String> tagSelected;
  final List<String> goods;

  const Goods({
    this.id = '',
    this.userId = '',
    this.responseType = 0,
    this.portrait,
    this.nickName,
    this.productName,
    this.originalPrice,
    this.currentPrice,
    this.goodsDescription,
    this.shoppingCar,
    this.collectNum,
    this.tagNormal,
    this.tagSelected,
    this.goods,
  });

  @override
  String toString() {
    return 'Goods(id: $id, userId: $userId, responseType: $responseType, portrait: $portrait, nickName: $nickName, productName: $productName, originalPrice: $originalPrice, currentPrice: $currentPrice, goodsDescription: $goodsDescription, shoppingCar: $shoppingCar, collectNum: $collectNum, tagNormal: $tagNormal, tagSelected: $tagSelected, goods: $goods)';
  }

  factory Goods.fromJson(Map<String, dynamic> json) {
    return Goods(
      id: json['id'] as String,
      userId: json['userId'] as String,
      responseType: json['response_type'] as int,
      portrait: json['portrait'] as String,
      nickName: json['nick_name'] as String,
      productName: json['product_name'] as String,
      originalPrice: json['original_price'] as String,
      currentPrice: json['current_price'] as String,
      goodsDescription: json['goods_description'] as String,
      shoppingCar: json['shopping_car'] as int,
      collectNum: json['collect_num'] as int,
      tagNormal: json['tag_normal'] as List<String>,
      tagSelected: json['tag_selected'] as List<String>,
      goods: json['goods'] as List<String>,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'response_type': responseType,
      'portrait': portrait,
      'nick_name': nickName,
      'product_name': productName,
      'original_price': originalPrice,
      'current_price': currentPrice,
      'goods_description': goodsDescription,
      'shopping_car': shoppingCar,
      'collect_num': collectNum,
      'tag_normal': tagNormal,
      'tag_selected': tagSelected,
      'goods': goods,
    };
  }

  Goods copyWith({
    String id,
    String userId,
    String responseType,
    String portrait,
    String nickName,
    String productName,
    String originalPrice,
    String currentPrice,
    String goodsDescription,
    int shoppingCar,
    int collectNum,
    List<String> tagNormal,
    List<String> tagSelected,
    List<String> goods,
  }) {
    return Goods(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      responseType: responseType ?? this.responseType,
      portrait: portrait ?? this.portrait,
      nickName: nickName ?? this.nickName,
      productName: productName ?? this.productName,
      originalPrice: originalPrice ?? this.originalPrice,
      currentPrice: currentPrice ?? this.currentPrice,
      goodsDescription: goodsDescription ?? this.goodsDescription,
      shoppingCar: shoppingCar ?? this.shoppingCar,
      collectNum: collectNum ?? this.collectNum,
      tagNormal: tagNormal ?? this.tagNormal,
      tagSelected: tagSelected ?? this.tagSelected,
      goods: goods ?? this.goods,
    );
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Goods &&
        o.id == id &&
        o.userId == userId &&
        o.responseType == responseType &&
        o.portrait == portrait &&
        o.nickName == nickName &&
        o.productName == productName &&
        o.originalPrice == originalPrice &&
        o.currentPrice == currentPrice &&
        o.goodsDescription == goodsDescription &&
        o.shoppingCar == shoppingCar &&
        o.collectNum == collectNum &&
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
        productName.hashCode ^
        originalPrice.hashCode ^
        currentPrice.hashCode ^
        goodsDescription.hashCode ^
        shoppingCar.hashCode ^
        collectNum.hashCode ^
        tagNormal.hashCode ^
        tagSelected.hashCode ^
        goods.hashCode;
  }
}
