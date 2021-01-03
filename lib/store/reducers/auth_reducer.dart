import 'package:fans/store/actions.dart';
import 'package:redux/redux.dart';

final authReducer = combineReducers<bool>([
  TypedReducer<bool, EmailCheckedAction>(_setIsRegist),
]);

bool _setIsRegist(bool state, EmailCheckedAction action) {
  return action.isRegist;
}
