import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class Country {
  final String countryCode;
  final String countryName;
  final String phoneCode;

  const Country({
    this.countryCode = '',
    this.countryName = '',
    this.phoneCode = '',
  });

  Country copyWith({
    String countryCode,
    String countryName,
    String phoneCode,
  }) {
    return Country(
      countryCode: countryCode ?? this.countryCode,
      countryName: countryName ?? this.countryName,
      phoneCode: phoneCode ?? this.phoneCode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'countryCode': countryCode,
      'countryName': countryName,
      'phoneCode': phoneCode,
    };
  }

  factory Country.fromMap(Map<String, dynamic> map) {
    return Country(
      countryCode: map['countryCode'],
      countryName: map['countryName'],
      phoneCode: map['phoneCode'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Country.fromJson(String source) =>
      Country.fromMap(json.decode(source));

  @override
  String toString() =>
      'Country(countryCode: $countryCode, countryName: $countryName, phoneCode: $phoneCode)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Country &&
        other.countryCode == countryCode &&
        other.countryName == countryName &&
        other.phoneCode == phoneCode;
  }

  @override
  int get hashCode =>
      countryCode.hashCode ^ countryName.hashCode ^ phoneCode.hashCode;
}
