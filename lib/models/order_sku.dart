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
    };
  }

  factory OrderSku.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

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
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderSku.fromJson(String source) =>
      OrderSku.fromMap(json.decode(source));

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is OrderSku &&
        o.id == id &&
        o.originalPrice == originalPrice &&
        o.currentPrice == currentPrice &&
        o.earningPrice == earningPrice &&
        o.tax == tax &&
        o.barcode == barcode &&
        o.stock == stock &&
        o.sales == sales &&
        o.weight == weight &&
        o.skuImage == skuImage &&
        o.skuSpecIds == skuSpecIds &&
        o.createdAt == createdAt &&
        o.updatedAt == updatedAt &&
        o.number == number &&
        o.idolGoodsId == idolGoodsId &&
        o.idolId == idolId &&
        o.status == status &&
        o.goodsName == goodsName &&
        o.goodsSkuName == goodsSkuName &&
        o.currentPriceStr == currentPriceStr &&
        o.isStockEnough == isStockEnough;
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
        isStockEnough.hashCode;
  }

  @override
  String toString() {
    return 'OrderSku(id: $id, originalPrice: $originalPrice, currentPrice: $currentPrice, earningPrice: $earningPrice, tax: $tax, barcode: $barcode, stock: $stock, sales: $sales, weight: $weight, skuImage: $skuImage, skuSpecIds: $skuSpecIds, createdAt: $createdAt, updatedAt: $updatedAt, number: $number, idolGoodsId: $idolGoodsId, idolId: $idolId, status: $status, goodsName: $goodsName, goodsSkuName: $goodsSkuName, currentPriceStr: $currentPriceStr, isStockEnough: $isStockEnough)';
  }
}

@immutable
class OrderParameter {
  final String skuSpecIds;
  final String idolGoodsId;
  final int number;

  OrderParameter({this.skuSpecIds, this.idolGoodsId, this.number});

  Map<String, dynamic> toMap() {
    return {
      'skuSpecIds': skuSpecIds,
      'idolGoodsId': idolGoodsId,
      'number': number,
    };
  }

  factory OrderParameter.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return OrderParameter(
      skuSpecIds: map['skuSpecIds'],
      idolGoodsId: map['idolGoodsId'],
      number: map['number'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderParameter.fromJson(String source) =>
      OrderParameter.fromMap(json.decode(source));

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is OrderParameter &&
        o.skuSpecIds == skuSpecIds &&
        o.idolGoodsId == idolGoodsId &&
        o.number == number;
  }

  @override
  int get hashCode =>
      skuSpecIds.hashCode ^ idolGoodsId.hashCode ^ number.hashCode;
}
