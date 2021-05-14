import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:fans/models/order_sku.dart';

@immutable
class Cart {
  final List<OrderSku> list;
  final int subtotal;
  final int taxes;
  final int total;
  final String shipping;
  final String subtotalStr;
  final String taxesStr;
  final String totalStr;
  final bool canOrder;

  const Cart({
    this.list = const [],
    this.subtotal = 0,
    this.taxes = 0,
    this.total = 0,
    this.shipping = '',
    this.subtotalStr = '',
    this.taxesStr = '',
    this.totalStr = '',
    this.canOrder = false,
  });

  Cart copyWith({
    List<OrderSku> list,
    int subtotal,
    int taxes,
    int total,
    String shipping,
    String subtotalStr,
    String taxesStr,
    String totalStr,
    bool canOrder,
  }) {
    return Cart(
      list: list ?? this.list,
      subtotal: subtotal ?? this.subtotal,
      taxes: taxes ?? this.taxes,
      total: total ?? this.total,
      shipping: shipping ?? this.shipping,
      subtotalStr: subtotalStr ?? this.subtotalStr,
      taxesStr: taxesStr ?? this.taxesStr,
      totalStr: totalStr ?? this.totalStr,
      canOrder: canOrder ?? this.canOrder,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'list': list?.map((x) => x.toMap())?.toList(),
      'subtotal': subtotal,
      'taxes': taxes,
      'total': total,
      'shipping': shipping,
      'subtotalStr': subtotalStr,
      'taxesStr': taxesStr,
      'totalStr': totalStr,
      'canOrder': canOrder,
    };
  }

  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      list: List<OrderSku>.from(map['list']?.map((x) => OrderSku.fromMap(x))),
      subtotal: map['subtotal'],
      taxes: map['taxes'],
      total: map['total'],
      shipping: map['shipping'],
      subtotalStr: map['subtotalStr'],
      taxesStr: map['taxesStr'],
      totalStr: map['totalStr'],
      canOrder: map['canOrder'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Cart.fromJson(String source) => Cart.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Cart(list: $list, subtotal: $subtotal, taxes: $taxes, total: $total, shipping: $shipping, subtotalStr: $subtotalStr, taxesStr: $taxesStr, totalStr: $totalStr, canOrder: $canOrder)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Cart &&
        listEquals(other.list, list) &&
        other.subtotal == subtotal &&
        other.taxes == taxes &&
        other.total == total &&
        other.shipping == shipping &&
        other.subtotalStr == subtotalStr &&
        other.taxesStr == taxesStr &&
        other.totalStr == totalStr &&
        other.canOrder == canOrder;
  }

  @override
  int get hashCode {
    return list.hashCode ^
        subtotal.hashCode ^
        taxes.hashCode ^
        total.hashCode ^
        shipping.hashCode ^
        subtotalStr.hashCode ^
        taxesStr.hashCode ^
        totalStr.hashCode ^
        canOrder.hashCode;
  }
}
