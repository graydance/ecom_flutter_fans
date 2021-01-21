import 'dart:convert';

import 'package:flutter/material.dart';

@immutable
class User {
  final String id;
  final String nickName;
  final String portrait;
  final String email;

  /// 0:默认 1:男 2:女 3:自定义
  final int gender;
  final String aboutMe;
  final String bindPhone;
  final int availableBalance;
  final int lifetimeEarnings;
  final String monetaryCountry;
  final String monetaryUnit;

  /// 用户开店状态用 默认0,0 未开店,1 已开店,2 店铺违规关闭
  final int shopStatus;
  final int heatRank;
  final String bioLink;
  final String token;

  const User({
    this.id = '',
    this.nickName = '',
    this.portrait = '',
    this.email = '',
    this.gender = 0,
    this.aboutMe = '',
    this.bindPhone = '',
    this.availableBalance = 0,
    this.lifetimeEarnings = 0,
    this.monetaryCountry = '',
    this.monetaryUnit = '',
    this.shopStatus = 0,
    this.heatRank = 0,
    this.bioLink = '',
    this.token = '',
  });

  @override
  String toString() {
    return 'User(id: $id, nickName: $nickName, portrait: $portrait, email: $email, gender: $gender, aboutMe: $aboutMe, bindPhone: $bindPhone, availableBalance: $availableBalance, lifetimeEarnings: $lifetimeEarnings, monetaryCountry: $monetaryCountry, monetaryUnit: $monetaryUnit, shopStatus: $shopStatus, heatRank: $heatRank, bioLink: $bioLink, token: $token)';
  }

  User copyWith({
    String id,
    String nickName,
    String portrait,
    String email,
    int gender,
    String aboutMe,
    String bindPhone,
    int availableBalance,
    int lifetimeEarnings,
    String monetaryCountry,
    String monetaryUnit,
    int shopStatus,
    int heatRank,
    String bioLink,
    String token,
  }) {
    return User(
      id: id ?? this.id,
      nickName: nickName ?? this.nickName,
      portrait: portrait ?? this.portrait,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      aboutMe: aboutMe ?? this.aboutMe,
      bindPhone: bindPhone ?? this.bindPhone,
      availableBalance: availableBalance ?? this.availableBalance,
      lifetimeEarnings: lifetimeEarnings ?? this.lifetimeEarnings,
      monetaryCountry: monetaryCountry ?? this.monetaryCountry,
      monetaryUnit: monetaryUnit ?? this.monetaryUnit,
      shopStatus: shopStatus ?? this.shopStatus,
      heatRank: heatRank ?? this.heatRank,
      bioLink: bioLink ?? this.bioLink,
      token: token ?? this.token,
    );
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is User &&
        o.id == id &&
        o.nickName == nickName &&
        o.portrait == portrait &&
        o.email == email &&
        o.gender == gender &&
        o.aboutMe == aboutMe &&
        o.bindPhone == bindPhone &&
        o.availableBalance == availableBalance &&
        o.lifetimeEarnings == lifetimeEarnings &&
        o.monetaryCountry == monetaryCountry &&
        o.monetaryUnit == monetaryUnit &&
        o.shopStatus == shopStatus &&
        o.heatRank == heatRank &&
        o.bioLink == bioLink &&
        o.token == token;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nickName.hashCode ^
        portrait.hashCode ^
        email.hashCode ^
        gender.hashCode ^
        aboutMe.hashCode ^
        bindPhone.hashCode ^
        availableBalance.hashCode ^
        lifetimeEarnings.hashCode ^
        monetaryCountry.hashCode ^
        monetaryUnit.hashCode ^
        shopStatus.hashCode ^
        heatRank.hashCode ^
        bioLink.hashCode ^
        token.hashCode;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nickName': nickName,
      'portrait': portrait,
      'email': email,
      'gender': gender,
      'aboutMe': aboutMe,
      'bindPhone': bindPhone,
      'availableBalance': availableBalance,
      'lifetimeEarnings': lifetimeEarnings,
      'monetaryCountry': monetaryCountry,
      'monetaryUnit': monetaryUnit,
      'shopStatus': shopStatus,
      'heatRank': heatRank,
      'bioLink': bioLink,
      'token': token,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return User(
      id: map['id'] ?? '',
      nickName: map['nickName'] ?? '',
      portrait: map['portrait'] ?? '',
      email: map['email'] ?? '',
      gender: map['gender'] ?? 0,
      aboutMe: map['aboutMe'] ?? '',
      bindPhone: map['bindPhone'] ?? '',
      availableBalance: map['availableBalance'] ?? 0,
      lifetimeEarnings: map['lifetimeEarnings'] ?? 0,
      monetaryCountry: map['monetaryCountry'] ?? '',
      monetaryUnit: map['monetaryUnit'] ?? '',
      shopStatus: map['shopStatus'] ?? 0,
      heatRank: map['heatRank'] ?? 0,
      bioLink: map['bioLink'] ?? '',
      token: map['token'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
