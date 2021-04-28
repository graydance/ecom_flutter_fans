import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:fans/models/country.dart';
import 'package:fans/models/payment_method.dart';

@immutable
class Config {
  final List<Country> country;
  final List<PaymentMethod> payMethod;

  const Config({
    this.country = const [],
    this.payMethod = const [],
  });

  Config copyWith({
    List<Country> country,
    List<PaymentMethod> payMethod,
  }) {
    return Config(
      country: country ?? this.country,
      payMethod: payMethod ?? this.payMethod,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'country': country?.map((x) => x.toMap())?.toList(),
      'payMethod': payMethod?.map((x) => x.toMap())?.toList(),
    };
  }

  factory Config.fromMap(Map<String, dynamic> map) {
    return Config(
      country:
          List<Country>.from(map['country']?.map((x) => Country.fromMap(x))),
      payMethod: List<PaymentMethod>.from(
          map['payMethod']?.map((x) => PaymentMethod.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Config.fromJson(String source) => Config.fromMap(json.decode(source));

  @override
  String toString() => 'Config(country: $country, payMethod: $payMethod)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Config &&
        listEquals(other.country, country) &&
        listEquals(other.payMethod, payMethod);
  }

  @override
  int get hashCode => country.hashCode ^ payMethod.hashCode;
}
