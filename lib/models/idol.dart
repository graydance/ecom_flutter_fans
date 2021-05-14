import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class Idol {
  final String userId;
  final String nickName;
  final String portrait;
  final String aboutMe;
  final int products;
  final int followers;
  final int followStatus;
  final int isOfficial;
  final String userName;

  const Idol({
    this.userId = '',
    this.nickName = '',
    this.portrait = '',
    this.aboutMe = '',
    this.products = 0,
    this.followers = 0,
    this.followStatus = 0,
    this.isOfficial = 0,
    this.userName = '',
  });

  Idol copyWith({
    String userId,
    String nickName,
    String portrait,
    String aboutMe,
    int products,
    int followers,
    int followStatus,
    int isOfficial,
    String userName,
  }) {
    return Idol(
      userId: userId ?? this.userId,
      nickName: nickName ?? this.nickName,
      portrait: portrait ?? this.portrait,
      aboutMe: aboutMe ?? this.aboutMe,
      products: products ?? this.products,
      followers: followers ?? this.followers,
      followStatus: followStatus ?? this.followStatus,
      isOfficial: isOfficial ?? this.isOfficial,
      userName: userName ?? this.userName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'nickName': nickName,
      'portrait': portrait,
      'aboutMe': aboutMe,
      'products': products,
      'followers': followers,
      'followStatus': followStatus,
      'isOfficial': isOfficial,
      'userName': userName,
    };
  }

  factory Idol.fromMap(Map<String, dynamic> map) {
    return Idol(
      userId: map['userId'],
      nickName: map['nickName'],
      portrait: map['portrait'],
      aboutMe: map['aboutMe'],
      products: map['products'],
      followers: map['followers'],
      followStatus: map['followStatus'],
      isOfficial: map['isOfficial'],
      userName: map['userName'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Idol.fromJson(String source) => Idol.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Idol(userId: $userId, nickName: $nickName, portrait: $portrait, aboutMe: $aboutMe, products: $products, followers: $followers, followStatus: $followStatus, isOfficial: $isOfficial, userName: $userName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Idol &&
        other.userId == userId &&
        other.nickName == nickName &&
        other.portrait == portrait &&
        other.aboutMe == aboutMe &&
        other.products == products &&
        other.followers == followers &&
        other.followStatus == followStatus &&
        other.isOfficial == isOfficial &&
        other.userName == userName;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        nickName.hashCode ^
        portrait.hashCode ^
        aboutMe.hashCode ^
        products.hashCode ^
        followers.hashCode ^
        followStatus.hashCode ^
        isOfficial.hashCode ^
        userName.hashCode;
  }
}
