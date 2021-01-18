import 'package:fans/models/models.dart';
import 'package:fans/store/reducers/auth_reducer.dart';
import 'package:fans/store/reducers/feeds_reducer.dart';
import 'package:fans/store/reducers/search_by_tag_reducer.dart';
import 'package:fans/store/reducers/shop_detail_reducer.dart';

AppState appReducer(AppState state, action) {
  return AppState(
    verifyEmail: verifyEmailReducer(state.verifyEmail, action),
    auth: authReducer(state.auth, action),
    interests: interestReducer(state.interests, action),
    feeds: feedsReducer(state.feeds, action),
    tagSearch: searchByTagReducer(state.tagSearch, action),
    shopDetail: shopDetailReducer(state.shopDetail, action),
    error: errorReducer(state.error, action),
  );
}
