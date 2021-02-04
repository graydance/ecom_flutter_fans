import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:fans/models/address.dart';
import 'package:fans/models/order_sku.dart';

@immutable
class OrderDetail {
  /// 是否可以下单
  final bool canOrder;
  final int subtotal;
  final int taxes;
  final int total;
  final String shipping;
  final String subtotalStr;
  final String taxesStr;
  final String totalStr;

  final List<OrderSku> list;
  final List<Address> addresses;

  const OrderDetail({
    this.list = const [],
    this.subtotal = 0,
    this.taxes = 0,
    this.canOrder = true,
    this.addresses = const [],
    this.total = 0,
    this.shipping = '',
    this.subtotalStr = '',
    this.taxesStr = '',
    this.totalStr = '',
  });

  OrderDetail copyWith({
    bool canOrder,
    int subtotal,
    int taxes,
    int total,
    String shipping,
    String subtotalStr,
    String taxesStr,
    String totalStr,
    List<OrderSku> list,
    List<Address> addresses,
  }) {
    return OrderDetail(
      canOrder: canOrder ?? this.canOrder,
      subtotal: subtotal ?? this.subtotal,
      taxes: taxes ?? this.taxes,
      total: total ?? this.total,
      shipping: shipping ?? this.shipping,
      subtotalStr: subtotalStr ?? this.subtotalStr,
      taxesStr: taxesStr ?? this.taxesStr,
      totalStr: totalStr ?? this.totalStr,
      list: list ?? this.list,
      addresses: addresses ?? this.addresses,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'canOrder': canOrder,
      'subtotal': subtotal,
      'taxes': taxes,
      'total': total,
      'shipping': shipping,
      'subtotalStr': subtotalStr,
      'taxesStr': taxesStr,
      'totalStr': totalStr,
      'list': list?.map((x) => x?.toMap())?.toList() ?? [],
      'addresses': addresses?.map((x) => x?.toMap())?.toList() ?? [],
    };
  }

  factory OrderDetail.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return OrderDetail(
      canOrder: map['canOrder'],
      subtotal: map['subtotal'],
      taxes: map['taxes'],
      total: map['total'],
      shipping: map['shipping'],
      subtotalStr: map['subtotalStr'],
      taxesStr: map['taxesStr'],
      totalStr: map['totalStr'],
      list: List<OrderSku>.from(map['list']?.map((x) => OrderSku.fromMap(x))),
      addresses:
          List<Address>.from(map['addresses']?.map((x) => Address.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderDetail.fromJson(String source) =>
      OrderDetail.fromMap(json.decode(source));

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is OrderDetail &&
        o.canOrder == canOrder &&
        o.subtotal == subtotal &&
        o.taxes == taxes &&
        o.total == total &&
        o.shipping == shipping &&
        o.subtotalStr == subtotalStr &&
        o.taxesStr == taxesStr &&
        o.totalStr == totalStr &&
        listEquals(o.list, list) &&
        listEquals(o.addresses, addresses);
  }

  @override
  int get hashCode {
    return canOrder.hashCode ^
        subtotal.hashCode ^
        taxes.hashCode ^
        total.hashCode ^
        shipping.hashCode ^
        subtotalStr.hashCode ^
        taxesStr.hashCode ^
        totalStr.hashCode ^
        list.hashCode ^
        addresses.hashCode;
  }

  @override
  String toString() {
    return 'OrderDetail(canOrder: $canOrder, subtotal: $subtotal, taxes: $taxes, total: $total, shipping: $shipping, subtotalStr: $subtotalStr, taxesStr: $taxesStr, totalStr: $totalStr, list: $list, addresses: $addresses)';
  }
}
