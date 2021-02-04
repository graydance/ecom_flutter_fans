import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class Address {
  final String id;
  final String firstName;
  final String lastName;
  final String addressLine1;
  final String addressLine2;
  final String zipCode;
  final String city;
  final String province;
  final String country;
  final String phoneNumber;
  final int isDefault;
  final String createdAt;
  final String updatedAt;
  final String userId;
  final int isBillDefault;

  const Address({
    this.id = '',
    this.firstName = '',
    this.lastName = '',
    this.addressLine1 = '',
    this.addressLine2 = '',
    this.zipCode = '',
    this.city = '',
    this.province = '',
    this.country = '',
    this.phoneNumber = '',
    this.isDefault = 0,
    this.createdAt = '',
    this.updatedAt = '',
    this.userId = '',
    this.isBillDefault = 0,
  });

  Address copyWith({
    String id,
    String firstName,
    String lastName,
    String addressLine1,
    String addressLine2,
    String zipCode,
    String city,
    String province,
    String country,
    String phoneNumber,
    int isDefault,
    String createdAt,
    String updatedAt,
    String userId,
    int isBillDefault,
  }) {
    return Address(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      zipCode: zipCode ?? this.zipCode,
      city: city ?? this.city,
      province: province ?? this.province,
      country: country ?? this.country,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
      isBillDefault: isBillDefault ?? this.isBillDefault,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'zipCode': zipCode,
      'city': city,
      'province': province,
      'country': country,
      'phoneNumber': phoneNumber,
      'isDefault': isDefault,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'userId': userId,
      'isBillDefault': isBillDefault,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Address(
      id: map['id'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      addressLine1: map['addressLine1'] ?? '',
      addressLine2: map['addressLine2'] ?? '',
      zipCode: map['zipCode'] ?? '',
      city: map['city'] ?? '',
      province: map['province'] ?? '',
      country: map['country'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      isDefault: map['isDefault'] ?? 0,
      createdAt: map['createdAt'] ?? '',
      updatedAt: map['updatedAt'] ?? '',
      userId: map['userId'] ?? '',
      isBillDefault: map['isBillDefault'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Address.fromJson(String source) =>
      Address.fromMap(json.decode(source));

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Address &&
        o.id == id &&
        o.firstName == firstName &&
        o.lastName == lastName &&
        o.addressLine1 == addressLine1 &&
        o.addressLine2 == addressLine2 &&
        o.zipCode == zipCode &&
        o.city == city &&
        o.province == province &&
        o.country == country &&
        o.phoneNumber == phoneNumber &&
        o.isDefault == isDefault &&
        o.createdAt == createdAt &&
        o.updatedAt == updatedAt &&
        o.userId == userId &&
        o.isBillDefault == isBillDefault;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        addressLine1.hashCode ^
        addressLine2.hashCode ^
        zipCode.hashCode ^
        city.hashCode ^
        province.hashCode ^
        country.hashCode ^
        phoneNumber.hashCode ^
        isDefault.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        userId.hashCode ^
        isBillDefault.hashCode;
  }

  @override
  String toString() {
    return 'Address(id: $id, firstName: $firstName, lastName: $lastName, addressLine1: $addressLine1, addressLine2: $addressLine2, zipCode: $zipCode, city: $city, province: $province, country: $country, phoneNumber: $phoneNumber, isDefault: $isDefault, createdAt: $createdAt, updatedAt: $updatedAt, userId: $userId, isBillDefault: $isBillDefault)';
  }
}
