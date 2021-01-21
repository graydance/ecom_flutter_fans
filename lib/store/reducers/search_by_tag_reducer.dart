import 'package:redux/redux.dart';

import 'package:fans/store/actions.dart';
import 'package:fans/store/states.dart';

final searchByTagReducer = combineReducers<SearchByTagState>([
  TypedReducer<SearchByTagState, SearchByTagAction>(_setSearch),
  TypedReducer<SearchByTagState, SearchByTagResponseAction>(_setSearchFeedList),
]);

SearchByTagState _setSearch(SearchByTagState state, SearchByTagAction action) {
  return state.copyWith(
    userId: action.userId,
    tag: action.tag,
    currentPage: action.page,
  );
}

SearchByTagState _setSearchFeedList(
    SearchByTagState state, SearchByTagResponseAction action) {
  return state.copyWith(
    list: action.feeds,
    currentPage: action.currentPage,
    totalPage: action.totalPage,
  );
}
