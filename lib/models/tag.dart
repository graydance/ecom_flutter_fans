import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class Tag {
  final String name;

  const Tag({
    this.name = '',
  });

  Tag copyWith({
    String name,
  }) {
    return Tag(
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  factory Tag.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Tag(
      name: map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Tag.fromJson(String source) => Tag.fromMap(json.decode(source));

  @override
  String toString() => 'Tag(name: $name)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Tag && o.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}
