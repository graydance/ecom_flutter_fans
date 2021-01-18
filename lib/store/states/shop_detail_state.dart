import 'package:flutter/foundation.dart';

import 'package:fans/models/models.dart';

@immutable
class ShopDetailState {
  final bool isLoading;
  final String error;
  final String userId;
  final User user;
  final List<GoodsImage> photos;
  final List<GoodsImage> albums;

  const ShopDetailState({
    this.isLoading = false,
    this.error = '',
    this.userId = '',
    this.user = const User(),
    this.photos = const [],
    this.albums = const [],
  });

  ShopDetailState copyWith({
    bool isLoading,
    String error,
    String userId,
    User user,
    List<GoodsImage> photos,
    List<GoodsImage> albums,
  }) {
    return ShopDetailState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      userId: userId ?? this.userId,
      user: user ?? this.user,
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
        o.user == user &&
        listEquals(o.photos, photos) &&
        listEquals(o.albums, albums);
  }

  @override
  int get hashCode {
    return isLoading.hashCode ^
        error.hashCode ^
        userId.hashCode ^
        user.hashCode ^
        photos.hashCode ^
        albums.hashCode;
  }

  @override
  String toString() {
    return 'ShopDetailState(isLoading: $isLoading, error: $error, userId: $userId, user: $user, photos: $photos, albums: $albums)';
  }
}
