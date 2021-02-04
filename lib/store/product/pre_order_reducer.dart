import 'package:redux/redux.dart';

import 'package:fans/store/actions.dart';
import 'package:fans/store/states.dart';

final preOrderReducer = combineReducers<PreOrderState>([
  TypedReducer<PreOrderState, PreOrderSuccessAction>(_setOrderDetail),
]);

PreOrderState _setOrderDetail(
    PreOrderState state, PreOrderSuccessAction action) {
  return state.copyWith(orderDetail: action.orderDetail);
}
