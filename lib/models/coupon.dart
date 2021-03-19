import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class Coupon {
  final bool canUse;
  final int amount;
  final String amountStr;
  final String msg;

  const Coupon({
    this.canUse = false,
    this.amount = 0,
    this.amountStr = '',
    this.msg = '',
  });

  Coupon copyWith({
    bool canUse,
    int amount,
    String amountStr,
    String msg,
  }) {
    return Coupon(
      canUse: canUse ?? this.canUse,
      amount: amount ?? this.amount,
      amountStr: amountStr ?? this.amountStr,
      msg: msg ?? this.msg,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'canUse': canUse,
      'amount': amount,
      'amountStr': amountStr,
      'msg': msg,
    };
  }

  factory Coupon.fromMap(Map<String, dynamic> map) {
    return Coupon(
      canUse: map['canUse'],
      amount: map['amount'],
      amountStr: map['amountStr'],
      msg: map['msg'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Coupon.fromJson(String source) => Coupon.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Coupon(canUse: $canUse, amount: $amount, amountStr: $amountStr, msg: $msg)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Coupon &&
        other.canUse == canUse &&
        other.amount == amount &&
        other.amountStr == amountStr &&
        other.msg == msg;
  }

  @override
  int get hashCode {
    return canUse.hashCode ^
        amount.hashCode ^
        amountStr.hashCode ^
        msg.hashCode;
  }
}
