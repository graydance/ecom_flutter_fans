import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:fans/models/country.dart';

@immutable
class Config {
  final List<Country> country;

  const Config({
    this.country = const [],
  });

  Config copyWith({
    List<Country> country,
  }) {
    return Config(
      country: country ?? this.country,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'country': country?.map((x) => x.toMap())?.toList(),
    };
  }

  factory Config.fromMap(Map<String, dynamic> map) {
    return Config(
      country:
          List<Country>.from(map['country']?.map((x) => Country.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Config.fromJson(String source) => Config.fromMap(json.decode(source));

  @override
  String toString() => 'Config(country: $country)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Config && listEquals(other.country, country);
  }

  @override
  int get hashCode => country.hashCode;
}
