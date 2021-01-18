import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

@immutable
class Goods {
  final String id;
  final String picture;

  const Goods({
    this.id = '',
    this.picture = '',
  });

  Goods copyWith({
    String id,
    String picture,
  }) {
    return Goods(
      id: id ?? this.id,
      picture: picture ?? this.picture,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'picture': picture,
    };
  }

  factory Goods.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Goods(
      id: map['id'],
      picture: map['picture'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Goods.fromJson(String source) => Goods.fromMap(json.decode(source));

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Goods && o.id == id && o.picture == picture;
  }

  @override
  int get hashCode => id.hashCode ^ picture.hashCode;

  @override
  String toString() => 'Goods(id: $id, picture: $picture)';
}
