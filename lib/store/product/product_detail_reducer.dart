import 'package:redux/redux.dart';

import 'package:fans/store/actions.dart';
import 'package:fans/store/states.dart';

final productDetailReducer = combineReducers<ProductDetailsOnScreen>([
  TypedReducer<ProductDetailsOnScreen, ShowProductDetailAction>(_setGoodsId),
  TypedReducer<ProductDetailsOnScreen, FetchProductDetailSuccessAction>(
      _setDetail),
]);

ProductDetailsOnScreen _setGoodsId(
    ProductDetailsOnScreen state, ShowProductDetailAction action) {
  final allStates = Map.of(state.allStates);
  allStates[action.idolGoodsId] =
      ProductDetailState(idolGoodsId: action.idolGoodsId);
  return state.copyWith(currentId: action.idolGoodsId, allStates: allStates);
}

ProductDetailsOnScreen _setDetail(
    ProductDetailsOnScreen state, FetchProductDetailSuccessAction action) {
  final allStates = Map.of(state.allStates);
  allStates[action.product.idolGoodsId] = ProductDetailState(
      idolGoodsId: action.product.idolGoodsId, model: action.product);
  return state.copyWith(allStates: allStates);
}
