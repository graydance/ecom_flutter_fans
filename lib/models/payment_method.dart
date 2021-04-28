import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class PaymentMethod {
  final String id;
  final String name;

  PaymentMethod({
    this.id = '',
    this.name = '',
  });

  PaymentMethod copyWith({
    String id,
    String name,
  }) {
    return PaymentMethod(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory PaymentMethod.fromMap(Map<String, dynamic> map) {
    return PaymentMethod(
      id: map['id'],
      name: map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentMethod.fromJson(String source) =>
      PaymentMethod.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PaymentMethod && other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  @override
  String toString() => 'PaymentMethod(id: $id, name: $name)';
}
