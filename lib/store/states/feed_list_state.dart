import 'package:flutter/foundation.dart';

import 'package:fans/models/models.dart';

@immutable
class HomeState {
  final bool isLoading;
  final FeedsState followingFeeds;
  final FeedsState forYouFeeds;

  const HomeState({
    this.isLoading = false,
    this.followingFeeds = const FeedsState(),
    this.forYouFeeds = const FeedsState(),
  });

  HomeState copyWith({
    bool isLoading,
    FeedsState followingFeeds,
    FeedsState forYouFeeds,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      followingFeeds: followingFeeds ?? this.followingFeeds,
      forYouFeeds: forYouFeeds ?? this.forYouFeeds,
    );
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is HomeState &&
        o.isLoading == isLoading &&
        o.followingFeeds == followingFeeds &&
        o.forYouFeeds == forYouFeeds;
  }

  @override
  int get hashCode =>
      isLoading.hashCode ^ followingFeeds.hashCode ^ forYouFeeds.hashCode;

  @override
  String toString() =>
      'HomeState(isLoading: $isLoading, followingFeeds: $followingFeeds, forYouFeeds: $forYouFeeds)';
}

@immutable
class FeedsState {
  final bool isLoading;
  final String error;
  final List<Feed> list;
  final List<Seller> recommendUsers;
  final int currentPage;
  final int totalPage;

  const FeedsState({
    this.isLoading = false,
    this.error = '',
    this.list = const [],
    this.recommendUsers = const [],
    this.currentPage = 1,
    this.totalPage = 0,
  });

  FeedsState copyWith({
    bool isLoading,
    String error,
    List<Feed> list,
    List<Seller> recommendUsers,
    int currentPage,
    int totalPage,
  }) {
    return FeedsState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      list: list ?? this.list,
      recommendUsers: recommendUsers ?? this.recommendUsers,
      currentPage: currentPage ?? this.currentPage,
      totalPage: totalPage ?? this.totalPage,
    );
  }

  @override
  String toString() {
    return 'FeedsState(isLoading: $isLoading, error: $error, list: $list, recommendUsers: $recommendUsers, currentPage: $currentPage, totalPage: $totalPage)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is FeedsState &&
        o.isLoading == isLoading &&
        o.error == error &&
        listEquals(o.list, list) &&
        listEquals(o.recommendUsers, recommendUsers) &&
        o.currentPage == currentPage &&
        o.totalPage == totalPage;
  }

  @override
  int get hashCode {
    return isLoading.hashCode ^
        error.hashCode ^
        list.hashCode ^
        recommendUsers.hashCode ^
        currentPage.hashCode ^
        totalPage.hashCode;
  }
}
