import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class CouponInfo {
  final int id;
  final String code;
  final int status;
  final int type;
  final int min;
  final String desc;
  final int amount;
  final String startTime;
  final String endTime;
  final String createdAt;
  final String updatedAt;

  const CouponInfo({
    this.id,
    this.code,
    this.status,
    this.type,
    this.min,
    this.desc,
    this.amount,
    this.startTime,
    this.endTime,
    this.createdAt,
    this.updatedAt,
  });

  CouponInfo copyWith({
    int id,
    String code,
    int status,
    int type,
    int min,
    String desc,
    int amount,
    String startTime,
    String endTime,
    String createdAt,
    String updatedAt,
  }) {
    return CouponInfo(
      id: id ?? this.id,
      code: code ?? this.code,
      status: status ?? this.status,
      type: type ?? this.type,
      min: min ?? this.min,
      desc: desc ?? this.desc,
      amount: amount ?? this.amount,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'status': status,
      'type': type,
      'min': min,
      'desc': desc,
      'amount': amount,
      'startTime': startTime,
      'endTime': endTime,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory CouponInfo.fromMap(Map<String, dynamic> map) {
    return CouponInfo(
      id: map['id'],
      code: map['code'],
      status: map['status'],
      type: map['type'],
      min: map['min'],
      desc: map['desc'],
      amount: map['amount'],
      startTime: map['startTime'],
      endTime: map['endTime'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CouponInfo.fromJson(String source) =>
      CouponInfo.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CouponInfo(id: $id, code: $code, status: $status, type: $type, min: $min, desc: $desc, amount: $amount, startTime: $startTime, endTime: $endTime, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CouponInfo &&
        other.id == id &&
        other.code == code &&
        other.status == status &&
        other.type == type &&
        other.min == min &&
        other.desc == desc &&
        other.amount == amount &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        code.hashCode ^
        status.hashCode ^
        type.hashCode ^
        min.hashCode ^
        desc.hashCode ^
        amount.hashCode ^
        startTime.hashCode ^
        endTime.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
