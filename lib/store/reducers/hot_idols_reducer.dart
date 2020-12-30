import 'package:fans/models/idol.dart';
import 'package:fans/store/actions.dart';
import 'package:redux/redux.dart';

final hotIdolsReducer = combineReducers<List<Idol>>([
  TypedReducer<List<Idol>, HotsLoadedAction>(_setHotIdols),
]);

List<Idol> _setHotIdols(List<Idol> state, HotsLoadedAction action) {
  return List.from(action.hotIdols);
}
