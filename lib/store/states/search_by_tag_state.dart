import 'package:flutter/foundation.dart';

import 'package:fans/models/models.dart';

@immutable
class SearchByTagState {
  final String userId;
  final String tag;
  final int currentPage;
  final int totalPage;
  final List<Goods> list;

  const SearchByTagState({
    this.userId,
    this.tag,
    this.currentPage,
    this.totalPage,
    this.list,
  });

  SearchByTagState copyWith({
    String userId,
    String tag,
    int currentPage,
    int totalPage,
    List<Goods> list,
  }) {
    return SearchByTagState(
      userId: userId ?? this.userId,
      tag: tag ?? this.tag,
      currentPage: currentPage ?? this.currentPage,
      totalPage: totalPage ?? this.totalPage,
      list: list ?? this.list,
    );
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is SearchByTagState &&
        o.userId == userId &&
        o.tag == tag &&
        o.currentPage == currentPage &&
        o.totalPage == totalPage &&
        listEquals(o.list, list);
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        tag.hashCode ^
        currentPage.hashCode ^
        totalPage.hashCode ^
        list.hashCode;
  }

  @override
  String toString() {
    return 'SearchByTagState(userId: $userId, tag: $tag, currentPage: $currentPage, totalPage: $totalPage, list: $list)';
  }
}
