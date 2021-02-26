import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class Coupon {
  final bool canUse;
  final int amount;
  final String amountStr;

  const Coupon({
    this.canUse = false,
    this.amount = 0,
    this.amountStr = '',
  });

  Coupon copyWith({
    bool canUse,
    int amount,
    String amountStr,
  }) {
    return Coupon(
      canUse: canUse ?? this.canUse,
      amount: amount ?? this.amount,
      amountStr: amountStr ?? this.amountStr,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'canUse': canUse,
      'amount': amount,
      'amountStr': amountStr,
    };
  }

  factory Coupon.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Coupon(
      canUse: map['canUse'] ?? false,
      amount: map['amount'] ?? 0,
      amountStr: map['amountStr'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Coupon.fromJson(String source) => Coupon.fromMap(json.decode(source));

  @override
  String toString() =>
      'Coupon(canUse: $canUse, amount: $amount, amountStr: $amountStr)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Coupon &&
        o.canUse == canUse &&
        o.amount == amount &&
        o.amountStr == amountStr;
  }

  @override
  int get hashCode => canUse.hashCode ^ amount.hashCode ^ amountStr.hashCode;
}
