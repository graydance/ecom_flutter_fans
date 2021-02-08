import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class IdolLink {
  final String id;
  final String linkName;
  final String linkUrl;
  final String linkIcon;
  final int linkClick;
  final int istop;
  final int isPrivate;

  const IdolLink({
    this.id = '',
    this.linkName = '',
    this.linkUrl = '',
    this.linkIcon = '',
    this.linkClick = 0,
    this.istop = 0,
    this.isPrivate = 0,
  });

  IdolLink copyWith({
    String id,
    String linkName,
    String linkUrl,
    String linkIcon,
    int linkClick,
    int istop,
    int isPrivate,
  }) {
    return IdolLink(
      id: id ?? this.id,
      linkName: linkName ?? this.linkName,
      linkUrl: linkUrl ?? this.linkUrl,
      linkIcon: linkIcon ?? this.linkIcon,
      linkClick: linkClick ?? this.linkClick,
      istop: istop ?? this.istop,
      isPrivate: isPrivate ?? this.isPrivate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'linkName': linkName,
      'linkUrl': linkUrl,
      'linkIcon': linkIcon,
      'linkClick': linkClick,
      'istop': istop,
      'isPrivate': isPrivate,
    };
  }

  factory IdolLink.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return IdolLink(
      id: map['id'],
      linkName: map['linkName'],
      linkUrl: map['linkUrl'],
      linkIcon: map['linkIcon'],
      linkClick: map['linkClick'],
      istop: map['istop'],
      isPrivate: map['isPrivate'],
    );
  }

  String toJson() => json.encode(toMap());

  factory IdolLink.fromJson(String source) =>
      IdolLink.fromMap(json.decode(source));

  @override
  String toString() {
    return 'IdolLink(id: $id, linkName: $linkName, linkUrl: $linkUrl, linkIcon: $linkIcon, linkClick: $linkClick, istop: $istop, isPrivate: $isPrivate)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is IdolLink &&
        o.id == id &&
        o.linkName == linkName &&
        o.linkUrl == linkUrl &&
        o.linkIcon == linkIcon &&
        o.linkClick == linkClick &&
        o.istop == istop &&
        o.isPrivate == isPrivate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        linkName.hashCode ^
        linkUrl.hashCode ^
        linkIcon.hashCode ^
        linkClick.hashCode ^
        istop.hashCode ^
        isPrivate.hashCode;
  }
}
