import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:fans/models/goods.dart';
import 'package:fans/models/goods_skus.dart';

class Product {
  final String id;
  final String productName;
  final int originalPrice;
  final int currentPrice;
  final int earningPrice;
  final String description;
  final int carNumber;
  final int collectNumber;
  final int status;
  final String originalUrl;
  final int specType;
  final int width;
  final int height;
  final String supplierId;
  final List<Goods> goodsPictures;
  final List<GoodsSkus> goodsSkus;
  final int idolId;
  final String idolGoodsId;
  final String nickName;
  final String storeName;
  final int isOfficial;
  final List<Goods> recommend;
  final String originalPriceStr;
  final String currentPriceStr;

  const Product({
    this.id = '',
    this.productName = '',
    this.originalPrice = 0,
    this.currentPrice = 0,
    this.earningPrice = 0,
    this.description = '',
    this.carNumber = 0,
    this.collectNumber = 0,
    this.status = 0,
    this.originalUrl = '',
    this.specType = 0,
    this.width = 1,
    this.height = 1,
    this.supplierId = '',
    this.goodsPictures = const [],
    this.goodsSkus = const [],
    this.idolId = 0,
    this.idolGoodsId = '',
    this.nickName = '',
    this.storeName = '',
    this.isOfficial = 0,
    this.recommend = const [],
    this.originalPriceStr = '',
    this.currentPriceStr = '',
  });

  Product copyWith({
    String id,
    String productName,
    int originalPrice,
    int currentPrice,
    int earningPrice,
    String description,
    int carNumber,
    int collectNumber,
    int status,
    String originalUrl,
    int specType,
    int width,
    int height,
    String supplierId,
    List<Goods> goodsPictures,
    List<GoodsSkus> goodsSkus,
    int idolId,
    String idolGoodsId,
    String nickName,
    String storeName,
    int isOfficial,
    List<Goods> recommend,
    String originalPriceStr,
    String currentPriceStr,
  }) {
    return Product(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      originalPrice: originalPrice ?? this.originalPrice,
      currentPrice: currentPrice ?? this.currentPrice,
      earningPrice: earningPrice ?? this.earningPrice,
      description: description ?? this.description,
      carNumber: carNumber ?? this.carNumber,
      collectNumber: collectNumber ?? this.collectNumber,
      status: status ?? this.status,
      originalUrl: originalUrl ?? this.originalUrl,
      specType: specType ?? this.specType,
      width: width ?? this.width,
      height: height ?? this.height,
      supplierId: supplierId ?? this.supplierId,
      goodsPictures: goodsPictures ?? this.goodsPictures,
      goodsSkus: goodsSkus ?? this.goodsSkus,
      idolId: idolId ?? this.idolId,
      idolGoodsId: idolGoodsId ?? this.idolGoodsId,
      nickName: nickName ?? this.nickName,
      storeName: storeName ?? this.storeName,
      isOfficial: isOfficial ?? this.isOfficial,
      recommend: recommend ?? this.recommend,
      originalPriceStr: originalPriceStr ?? this.originalPriceStr,
      currentPriceStr: currentPriceStr ?? this.currentPriceStr,
    );
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Product &&
        o.id == id &&
        o.productName == productName &&
        o.originalPrice == originalPrice &&
        o.currentPrice == currentPrice &&
        o.earningPrice == earningPrice &&
        o.description == description &&
        o.carNumber == carNumber &&
        o.collectNumber == collectNumber &&
        o.status == status &&
        o.originalUrl == originalUrl &&
        o.specType == specType &&
        o.width == width &&
        o.height == height &&
        o.supplierId == supplierId &&
        listEquals(o.goodsPictures, goodsPictures) &&
        listEquals(o.goodsSkus, goodsSkus) &&
        o.idolId == idolId &&
        o.idolGoodsId == idolGoodsId &&
        o.nickName == nickName &&
        o.storeName == storeName &&
        o.isOfficial == isOfficial &&
        listEquals(o.recommend, recommend) &&
        o.originalPriceStr == originalPriceStr &&
        o.currentPriceStr == currentPriceStr;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        productName.hashCode ^
        originalPrice.hashCode ^
        currentPrice.hashCode ^
        earningPrice.hashCode ^
        description.hashCode ^
        carNumber.hashCode ^
        collectNumber.hashCode ^
        status.hashCode ^
        originalUrl.hashCode ^
        specType.hashCode ^
        width.hashCode ^
        height.hashCode ^
        supplierId.hashCode ^
        goodsPictures.hashCode ^
        goodsSkus.hashCode ^
        idolId.hashCode ^
        idolGoodsId.hashCode ^
        nickName.hashCode ^
        storeName.hashCode ^
        isOfficial.hashCode ^
        recommend.hashCode ^
        originalPriceStr.hashCode ^
        currentPriceStr.hashCode;
  }

  @override
  String toString() {
    return 'Product(id: $id, productName: $productName, originalPrice: $originalPrice, currentPrice: $currentPrice, earningPrice: $earningPrice, description: $description, carNumber: $carNumber, collectNumber: $collectNumber, status: $status, originalUrl: $originalUrl, specType: $specType, width: $width, height: $height, supplierId: $supplierId, goodsPictures: $goodsPictures, goodsSkus: $goodsSkus, idolId: $idolId, idolGoodsId: $idolGoodsId, nickName: $nickName, storeName: $storeName, isOfficial: $isOfficial, recommend: $recommend, originalPriceStr: $originalPriceStr, currentPriceStr: $currentPriceStr)';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productName': productName,
      'originalPrice': originalPrice,
      'currentPrice': currentPrice,
      'earningPrice': earningPrice,
      'description': description,
      'carNumber': carNumber,
      'collectNumber': collectNumber,
      'status': status,
      'originalUrl': originalUrl,
      'specType': specType,
      'width': width,
      'height': height,
      'supplierId': supplierId,
      'goodsPictures': goodsPictures?.map((x) => x?.toMap())?.toList(),
      'goodsSkus': goodsSkus?.map((x) => x?.toMap())?.toList(),
      'idolId': idolId,
      'idolGoodsId': idolGoodsId,
      'nickName': nickName,
      'storeName': storeName,
      'isOfficial': isOfficial,
      'recommend': recommend?.map((x) => x?.toMap())?.toList(),
      'originalPriceStr': originalPriceStr,
      'currentPriceStr': currentPriceStr,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Product(
      id: map['id'],
      productName: map['productName'],
      originalPrice: map['originalPrice'],
      currentPrice: map['currentPrice'],
      earningPrice: map['earningPrice'],
      description: map['description'],
      carNumber: map['carNumber'],
      collectNumber: map['collectNumber'],
      status: map['status'],
      originalUrl: map['originalUrl'],
      specType: map['specType'],
      width: map['width'],
      height: map['height'],
      supplierId: map['supplierId'],
      goodsPictures:
          List<Goods>.from(map['goodsPictures']?.map((x) => Goods.fromMap(x))),
      goodsSkus: List<GoodsSkus>.from(
          map['goodsSkus']?.map((x) => GoodsSkus.fromMap(x))),
      idolId: map['idolId'],
      idolGoodsId: map['idolGoodsId'],
      nickName: map['nickName'],
      storeName: map['storeName'],
      isOfficial: map['isOfficial'],
      recommend:
          List<Goods>.from(map['recommend']?.map((x) => Goods.fromMap(x))),
      originalPriceStr: map['originalPriceStr'],
      currentPriceStr: map['currentPriceStr'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));
}
