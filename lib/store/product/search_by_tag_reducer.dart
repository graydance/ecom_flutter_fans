import 'package:redux/redux.dart';

import 'package:fans/store/actions.dart';
import 'package:fans/store/states.dart';

final searchByTagReducer = combineReducers<SearchByTagStateList>([
  TypedReducer<SearchByTagStateList, ShowSearchByTagAction>(_setShowSearch),
  TypedReducer<SearchByTagStateList, SearchByTagAction>(_setSearch),
  TypedReducer<SearchByTagStateList, SearchByTagSuccessAction>(
      _setSearchFeedList),
]);

String _pageId(String userId, String tag) {
  return '${userId}_$tag';
}

SearchByTagStateList _setShowSearch(
    SearchByTagStateList state, ShowSearchByTagAction action) {
  final pageId = _pageId(action.feed.id, action.tag);
  final allSearch = Map.of(state.allSearch);
  allSearch[pageId] = SearchByTagState(feed: action.feed, tag: action.tag);
  return state.copyWith(current: pageId, allSearch: allSearch);
}

SearchByTagStateList _setSearch(
    SearchByTagStateList state, SearchByTagAction action) {
  final pageId = _pageId(action.userId, action.tag);
  final allSearch = Map.of(state.allSearch);
  allSearch[pageId].copyWith(
    currentPage: action.page,
  );
  return state.copyWith(allSearch: allSearch);
}

SearchByTagStateList _setSearchFeedList(
    SearchByTagStateList state, SearchByTagSuccessAction action) {
  final pageId = _pageId(action.userId, action.tag);

  final allSearch = Map.of(state.allSearch);
  final currentState = allSearch[pageId];
  final list = action.currentPage == 1
      ? action.feeds
      : [...currentState.list, ...action.feeds];

  allSearch[pageId] = currentState.copyWith(
    list: list,
    currentPage: action.currentPage,
    totalPage: action.totalPage,
  );

  return state.copyWith(allSearch: allSearch);
}
