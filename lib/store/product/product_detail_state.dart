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
  final String idolGoodsId;
  final Product model;

  ProductDetailState({this.idolGoodsId = '', this.model = const Product()});

  ProductDetailState copyWith({
    String idolGoodsId,
    Product model,
  }) {
    return ProductDetailState(
      idolGoodsId: idolGoodsId ?? this.idolGoodsId,
      model: model ?? this.model,
    );
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ProductDetailState &&
        o.idolGoodsId == idolGoodsId &&
        o.model == model;
  }

  @override
  int get hashCode => idolGoodsId.hashCode ^ model.hashCode;

  @override
  String toString() =>
      'ProductDetailState(idolGoodsId: $idolGoodsId, model: $model)';
}
