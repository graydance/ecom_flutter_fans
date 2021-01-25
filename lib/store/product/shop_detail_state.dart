import 'package:flutter/foundation.dart';

import 'package:fans/models/models.dart';

@immutable
class ShopDetailState {
  final bool isLoading;
  final String error;
  final String userId;
  final Feed seller;
  final ShopDetailListState photos;
  final ShopDetailListState albums;

  const ShopDetailState({
    this.isLoading = false,
    this.error = '',
    this.userId = '',
    this.seller = const Feed(),
    this.photos = const ShopDetailListState(type: 0),
    this.albums = const ShopDetailListState(type: 1),
  });

  ShopDetailState copyWith({
    bool isLoading,
    String error,
    String userId,
    Feed seller,
    ShopDetailListState photos,
    ShopDetailListState albums,
  }) {
    return ShopDetailState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      userId: userId ?? this.userId,
      seller: seller ?? this.seller,
      photos: photos ?? this.photos,
      albums: albums ?? this.albums,
    );
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ShopDetailState &&
        o.isLoading == isLoading &&
        o.error == error &&
        o.userId == userId &&
        o.seller == seller &&
        o.photos == photos &&
        o.albums == albums;
  }

  @override
  int get hashCode {
    return isLoading.hashCode ^
        error.hashCode ^
        userId.hashCode ^
        seller.hashCode ^
        photos.hashCode ^
        albums.hashCode;
  }

  @override
  String toString() {
    return 'ShopDetailState(isLoading: $isLoading, error: $error, userId: $userId, seller: $seller, photos: $photos, albums: $albums)';
  }
}

@immutable
class ShopDetailListState {
  final int type;
  final int currentPage;
  final int totalPage;
  final List<Goods> list;

  const ShopDetailListState({
    this.type = 0,
    this.currentPage = 1,
    this.totalPage = 0,
    this.list = const [],
  });

  ShopDetailListState copyWith({
    int type,
    int currentPage,
    int totalPage,
    List<Goods> list,
  }) {
    return ShopDetailListState(
      type: type ?? this.type,
      currentPage: currentPage ?? this.currentPage,
      totalPage: totalPage ?? this.totalPage,
      list: list ?? this.list,
    );
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ShopDetailListState &&
        o.type == type &&
        o.currentPage == currentPage &&
        o.totalPage == totalPage &&
        listEquals(o.list, list);
  }

  @override
  int get hashCode {
    return type.hashCode ^
        currentPage.hashCode ^
        totalPage.hashCode ^
        list.hashCode;
  }

  @override
  String toString() {
    return 'ShopDetailListState(type: $type, currentPage: $currentPage, totalPage: $totalPage, list: $list)';
  }
}
