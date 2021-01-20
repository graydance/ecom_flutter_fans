import 'package:fans/models/models.dart';

class Feed {
  final String id;
  final String userId;
  final int responseType;
  final String portrait;
  final String nickName;
  final String productName;
  final String originalPrice;
  final String currentPrice;
  final String goodsDescription;
  final String shoppingCar;
  final String collectNum;
  final List<String> tagNormal;
  final List<String> tagSelected;

  /// 关注的人数
  final String followNum;
  final String bioLink;
  final List<Goods> goods;

  const Feed({
    this.id = '',
    this.userId = '',
    this.responseType = 0,
    this.portrait = '',
    this.nickName = '',
    this.productName = '',
    this.originalPrice = '',
    this.currentPrice = '',
    this.goodsDescription = '',
    this.shoppingCar = '',
    this.collectNum = '',
    this.tagNormal = const [],
    this.tagSelected = const [],
    this.followNum = '',
    this.bioLink = '',
    this.goods = const [],
  });

  @override
  String toString() {
    return 'Feed(id: $id, userId: $userId, responseType: $responseType, portrait: $portrait, nickName: $nickName, productName: $productName, originalPrice: $originalPrice, currentPrice: $currentPrice, goodsDescription: $goodsDescription, shoppingCar: $shoppingCar, collectNum: $collectNum, tagNormal: $tagNormal, tagSelected: $tagSelected, followNum: $followNum, bioLink: $bioLink, goods: $goods)';
  }

  factory Feed.fromJson(Map<String, dynamic> json) {
    return Feed(
      id: json['id'] as String,
      userId: json['userId'] as String,
      responseType: json['responseType'] as int,
      portrait: json['portrait'] as String,
      nickName: json['nickName'] as String,
      productName: json['productName'] as String,
      originalPrice: json['originalPrice'] as String,
      currentPrice: json['currentPrice'] as String,
      goodsDescription: json['goodsDescription'] as String,
      shoppingCar: json['shoppingCar'] as String,
      collectNum: json['collectNum'] as String,
      tagNormal: json['tagNormal'] as List<String>,
      tagSelected: json['tagSelected'] as List<String>,
      followNum: json['followNum'] as String,
      bioLink: json['bioLink'] as String,
      goods: (json['goods'] as List)?.map((e) {
        return e == null ? null : Goods.fromMap(e);
      })?.toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'responseType': responseType,
      'portrait': portrait,
      'nickName': nickName,
      'productName': productName,
      'originalPrice': originalPrice,
      'currentPrice': currentPrice,
      'goodsDescription': goodsDescription,
      'shoppingCar': shoppingCar,
      'collectNum': collectNum,
      'tagNormal': tagNormal,
      'tagSelected': tagSelected,
      'followNum': followNum,
      'bioLink': bioLink,
      'goods': goods?.map((e) => e?.toJson())?.toList(),
    };
  }

  Feed copyWith({
    String id,
    String userId,
    int responseType,
    String portrait,
    String nickName,
    String productName,
    int originalPrice,
    int currentPrice,
    String goodsDescription,
    int shoppingCar,
    int collectNum,
    List<String> tagNormal,
    List<String> tagSelected,
    String followNum,
    String bioLink,
    List<Goods> goods,
  }) {
    return Feed(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      responseType: responseType ?? this.responseType,
      portrait: portrait ?? this.portrait,
      nickName: nickName ?? this.nickName,
      productName: productName ?? this.productName,
      originalPrice: originalPrice ?? this.originalPrice,
      currentPrice: currentPrice ?? this.currentPrice,
      goodsDescription: goodsDescription ?? this.goodsDescription,
      shoppingCar: shoppingCar ?? this.shoppingCar,
      collectNum: collectNum ?? this.collectNum,
      tagNormal: tagNormal ?? this.tagNormal,
      tagSelected: tagSelected ?? this.tagSelected,
      followNum: followNum ?? this.followNum,
      bioLink: bioLink ?? this.bioLink,
      goods: goods ?? this.goods,
    );
  }
}
