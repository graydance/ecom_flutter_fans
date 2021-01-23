import 'package:redux/redux.dart';

import 'package:fans/store/actions.dart';
import 'package:fans/store/states.dart';

final shopDetailReducer = combineReducers<ShopDetailState>([
  TypedReducer<ShopDetailState, ShowShopDetailAction>(_setUserId),
  TypedReducer<ShopDetailState, FetchShopDetailSuccessAction>(_setDetail),
  TypedReducer<ShopDetailState, FetchGoodsSuccessAction>(_setGoods),
]);

ShopDetailState _setUserId(ShopDetailState state, ShowShopDetailAction action) {
  return state.copyWith(
    userId: action.userId,
  );
}

ShopDetailState _setDetail(
    ShopDetailState state, FetchShopDetailSuccessAction action) {
  return state.copyWith(
    isLoading: false,
    error: '',
    user: action.seller,
  );
}

ShopDetailState _setGoods(
    ShopDetailState state, FetchGoodsSuccessAction action) {
  if (action.type == 0) {
    var list = action.currentPage == 1
        ? action.list
        : [...state.photos, ...action.list];
    return state.copyWith(
      photos: list,
      isLoading: false,
      error: '',
    );
  }
  if (action.type == 1) {
    var list = action.currentPage == 1
        ? action.list
        : [...state.albums, ...action.list];
    return state.copyWith(
      albums: list,
      isLoading: false,
      error: '',
    );
  }
  return state;
}
