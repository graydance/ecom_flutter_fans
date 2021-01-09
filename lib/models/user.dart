import 'package:flutter/cupertino.dart';

@immutable
class User {
  final String id;
  final String nickName;
  final String portrait;
  final String email;
  final int gender;
  final String aboutMe;
  final String bindPhone;
  final String token;

  const User({
    this.id = '',
    this.nickName = '',
    this.portrait = '',
    this.email = '',
    this.gender = 0,
    this.aboutMe = '',
    this.bindPhone = '',
    this.token = '',
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      nickName: json['nick_name'] as String,
      portrait: json['portrait'] as String,
      email: json['email'] as String,
      gender: json['gender'] as int,
      aboutMe: json['about_me'] as String,
      bindPhone: json['bind_phone'] as String,
      token: json['token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nick_name': nickName,
      'portrait': portrait,
      'email': email,
      'gender': gender,
      'about_me': aboutMe,
      'bind_phone': bindPhone,
      'token': token,
    };
  }

  User copyWith({
    String id,
    String nickName,
    String portrait,
    String email,
    int gender,
    String aboutMe,
    String bindPhone,
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
      token: token ?? this.token,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, nickName: $nickName, portrait: $portrait, email: $email, gender: $gender, aboutMe: $aboutMe, bindPhone: $bindPhone, token: $token)';
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
        token.hashCode;
  }
}
