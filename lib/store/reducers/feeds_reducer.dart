import 'package:redux/redux.dart';

import 'package:fans/store/actions.dart';
import 'package:fans/store/states.dart';

final feedsReducer = combineReducers<HomeState>([
  TypedReducer<HomeState, FeedsResponseAction>(_setFeedsList),
]);

HomeState _setFeedsList(HomeState state, FeedsResponseAction action) {
  if (action.type == 0) {
    var list = action.currentPage == 1
        ? action.feeds
        : [state.followingFeeds, ...action.feeds];
    return state.copyWith(
        followingFeeds: state.followingFeeds.copyWith(list: list));
  }
  if (action.type == 1) {
    var list = action.currentPage == 1
        ? action.feeds
        : [state.forYouFeeds, ...action.feeds];
    return state.copyWith(
        followingFeeds: state.forYouFeeds.copyWith(list: list));
  }
  return state;
}
