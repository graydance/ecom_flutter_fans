import 'dart:convert';

import 'package:flutter/foundation.dart';

import "tag.dart";

@immutable
class GoodsItem {
  final String id;
  final String idolGoodsId;
  final int heatRank;
  final String supplierId;
  final int width;
  final int height;
  final String picture;
  final String goodsName;
  final int isOffTheShelf;
  final int currentPrice;
  final int originalPrice;
  final String currentPriceStr;
  final String originalPriceStr;
  final List<Tag> tag;
  final String discount;

  const GoodsItem({
    this.id = '',
    this.idolGoodsId = '',
    this.heatRank = 0,
    this.supplierId = '',
    this.width = 1,
    this.height = 1,
    this.picture = '',
    this.goodsName = '',
    this.isOffTheShelf = 0,
    this.currentPrice = 0,
    this.originalPrice = 0,
    this.currentPriceStr = '',
    this.originalPriceStr = '',
    this.tag = const [],
    this.discount = '',
  });

  GoodsItem copyWith({
    String id,
    String idolGoodsId,
    int heatRank,
    String supplierId,
    int width,
    int height,
    String picture,
    String goodsName,
    int isOffTheShelf,
    int currentPrice,
    int originalPrice,
    String currentPriceStr,
    String originalPriceStr,
    List<Tag> tag,
    String discount,
  }) {
    return GoodsItem(
      id: id ?? this.id,
      idolGoodsId: idolGoodsId ?? this.idolGoodsId,
      heatRank: heatRank ?? this.heatRank,
      supplierId: supplierId ?? this.supplierId,
      width: width ?? this.width,
      height: height ?? this.height,
      picture: picture ?? this.picture,
      goodsName: goodsName ?? this.goodsName,
      isOffTheShelf: isOffTheShelf ?? this.isOffTheShelf,
      currentPrice: currentPrice ?? this.currentPrice,
      originalPrice: originalPrice ?? this.originalPrice,
      currentPriceStr: currentPriceStr ?? this.currentPriceStr,
      originalPriceStr: originalPriceStr ?? this.originalPriceStr,
      tag: tag ?? this.tag,
      discount: discount ?? this.discount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idolGoodsId': idolGoodsId,
      'heatRank': heatRank,
      'supplierId': supplierId,
      'width': width,
      'height': height,
      'picture': picture,
      'goodsName': goodsName,
      'isOffTheShelf': isOffTheShelf,
      'currentPrice': currentPrice,
      'originalPrice': originalPrice,
      'currentPriceStr': currentPriceStr,
      'originalPriceStr': originalPriceStr,
      'tag': tag?.map((x) => x?.toMap())?.toList(),
      'discount': discount,
    };
  }

  factory GoodsItem.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return GoodsItem(
      id: map['id'],
      idolGoodsId: map['idolGoodsId'],
      heatRank: map['heatRank'],
      supplierId: map['supplierId'],
      width: map['width'],
      height: map['height'],
      picture: map['picture'],
      goodsName: map['goodsName'],
      isOffTheShelf: map['isOffTheShelf'],
      currentPrice: map['currentPrice'],
      originalPrice: map['originalPrice'],
      currentPriceStr: map['currentPriceStr'],
      originalPriceStr: map['originalPriceStr'],
      tag: List<Tag>.from(map['tag']?.map((x) => Tag.fromMap(x))),
      discount: map['discount'],
    );
  }

  String toJson() => json.encode(toMap());

  factory GoodsItem.fromJson(String source) =>
      GoodsItem.fromMap(json.decode(source));

  @override
  String toString() {
    return 'GoodsItem(id: $id, idolGoodsId: $idolGoodsId, heatRank: $heatRank, supplierId: $supplierId, width: $width, height: $height, picture: $picture, goodsName: $goodsName, isOffTheShelf: $isOffTheShelf, currentPrice: $currentPrice, originalPrice: $originalPrice, currentPriceStr: $currentPriceStr, originalPriceStr: $originalPriceStr, tag: $tag, discount: $discount)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is GoodsItem &&
        o.id == id &&
        o.idolGoodsId == idolGoodsId &&
        o.heatRank == heatRank &&
        o.supplierId == supplierId &&
        o.width == width &&
        o.height == height &&
        o.picture == picture &&
        o.goodsName == goodsName &&
        o.isOffTheShelf == isOffTheShelf &&
        o.currentPrice == currentPrice &&
        o.originalPrice == originalPrice &&
        o.currentPriceStr == currentPriceStr &&
        o.originalPriceStr == originalPriceStr &&
        listEquals(o.tag, tag) &&
        o.discount == discount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        idolGoodsId.hashCode ^
        heatRank.hashCode ^
        supplierId.hashCode ^
        width.hashCode ^
        height.hashCode ^
        picture.hashCode ^
        goodsName.hashCode ^
        isOffTheShelf.hashCode ^
        currentPrice.hashCode ^
        originalPrice.hashCode ^
        currentPriceStr.hashCode ^
        originalPriceStr.hashCode ^
        tag.hashCode ^
        discount.hashCode;
  }
}