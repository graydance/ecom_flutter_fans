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

  const Cart({
    this.list = const [],
    this.subtotal = 0,
    this.taxes = 0,
    this.total = 0,
    this.shipping = '',
    this.subtotalStr = '',
    this.taxesStr = '',
    this.totalStr = '',
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
      'taxesStr': taxesStr,
      'totalStr': totalStr,
    };
  }

  factory Cart.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Cart(
      list: List<OrderSku>.from(map['list']?.map((x) => OrderSku.fromMap(x))),
      subtotal: map['subtotal'],
      taxes: map['taxes'],
      total: map['total'],
      shipping: map['shipping'],
      subtotalStr: map['subtotalStr'],
      taxesStr: map['taxesStr'],
      totalStr: map['totalStr'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Cart.fromJson(String source) => Cart.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Cart(list: $list, subtotal: $subtotal, taxes: $taxes, total: $total, shipping: $shipping, subtotalStr: $subtotalStr, taxesStr: $taxesStr, totalStr: $totalStr)';
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
        o.taxesStr == taxesStr &&
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
        taxesStr.hashCode ^
        totalStr.hashCode;
  }
}
