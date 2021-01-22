import 'package:flutter/foundation.dart';

import 'package:fans/models/models.dart';

@immutable
class ShopDetailState {
  final bool isLoading;
  final String error;
  final String userId;
  final Feed seller;
  final List<Goods> photos;
  final List<Goods> albums;

  const ShopDetailState({
    this.isLoading = false,
    this.error = '',
    this.userId = '',
    this.seller = const Feed(),
    this.photos = const [],
    this.albums = const [],
  });

  ShopDetailState copyWith({
    bool isLoading,
    String error,
    String userId,
    Feed user,
    List<Goods> photos,
    List<Goods> albums,
  }) {
    return ShopDetailState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      userId: userId ?? this.userId,
      seller: user ?? this.seller,
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
        listEquals(o.photos, photos) &&
        listEquals(o.albums, albums);
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
}
