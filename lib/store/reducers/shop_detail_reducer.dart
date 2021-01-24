import 'package:redux/redux.dart';

import 'package:fans/store/actions.dart';
import 'package:fans/store/states.dart';

final shopDetailReducer = combineReducers<ShopDetailState>([
  TypedReducer<ShopDetailState, ShowShopDetailAction>(_setUserId),
  TypedReducer<ShopDetailState, FetchShopDetailSuccessAction>(_setDetail),
  TypedReducer<ShopDetailState, FetchGoodsSuccessAction>(_setGoods),
]);

ShopDetailState _setUserId(ShopDetailState state, ShowShopDetailAction action) {
  return ShopDetailState(
    userId: action.userId,
  );
}

ShopDetailState _setDetail(
    ShopDetailState state, FetchShopDetailSuccessAction action) {
  return state.copyWith(
    isLoading: false,
    error: '',
    seller: action.seller,
  );
}

ShopDetailState _setGoods(
    ShopDetailState state, FetchGoodsSuccessAction action) {
  if (action.type == 0) {
    var list = action.currentPage == 1
        ? action.list
        : [...state.photos.list, ...action.list];
    return state.copyWith(
      photos: state.photos.copyWith(
        currentPage: action.currentPage,
        totalPage: action.totalPage,
        list: list,
      ),
      isLoading: false,
      error: '',
    );
  }
  if (action.type == 1) {
    var list = action.currentPage == 1
        ? action.list
        : [...state.albums.list, ...action.list];
    return state.copyWith(
      albums: state.photos.copyWith(
        currentPage: action.currentPage,
        totalPage: action.totalPage,
        list: list,
      ),
      isLoading: false,
      error: '',
    );
  }
  return state;
}
