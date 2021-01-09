import 'package:flutter/cupertino.dart';

@immutable
class Interest {
  final String id;
  final String interestPortrait;
  final String interestName;

  const Interest({this.id, this.interestPortrait, this.interestName});

  factory Interest.fromJson(Map<String, dynamic> json) {
    return Interest(
      id: json['id'] as String,
      interestPortrait: json['interest_portrait'] as String,
      interestName: json['interest_name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'interest_portrait': interestPortrait,
      'interest_name': interestName,
    };
  }

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
}