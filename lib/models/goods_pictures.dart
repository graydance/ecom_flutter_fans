import 'dart:convert';

class GoodsPictures {
  final String id;
  final String picture;
  final String goodId;

  const GoodsPictures({
    this.id = '',
    this.picture = '',
    this.goodId = '',
  });

  @override
  String toString() {
    return 'GoodsPictures(id: $id, picture: $picture, goodId: $goodId)';
  }

  GoodsPictures copyWith({
    String id,
    String picture,
    String goodId,
  }) {
    return GoodsPictures(
      id: id ?? this.id,
      picture: picture ?? this.picture,
      goodId: goodId ?? this.goodId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'picture': picture,
      'goodId': goodId,
    };
  }

  factory GoodsPictures.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return GoodsPictures(
      id: map['id'],
      picture: map['picture'],
      goodId: map['goodId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory GoodsPictures.fromJson(String source) =>
      GoodsPictures.fromMap(json.decode(source));

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is GoodsPictures &&
        o.id == id &&
        o.picture == picture &&
        o.goodId == goodId;
  }

  @override
  int get hashCode => id.hashCode ^ picture.hashCode ^ goodId.hashCode;
}
