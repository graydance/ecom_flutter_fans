import 'package:redux/redux.dart';

import 'package:fans/store/actions.dart';
import 'package:fans/store/states.dart';

final searchByTagReducer = combineReducers<SearchByTagState>([
  TypedReducer<SearchByTagState, ShowSearchByTagAction>(_setShowSearch),
  TypedReducer<SearchByTagState, SearchByTagAction>(_setSearch),
  TypedReducer<SearchByTagState, SearchByTagSuccessAction>(_setSearchFeedList),
]);

SearchByTagState _setShowSearch(
    SearchByTagState state, ShowSearchByTagAction action) {
  return SearchByTagState(
    feed: action.feed,
    tag: action.tag,
  );
}

SearchByTagState _setSearch(SearchByTagState state, SearchByTagAction action) {
  return state.copyWith(
    currentPage: action.page,
  );
}

SearchByTagState _setSearchFeedList(
    SearchByTagState state, SearchByTagSuccessAction action) {
  return state.copyWith(
    list: action.feeds,
    currentPage: action.currentPage,
    totalPage: action.totalPage,
  );
}
