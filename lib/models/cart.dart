import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class Cart {
  final List<CartItem> list;
  final int subtotal;
  final int taxes;
  final int total;
  final String shipping;
  final String subtotalStr;
  final String taxexStr;
  final String totalStr;

  const Cart({
    this.list = const [],
    this.subtotal = 0,
    this.taxes = 0,
    this.total = 0,
    this.shipping = '',
    this.subtotalStr = '',
    this.taxexStr = '',
    this.totalStr = '',
  });

  Cart copyWith({
    List<CartItem> list,
    int subtotal,
    int taxes,
    int total,
    String shipping,
    String subtotalStr,
    String taxexStr,
    String totalStr,
  }) {
    return Cart(
      list: list ?? this.list,
      subtotal: subtotal ?? this.subtotal,
      taxes: taxes ?? this.taxes,
      total: total ?? this.total,
      shipping: shipping ?? this.shipping,
      subtotalStr: subtotalStr ?? this.subtotalStr,
      taxexStr: taxexStr ?? this.taxexStr,
      totalStr: totalStr ?? this.totalStr,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'list': list?.map((x) => x?.toMap())?.toList(),
      'subtotal': subtotal,
      'taxes': taxes,
      'total': total,
      'shipping': shipping,
      'subtotalStr': subtotalStr,
      'taxexStr': taxexStr,
      'totalStr': totalStr,
    };
  }

  factory Cart.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Cart(
      list: List<CartItem>.from(map['list']?.map((x) => CartItem.fromMap(x))),
      subtotal: map['subtotal'],
      taxes: map['taxes'],
      total: map['total'],
      shipping: map['shipping'],
      subtotalStr: map['subtotalStr'],
      taxexStr: map['taxexStr'],
      totalStr: map['totalStr'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Cart.fromJson(String source) => Cart.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Cart(list: $list, subtotal: $subtotal, taxes: $taxes, total: $total, shipping: $shipping, subtotalStr: $subtotalStr, taxexStr: $taxexStr, totalStr: $totalStr)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Cart &&
        listEquals(o.list, list) &&
        o.subtotal == subtotal &&
        o.taxes == taxes &&
        o.total == total &&
        o.shipping == shipping &&
        o.subtotalStr == subtotalStr &&
        o.taxexStr == taxexStr &&
        o.totalStr == totalStr;
  }

  @override
  int get hashCode {
    return list.hashCode ^
        subtotal.hashCode ^
        taxes.hashCode ^
        total.hashCode ^
        shipping.hashCode ^
        subtotalStr.hashCode ^
        taxexStr.hashCode ^
        totalStr.hashCode;
  }
}

@immutable
class CartItem {
  final String id;
  final int originalPrice;
  final int currentPrice;
  final int earningPrice;
  final String barcode;
  final int stock;
  final int sales;
  final int weight;
  final String skuImage;
  final String skuSpecIds;
  final String createdAt;
  final String updatedAt;
  final String idolGoodsId;
  final int number;
  final int status;
  final String currentPriceStr;
  final bool isStockEnough;

  const CartItem({
    this.id = '',
    this.originalPrice = 0,
    this.currentPrice = 0,
    this.earningPrice = 0,
    this.barcode = '',
    this.stock = 0,
    this.sales = 0,
    this.weight = 0,
    this.skuImage = '',
    this.skuSpecIds = '',
    this.createdAt = '',
    this.updatedAt = '',
    this.idolGoodsId = '',
    this.number = 0,
    this.status = 0,
    this.currentPriceStr = '',
    this.isStockEnough = true,
  });

  CartItem copyWith({
    String id,
    int originalPrice,
    int currentPrice,
    int earningPrice,
    String barcode,
    int stock,
    int sales,
    int weight,
    String skuImage,
    String skuSpecIds,
    String createdAt,
    String updatedAt,
    String idolGoodsId,
    int number,
    int status,
    String currentPriceStr,
    bool isStockEnough,
  }) {
    return CartItem(
      id: id ?? this.id,
      originalPrice: originalPrice ?? this.originalPrice,
      currentPrice: currentPrice ?? this.currentPrice,
      earningPrice: earningPrice ?? this.earningPrice,
      barcode: barcode ?? this.barcode,
      stock: stock ?? this.stock,
      sales: sales ?? this.sales,
      weight: weight ?? this.weight,
      skuImage: skuImage ?? this.skuImage,
      skuSpecIds: skuSpecIds ?? this.skuSpecIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      idolGoodsId: idolGoodsId ?? this.idolGoodsId,
      number: number ?? this.number,
      status: status ?? this.status,
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
      'barcode': barcode,
      'stock': stock,
      'sales': sales,
      'weight': weight,
      'skuImage': skuImage,
      'skuSpecIds': skuSpecIds,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'idolGoodsId': idolGoodsId,
      'number': number,
      'status': status,
      'currentPriceStr': currentPriceStr,
      'isStockEnough': isStockEnough,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return CartItem(
      id: map['id'],
      originalPrice: map['originalPrice'],
      currentPrice: map['currentPrice'],
      earningPrice: map['earningPrice'],
      barcode: map['barcode'],
      stock: map['stock'],
      sales: map['sales'],
      weight: map['weight'],
      skuImage: map['skuImage'],
      skuSpecIds: map['skuSpecIds'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      idolGoodsId: map['idolGoodsId'],
      number: map['number'],
      status: map['status'],
      currentPriceStr: map['currentPriceStr'],
      isStockEnough: map['isStockEnough'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CartItem.fromJson(String source) =>
      CartItem.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CartItem(id: $id, originalPrice: $originalPrice, currentPrice: $currentPrice, earningPrice: $earningPrice, barcode: $barcode, stock: $stock, sales: $sales, weight: $weight, skuImage: $skuImage, skuSpecIds: $skuSpecIds, createdAt: $createdAt, updatedAt: $updatedAt, idolGoodsId: $idolGoodsId, number: $number, status: $status, currentPriceStr: $currentPriceStr, isStockEnough: $isStockEnough)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is CartItem &&
        o.id == id &&
        o.originalPrice == originalPrice &&
        o.currentPrice == currentPrice &&
        o.earningPrice == earningPrice &&
        o.barcode == barcode &&
        o.stock == stock &&
        o.sales == sales &&
        o.weight == weight &&
        o.skuImage == skuImage &&
        o.skuSpecIds == skuSpecIds &&
        o.createdAt == createdAt &&
        o.updatedAt == updatedAt &&
        o.idolGoodsId == idolGoodsId &&
        o.number == number &&
        o.status == status &&
        o.currentPriceStr == currentPriceStr &&
        o.isStockEnough == isStockEnough;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        originalPrice.hashCode ^
        currentPrice.hashCode ^
        earningPrice.hashCode ^
        barcode.hashCode ^
        stock.hashCode ^
        sales.hashCode ^
        weight.hashCode ^
        skuImage.hashCode ^
        skuSpecIds.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        idolGoodsId.hashCode ^
        number.hashCode ^
        status.hashCode ^
        currentPriceStr.hashCode ^
        isStockEnough.hashCode;
  }
}
