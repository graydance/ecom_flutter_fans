import 'package:redux/redux.dart';

import 'package:fans/store/actions.dart';
import 'package:fans/store/states.dart';

final preOrderReducer = combineReducers<PreOrderState>([
  TypedReducer<PreOrderState, PreOrderSuccessAction>(_setOrderDetail),
  TypedReducer<PreOrderState, OnUpdateOrderDetailAddress>(
      _updateOrderDetailAddress),
]);

PreOrderState _setOrderDetail(
    PreOrderState state, PreOrderSuccessAction action) {
  return state.copyWith(orderDetail: action.orderDetail);
}

PreOrderState _updateOrderDetailAddress(
    PreOrderState state, OnUpdateOrderDetailAddress action) {
  final orderDetail = action.isShippingAddress
      ? state.orderDetail.copyWith(address: action.address)
      : state.orderDetail.copyWith(billAddress: action.address);
  return state.copyWith(orderDetail: orderDetail);
}
