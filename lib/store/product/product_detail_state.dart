import 'package:flutter/foundation.dart';

import 'package:fans/models/models.dart';

@immutable
class ProductDetailsOnScreen {
  final String currentId;
  final Map<String, ProductDetailState> allStates;

  const ProductDetailsOnScreen({
    this.currentId = '',
    this.allStates = const {},
  });

  ProductDetailsOnScreen copyWith({
    String currentId,
    Map<String, ProductDetailState> allStates,
  }) {
    return ProductDetailsOnScreen(
      currentId: currentId ?? this.currentId,
      allStates: allStates ?? this.allStates,
    );
  }

  @override
  String toString() =>
      'ProductDetailsOnScreen(currentId: $currentId, allStates: $allStates)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ProductDetailsOnScreen &&
        o.currentId == currentId &&
        mapEquals(o.allStates, allStates);
  }

  @override
  int get hashCode => currentId.hashCode ^ allStates.hashCode;
}

@immutable
class ProductDetailState {
  final String goodsId;
  final Product model;

  ProductDetailState({this.goodsId = '', this.model = const Product()});

  ProductDetailState copyWith({
    String goodsId,
    Product model,
  }) {
    return ProductDetailState(
      goodsId: goodsId ?? this.goodsId,
      model: model ?? this.model,
    );
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ProductDetailState && o.goodsId == goodsId && o.model == model;
  }

  @override
  int get hashCode => goodsId.hashCode ^ model.hashCode;

  @override
  String toString() => 'ProductDetailState(goodsId: $goodsId, model: $model)';
}
