import 'package:redux/redux.dart';

import 'package:fans/store/actions.dart';
import 'package:fans/store/states.dart';

final productDetailReducer = combineReducers<ProductDetailsOnScreen>([
  TypedReducer<ProductDetailsOnScreen, ShowProductDetailAction>(_setGoodsId),
]);

ProductDetailsOnScreen _setGoodsId(
    ProductDetailsOnScreen state, ShowProductDetailAction action) {
  final allStates = Map.of(state.allStates);
  allStates[action.goodsId] = ProductDetailState(idolGoodsId: action.goodsId);
  return state.copyWith(currentId: action.goodsId, allStates: allStates);
}
