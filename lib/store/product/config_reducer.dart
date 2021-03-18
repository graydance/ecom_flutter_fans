import 'package:redux/redux.dart';

import 'package:fans/models/models.dart';
import 'package:fans/store/actions.dart';

final configReducer = combineReducers<Config>([
  TypedReducer<Config, OnUpdateConfigAction>(_setConfig),
]);

Config _setConfig(Config state, OnUpdateConfigAction action) {
  return action.config;
}
