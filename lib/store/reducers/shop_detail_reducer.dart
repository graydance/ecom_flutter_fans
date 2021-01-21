import 'package:redux/redux.dart';

import 'package:fans/store/actions.dart';
import 'package:fans/store/states.dart';

final shopDetailReducer = combineReducers<ShopDetailState>([
  TypedReducer<ShopDetailState, ShowShopDetailAction>(_setUserId),
  TypedReducer<ShopDetailState, ShopDetailResponseAction>(_setDetail),
]);

ShopDetailState _setUserId(ShopDetailState state, ShowShopDetailAction action) {
  return state.copyWith(
    userId: action.userId,
  );
}

ShopDetailState _setDetail(
    ShopDetailState state, ShopDetailResponseAction action) {
  return state.copyWith(
    isLoading: false,
    error: '',
    user: action.seller,
  );
}
