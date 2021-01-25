import 'package:redux/redux.dart';

import 'package:fans/store/actions.dart';
import 'package:fans/store/states.dart';

final feedsReducer = combineReducers<HomeState>([
  TypedReducer<HomeState, FetchFeedsStartLoadingAction>(_setLoading),
  TypedReducer<HomeState, FetchFeedsSuccessAction>(_setFeedsList),
  TypedReducer<HomeState, FetchFeedsFailedAction>(_setFeedsListError),
  TypedReducer<HomeState, FetchRecommendSellersSuccessAction>(
      _setRecommendList),
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

HomeState _setFeedsList(HomeState state, FetchFeedsSuccessAction action) {
  if (action.type == 0) {
    var list = action.currentPage == 1
        ? action.feeds
        : [...state.followingFeeds.list, ...action.feeds];
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
        : [...state.forYouFeeds.list, ...action.feeds];
    return state.copyWith(
        forYouFeeds: state.forYouFeeds.copyWith(
      list: list,
      isLoading: false,
      error: '',
    ));
  }
  return state;
}

HomeState _setFeedsListError(HomeState state, FetchFeedsFailedAction action) {
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

HomeState _setRecommendList(
    HomeState state, FetchRecommendSellersSuccessAction action) {
  return state.copyWith(
      followingFeeds: state.followingFeeds.copyWith(
    recommendUsers: action.sellers,
  ));
}
