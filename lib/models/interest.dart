import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class Interest {
  final String id;
  final String interestPortrait;
  final String interestName;

  const Interest({this.id, this.interestPortrait, this.interestName});

  Interest copyWith({
    String id,
    String interestPortrait,
    String interestName,
  }) {
    return Interest(
      id: id ?? this.id,
      interestPortrait: interestPortrait ?? this.interestPortrait,
      interestName: interestName ?? this.interestName,
    );
  }

  @override
  String toString() =>
      'Interest(id: $id, interestPortrait: $interestPortrait, interestName: $interestName)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Interest &&
        o.id == id &&
        o.interestPortrait == interestPortrait &&
        o.interestName == interestName;
  }

  @override
  int get hashCode =>
      id.hashCode ^ interestPortrait.hashCode ^ interestName.hashCode;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'interestPortrait': interestPortrait,
      'interestName': interestName,
    };
  }

  factory Interest.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Interest(
      id: map['id'] ?? '',
      interestPortrait: map['interestPortrait'] ?? '',
      interestName: map['interestName'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Interest.fromJson(String source) =>
      Interest.fromMap(json.decode(source));
}
