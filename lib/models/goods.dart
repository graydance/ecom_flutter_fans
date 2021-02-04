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
  final String idolId;
  final String idolGoodsId;

  const Goods({
    this.id = '',
    this.picture = '',
    this.width = 1,
    this.height = 1,
    this.interestName = '',
    this.idolId = '',
    this.idolGoodsId = '',
  });

  Goods copyWith({
    String id,
    String picture,
    int width,
    int height,
    String interestName,
    String idolId,
    String idolGoodsId,
  }) {
    return Goods(
      id: id ?? this.id,
      picture: picture ?? this.picture,
      width: width ?? this.width,
      height: height ?? this.height,
      interestName: interestName ?? this.interestName,
      idolId: idolId ?? this.idolId,
      idolGoodsId: idolGoodsId ?? this.idolGoodsId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'picture': picture,
      'width': width,
      'height': height,
      'interestName': interestName,
      'idolId': idolId,
      'idolGoodsId': idolGoodsId,
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
      idolId: map['idolId'] ?? '',
      idolGoodsId: map['idolGoodsId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Goods.fromJson(String source) => Goods.fromMap(json.decode(source));

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Goods &&
        o.id == id &&
        o.picture == picture &&
        o.width == width &&
        o.height == height &&
        o.interestName == interestName &&
        o.idolId == idolId &&
        o.idolGoodsId == idolGoodsId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        picture.hashCode ^
        width.hashCode ^
        height.hashCode ^
        interestName.hashCode ^
        idolId.hashCode ^
        idolGoodsId.hashCode;
  }

  @override
  String toString() {
    return 'Goods(id: $id, picture: $picture, width: $width, height: $height, interestName: $interestName, idolId: $idolId, idolGoodsId: $idolGoodsId)';
  }
}
