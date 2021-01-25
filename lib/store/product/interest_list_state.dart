import 'package:flutter/foundation.dart';

import 'package:fans/models/interest.dart';

@immutable
class InterestListState {
  final bool isLoading;
  final String error;
  final List<Interest> interests;
  const InterestListState({
    this.isLoading = false,
    this.error = '',
    this.interests = const [],
  });

  InterestListState copyWith({
    bool isLoading,
    String error,
    List<Interest> interests,
  }) {
    return InterestListState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      interests: interests ?? this.interests,
    );
  }

  @override
  String toString() =>
      'InterestListState(isLoading: $isLoading, error: $error, interests: $interests)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is InterestListState &&
        o.isLoading == isLoading &&
        o.error == error &&
        listEquals(o.interests, interests);
  }

  @override
  int get hashCode => isLoading.hashCode ^ error.hashCode ^ interests.hashCode;
}
