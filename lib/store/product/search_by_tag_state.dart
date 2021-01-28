import 'package:flutter/foundation.dart';

import 'package:fans/models/models.dart';

@immutable
class SearchByTagStateList {
  final String current;
  final Map<String, SearchByTagState> allSearch;

  const SearchByTagStateList({this.current = '', this.allSearch = const {}});

  SearchByTagStateList copyWith({
    String current,
    Map<String, SearchByTagState> allSearch,
  }) {
    return SearchByTagStateList(
      current: current ?? this.current,
      allSearch: allSearch ?? this.allSearch,
    );
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is SearchByTagStateList &&
        o.current == current &&
        mapEquals(o.allSearch, allSearch);
  }

  @override
  int get hashCode => current.hashCode ^ allSearch.hashCode;

  @override
  String toString() =>
      'SearchByTagStateList(current: $current, allSearch: $allSearch)';
}

@immutable
class SearchByTagState {
  final Feed feed;
  final String tag;
  final int currentPage;
  final int totalPage;
  final List<Feed> list;

  const SearchByTagState({
    this.feed = const Feed(),
    this.tag = '',
    this.currentPage = 1,
    this.totalPage = 1,
    this.list = const [],
  });

  SearchByTagState copyWith({
    Feed feed,
    String tag,
    int currentPage,
    int totalPage,
    List<Feed> list,
  }) {
    return SearchByTagState(
      feed: feed ?? this.feed,
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
        o.feed == feed &&
        o.tag == tag &&
        o.currentPage == currentPage &&
        o.totalPage == totalPage &&
        listEquals(o.list, list);
  }

  @override
  int get hashCode {
    return feed.hashCode ^
        tag.hashCode ^
        currentPage.hashCode ^
        totalPage.hashCode ^
        list.hashCode;
  }

  @override
  String toString() {
    return 'SearchByTagState(feed: $feed, tag: $tag, currentPage: $currentPage, totalPage: $totalPage, list: $list)';
  }
}
