import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class OrderSku {
  final String id;
  final int originalPrice;
  final int currentPrice;
  final int earningPrice;
  final int tax;
  final String barcode;
  final int stock;
  final int sales;
  final int weight;
  final String skuImage;
  final String skuSpecIds;
  final String createdAt;
  final String updatedAt;
  final int number;
  final String idolGoodsId;
  final String idolId;

  /// 商品上下架状态1=上架，0=下架
  final int status;
  final String goodsName;
  final String goodsSkuName;
  final String currentPriceStr;

  /// 库存是否充足
  final bool isStockEnough;

  /// 是否支持定制
  final int isCustomiz;
  final String customiz;
  final String cartItemId;

  final String expressShow;
  final int expressTemplateId;
  final int expressTemplatePrice;

  const OrderSku({
    this.id = '',
    this.originalPrice = 0,
    this.currentPrice = 0,
    this.earningPrice = 0,
    this.tax = 0,
    this.barcode = '',
    this.stock = 0,
    this.sales = 0,
    this.weight = 0,
    this.skuImage = '',
    this.skuSpecIds = '',
    this.createdAt = '',
    this.updatedAt = '',
    this.number = 0,
    this.idolGoodsId = '',
    this.idolId = '',
    this.status = 0,
    this.goodsName = '',
    this.goodsSkuName = '',
    this.currentPriceStr = '',
    this.isStockEnough = false,
    this.isCustomiz = 0,
    this.customiz = '',
    this.cartItemId = '',
    this.expressShow = '',
    this.expressTemplateId = 0,
    this.expressTemplatePrice = 0,
  });

  OrderSku copyWith({
    String id,
    int originalPrice,
    int currentPrice,
    int earningPrice,
    int tax,
    String barcode,
    int stock,
    int sales,
    int weight,
    String skuImage,
    String skuSpecIds,
    String createdAt,
    String updatedAt,
    int number,
    String idolGoodsId,
    String idolId,
    int status,
    String goodsName,
    String goodsSkuName,
    String currentPriceStr,
    bool isStockEnough,
    int isCustomiz,
    String customiz,
    String cartItemId,
    String expressShow,
    int expressTemplateId,
    int expressTemplatePrice,
  }) {
    return OrderSku(
      id: id ?? this.id,
      originalPrice: originalPrice ?? this.originalPrice,
      currentPrice: currentPrice ?? this.currentPrice,
      earningPrice: earningPrice ?? this.earningPrice,
      tax: tax ?? this.tax,
      barcode: barcode ?? this.barcode,
      stock: stock ?? this.stock,
      sales: sales ?? this.sales,
      weight: weight ?? this.weight,
      skuImage: skuImage ?? this.skuImage,
      skuSpecIds: skuSpecIds ?? this.skuSpecIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      number: number ?? this.number,
      idolGoodsId: idolGoodsId ?? this.idolGoodsId,
      idolId: idolId ?? this.idolId,
      status: status ?? this.status,
      goodsName: goodsName ?? this.goodsName,
      goodsSkuName: goodsSkuName ?? this.goodsSkuName,
      currentPriceStr: currentPriceStr ?? this.currentPriceStr,
      isStockEnough: isStockEnough ?? this.isStockEnough,
      isCustomiz: isCustomiz ?? this.isCustomiz,
      customiz: customiz ?? this.customiz,
      cartItemId: cartItemId ?? this.cartItemId,
      expressShow: expressShow ?? this.expressShow,
      expressTemplateId: expressTemplateId ?? this.expressTemplateId,
      expressTemplatePrice: expressTemplatePrice ?? this.expressTemplatePrice,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'originalPrice': originalPrice,
      'currentPrice': currentPrice,
      'earningPrice': earningPrice,
      'tax': tax,
      'barcode': barcode,
      'stock': stock,
      'sales': sales,
      'weight': weight,
      'skuImage': skuImage,
      'skuSpecIds': skuSpecIds,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'number': number,
      'idolGoodsId': idolGoodsId,
      'idolId': idolId,
      'status': status,
      'goodsName': goodsName,
      'goodsSkuName': goodsSkuName,
      'currentPriceStr': currentPriceStr,
      'isStockEnough': isStockEnough,
      'isCustomiz': isCustomiz,
      'customiz': customiz,
      'cartItemId': cartItemId,
      'expressShow': expressShow,
      'expressTemplateId': expressTemplateId,
      'expressTemplatePrice': expressTemplatePrice,
    };
  }

  factory OrderSku.fromMap(Map<String, dynamic> map) {
    return OrderSku(
      id: map['id'],
      originalPrice: map['originalPrice'],
      currentPrice: map['currentPrice'],
      earningPrice: map['earningPrice'],
      tax: map['tax'],
      barcode: map['barcode'],
      stock: map['stock'],
      sales: map['sales'],
      weight: map['weight'],
      skuImage: map['skuImage'],
      skuSpecIds: map['skuSpecIds'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      number: map['number'],
      idolGoodsId: map['idolGoodsId'],
      idolId: map['idolId'],
      status: map['status'],
      goodsName: map['goodsName'],
      goodsSkuName: map['goodsSkuName'],
      currentPriceStr: map['currentPriceStr'],
      isStockEnough: map['isStockEnough'],
      isCustomiz: map['isCustomiz'],
      customiz: map['customiz'],
      cartItemId: map['cartItemId'],
      expressShow: map['expressShow'] ?? '',
      expressTemplateId: map['expressTemplateId'] ?? 0,
      expressTemplatePrice: map['expressTemplatePrice'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderSku.fromJson(String source) =>
      OrderSku.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderSku &&
        other.id == id &&
        other.originalPrice == originalPrice &&
        other.currentPrice == currentPrice &&
        other.earningPrice == earningPrice &&
        other.tax == tax &&
        other.barcode == barcode &&
        other.stock == stock &&
        other.sales == sales &&
        other.weight == weight &&
        other.skuImage == skuImage &&
        other.skuSpecIds == skuSpecIds &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.number == number &&
        other.idolGoodsId == idolGoodsId &&
        other.idolId == idolId &&
        other.status == status &&
        other.goodsName == goodsName &&
        other.goodsSkuName == goodsSkuName &&
        other.currentPriceStr == currentPriceStr &&
        other.isStockEnough == isStockEnough &&
        other.isCustomiz == isCustomiz &&
        other.customiz == customiz &&
        other.cartItemId == cartItemId &&
        other.expressShow == expressShow &&
        other.expressTemplateId == expressTemplateId &&
        other.expressTemplatePrice == expressTemplatePrice;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        originalPrice.hashCode ^
        currentPrice.hashCode ^
        earningPrice.hashCode ^
        tax.hashCode ^
        barcode.hashCode ^
        stock.hashCode ^
        sales.hashCode ^
        weight.hashCode ^
        skuImage.hashCode ^
        skuSpecIds.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        number.hashCode ^
        idolGoodsId.hashCode ^
        idolId.hashCode ^
        status.hashCode ^
        goodsName.hashCode ^
        goodsSkuName.hashCode ^
        currentPriceStr.hashCode ^
        isStockEnough.hashCode ^
        isCustomiz.hashCode ^
        customiz.hashCode ^
        cartItemId.hashCode ^
        expressShow.hashCode ^
        expressTemplateId.hashCode ^
        expressTemplatePrice.hashCode;
  }

  @override
  String toString() {
    return 'OrderSku(id: $id, originalPrice: $originalPrice, currentPrice: $currentPrice, earningPrice: $earningPrice, tax: $tax, barcode: $barcode, stock: $stock, sales: $sales, weight: $weight, skuImage: $skuImage, skuSpecIds: $skuSpecIds, createdAt: $createdAt, updatedAt: $updatedAt, number: $number, idolGoodsId: $idolGoodsId, idolId: $idolId, status: $status, goodsName: $goodsName, goodsSkuName: $goodsSkuName, currentPriceStr: $currentPriceStr, isStockEnough: $isStockEnough, isCustomiz: $isCustomiz, customiz: $customiz, cartItemId: $cartItemId, expressShow: $expressShow, expressTemplateId: $expressTemplateId, expressTemplatePrice: $expressTemplatePrice)';
  }
}

@immutable
class OrderParameter {
  final String skuSpecIds;
  final String idolGoodsId;
  final int number;
  final int isCustomiz;
  final String customiz;
  final int expressTemplateId;

  OrderParameter({
    this.skuSpecIds,
    this.idolGoodsId,
    this.number = 0,
    this.isCustomiz = 0,
    this.customiz = '',
    this.expressTemplateId = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'skuSpecIds': skuSpecIds,
      'idolGoodsId': idolGoodsId,
      'number': number,
      'isCustomiz': isCustomiz,
      'customiz': customiz,
      'expressTemplateId': expressTemplateId,
    };
  }

  factory OrderParameter.fromMap(Map<String, dynamic> map) {
    return OrderParameter(
      skuSpecIds: map['skuSpecIds'],
      idolGoodsId: map['idolGoodsId'],
      number: map['number'],
      isCustomiz: map['isCustomiz'],
      customiz: map['customiz'],
      expressTemplateId: map['expressTemplateId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderParameter.fromJson(String source) =>
      OrderParameter.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderParameter &&
        other.skuSpecIds == skuSpecIds &&
        other.idolGoodsId == idolGoodsId &&
        other.number == number &&
        other.isCustomiz == isCustomiz &&
        other.customiz == customiz &&
        other.expressTemplateId == expressTemplateId;
  }

  @override
  int get hashCode {
    return skuSpecIds.hashCode ^
        idolGoodsId.hashCode ^
        number.hashCode ^
        isCustomiz.hashCode ^
        customiz.hashCode ^
        expressTemplateId.hashCode;
  }
}
