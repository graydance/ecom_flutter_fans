import 'package:redux/redux.dart';

import 'package:fans/models/models.dart';
import 'package:fans/store/actions.dart';

final cartReducer = combineReducers<Cart>([
  TypedReducer<Cart, OnUpdateCartAction>(_setCart),
]);

Cart _setCart(Cart state, OnUpdateCartAction action) {
  return action.cart;
}
