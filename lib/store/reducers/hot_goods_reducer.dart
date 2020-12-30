import 'package:fans/models/models.dart';
import 'package:fans/store/actions.dart';
import 'package:redux/redux.dart';

final hotGoodsReducer = combineReducers<List<Goods>>([
  TypedReducer<List<Goods>, HotsLoadedAction>(_setHotGoods),
]);

List<Goods> _setHotGoods(List<Goods> state, HotsLoadedAction action) {
  return List.from(action.hotGoods);
}
