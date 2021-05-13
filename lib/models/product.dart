import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:fans/models/models.dart';

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
  final List<GoodsSpec> specList;
  final int idolId;
  final String idolGoodsId;
  final String nickName;
  final String storeName;
  final int isOfficial;
  final List<Goods> recommend;
  final String originalPriceStr;
  final String currentPriceStr;
  final List<Tag> tag;
  final int isCustomiz;
  final List<ServiceConfig> serviceConfigs;
  final String shippedFrom;
  final String shippedTo;
  final List<ExpressTemplete> expressTemplete;

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
    this.specList = const [],
    this.idolId = 0,
    this.idolGoodsId = '',
    this.nickName = '',
    this.storeName = '',
    this.isOfficial = 0,
    this.recommend = const [],
    this.originalPriceStr = '',
    this.currentPriceStr = '',
    this.tag = const [],
    this.isCustomiz = 0,
    this.serviceConfigs = const [],
    this.shippedFrom = '',
    this.shippedTo = '',
    this.expressTemplete = const [],
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
    List<GoodsSpec> specList,
    int idolId,
    String idolGoodsId,
    String nickName,
    String storeName,
    int isOfficial,
    List<Goods> recommend,
    String originalPriceStr,
    String currentPriceStr,
    List<Tag> tag,
    int isCustomiz,
    List<ServiceConfig> serviceConfigs,
    String shippedFrom,
    String shippedTo,
    List<ExpressTemplete> expressTemplete,
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
      specList: specList ?? this.specList,
      idolId: idolId ?? this.idolId,
      idolGoodsId: idolGoodsId ?? this.idolGoodsId,
      nickName: nickName ?? this.nickName,
      storeName: storeName ?? this.storeName,
      isOfficial: isOfficial ?? this.isOfficial,
      recommend: recommend ?? this.recommend,
      originalPriceStr: originalPriceStr ?? this.originalPriceStr,
      currentPriceStr: currentPriceStr ?? this.currentPriceStr,
      tag: tag ?? this.tag,
      isCustomiz: isCustomiz ?? this.isCustomiz,
      serviceConfigs: serviceConfigs ?? this.serviceConfigs,
      shippedFrom: shippedFrom ?? this.shippedFrom,
      shippedTo: shippedTo ?? this.shippedTo,
      expressTemplete: expressTemplete ?? this.expressTemplete,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Product &&
        other.id == id &&
        other.productName == productName &&
        other.originalPrice == originalPrice &&
        other.currentPrice == currentPrice &&
        other.earningPrice == earningPrice &&
        other.description == description &&
        other.carNumber == carNumber &&
        other.collectNumber == collectNumber &&
        other.status == status &&
        other.originalUrl == originalUrl &&
        other.specType == specType &&
        other.width == width &&
        other.height == height &&
        other.supplierId == supplierId &&
        listEquals(other.goodsPictures, goodsPictures) &&
        listEquals(other.goodsSkus, goodsSkus) &&
        listEquals(other.specList, specList) &&
        other.idolId == idolId &&
        other.idolGoodsId == idolGoodsId &&
        other.nickName == nickName &&
        other.storeName == storeName &&
        other.isOfficial == isOfficial &&
        listEquals(other.recommend, recommend) &&
        other.originalPriceStr == originalPriceStr &&
        other.currentPriceStr == currentPriceStr &&
        listEquals(other.tag, tag) &&
        other.isCustomiz == isCustomiz &&
        listEquals(other.serviceConfigs, serviceConfigs) &&
        other.shippedFrom == shippedFrom &&
        other.shippedTo == shippedTo &&
        listEquals(other.expressTemplete, expressTemplete);
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
        specList.hashCode ^
        idolId.hashCode ^
        idolGoodsId.hashCode ^
        nickName.hashCode ^
        storeName.hashCode ^
        isOfficial.hashCode ^
        recommend.hashCode ^
        originalPriceStr.hashCode ^
        currentPriceStr.hashCode ^
        tag.hashCode ^
        isCustomiz.hashCode ^
        serviceConfigs.hashCode ^
        shippedFrom.hashCode ^
        shippedTo.hashCode ^
        expressTemplete.hashCode;
  }

  @override
  String toString() {
    return 'Product(id: $id, productName: $productName, originalPrice: $originalPrice, currentPrice: $currentPrice, earningPrice: $earningPrice, description: $description, carNumber: $carNumber, collectNumber: $collectNumber, status: $status, originalUrl: $originalUrl, specType: $specType, width: $width, height: $height, supplierId: $supplierId, goodsPictures: $goodsPictures, goodsSkus: $goodsSkus, specList: $specList, idolId: $idolId, idolGoodsId: $idolGoodsId, nickName: $nickName, storeName: $storeName, isOfficial: $isOfficial, recommend: $recommend, originalPriceStr: $originalPriceStr, currentPriceStr: $currentPriceStr, tag: $tag, isCustomiz: $isCustomiz, serviceConfigs: $serviceConfigs, shippedFrom: $shippedFrom, shippedTo: $shippedTo, expressTemplete: $expressTemplete)';
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
      'goodsPictures': goodsPictures?.map((x) => x.toMap())?.toList(),
      'goodsSkus': goodsSkus?.map((x) => x.toMap())?.toList(),
      'specList': specList?.map((x) => x.toMap())?.toList(),
      'idolId': idolId,
      'idolGoodsId': idolGoodsId,
      'nickName': nickName,
      'storeName': storeName,
      'isOfficial': isOfficial,
      'recommend': recommend?.map((x) => x.toMap())?.toList(),
      'originalPriceStr': originalPriceStr,
      'currentPriceStr': currentPriceStr,
      'tag': tag?.map((x) => x.toMap())?.toList(),
      'isCustomiz': isCustomiz,
      'serviceConfigs': serviceConfigs?.map((x) => x.toMap())?.toList(),
      'shippedFrom': shippedFrom,
      'shippedTo': shippedTo,
      'expressTemplete': expressTemplete?.map((x) => x.toMap())?.toList(),
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
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
      specList: List<GoodsSpec>.from(
          map['specList']?.map((x) => GoodsSpec.fromMap(x))),
      idolId: map['idolId'],
      idolGoodsId: map['idolGoodsId'],
      nickName: map['nickName'],
      storeName: map['storeName'],
      isOfficial: map['isOfficial'],
      recommend:
          List<Goods>.from(map['recommend']?.map((x) => Goods.fromMap(x))),
      originalPriceStr: map['originalPriceStr'],
      currentPriceStr: map['currentPriceStr'],
      tag: List<Tag>.from(map['tag']?.map((x) => Tag.fromMap(x))),
      isCustomiz: map['isCustomiz'],
      serviceConfigs: List<ServiceConfig>.from(
          map['serviceConfigs']?.map((x) => ServiceConfig.fromMap(x))),
      shippedFrom: map['shippedFrom'],
      shippedTo: map['shippedTo'],
      expressTemplete: List<ExpressTemplete>.from(
          map['expressTemplete']?.map((x) => ExpressTemplete.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));
}
