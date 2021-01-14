import 'package:redux/redux.dart';

import 'package:fans/store/actions.dart';
import 'package:fans/store/states.dart';

final feedsReducer = combineReducers<HomeState>([
  TypedReducer<HomeState, FetchFeedsStartLoadingAction>(_setLoading),
  TypedReducer<HomeState, FeedsResponseAction>(_setFeedsList),
  TypedReducer<HomeState, FeedsResponseFailedAction>(_setFeedsListError),
]);

HomeState _setLoading(HomeState state, FetchFeedsStartLoadingAction action) {
  if (action.type == 0) {
    return state.copyWith(
        followingFeeds: state.followingFeeds.copyWith(
      isLoading: true,
      error: '',
    ));
  }
  return state.copyWith(
      forYouFeeds: state.forYouFeeds.copyWith(
    isLoading: true,
    error: '',
  ));
}

HomeState _setFeedsList(HomeState state, FeedsResponseAction action) {
  if (action.type == 0) {
    var list = action.currentPage == 1
        ? action.feeds
        : [state.followingFeeds, ...action.feeds];
    return state.copyWith(
        followingFeeds: state.followingFeeds.copyWith(
      list: list,
      isLoading: false,
      error: '',
    ));
  }
  if (action.type == 1) {
    var list = action.currentPage == 1
        ? action.feeds
        : [state.forYouFeeds, ...action.feeds];
    return state.copyWith(
        forYouFeeds: state.forYouFeeds.copyWith(
      list: list,
      isLoading: false,
      error: '',
    ));
  }
  return state;
}

HomeState _setFeedsListError(
    HomeState state, FeedsResponseFailedAction action) {
  if (action.type == 0) {
    return state.copyWith(
        followingFeeds: state.followingFeeds.copyWith(
      isLoading: false,
      error: action.error,
    ));
  }
  return state.copyWith(
      forYouFeeds: state.forYouFeeds.copyWith(
    isLoading: false,
    error: action.error,
  ));
}
