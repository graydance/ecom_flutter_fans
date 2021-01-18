import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class GoodsImage {
  final String goodsId;
  final String image;

  GoodsImage({
    this.goodsId = '',
    this.image = '',
  });

  GoodsImage copyWith({
    String goodsId,
    String image,
  }) {
    return GoodsImage(
      goodsId: goodsId ?? this.goodsId,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'goodsId': goodsId,
      'image': image,
    };
  }

  factory GoodsImage.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return GoodsImage(
      goodsId: map['goodsId'] ?? '',
      image: map['image'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory GoodsImage.fromJson(String source) =>
      GoodsImage.fromMap(json.decode(source));

  @override
  String toString() => 'GoodsImage(goodsId: $goodsId, image: $image)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is GoodsImage && o.goodsId == goodsId && o.image == image;
  }

  @override
  int get hashCode => goodsId.hashCode ^ image.hashCode;
}
