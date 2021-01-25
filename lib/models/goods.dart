import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

@immutable
class Goods {
  final String id;
  final String picture;
  final int width;
  final int height;
  final String interestName;

  const Goods({
    this.id = '',
    this.picture = '',
    this.width = 1,
    this.height = 1,
    this.interestName = '',
  });

  Goods copyWith({
    String id,
    String picture,
    int width,
    int height,
    String interestName,
  }) {
    return Goods(
      id: id ?? this.id,
      picture: picture ?? this.picture,
      width: width ?? this.width,
      height: height ?? this.height,
      interestName: interestName ?? this.interestName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'picture': picture,
      'width': width,
      'height': height,
      'interestName': interestName,
    };
  }

  factory Goods.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Goods(
      id: map['id'] ?? '',
      picture: map['picture'] ?? '',
      width: map['width'] ?? 1,
      height: map['height'] ?? 1,
      interestName: map['interestName'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Goods.fromJson(String source) => Goods.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Goods(id: $id, picture: $picture, width: $width, height: $height, interestName: $interestName)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Goods &&
        o.id == id &&
        o.picture == picture &&
        o.width == width &&
        o.height == height &&
        o.interestName == interestName;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        picture.hashCode ^
        width.hashCode ^
        height.hashCode ^
        interestName.hashCode;
  }
}
