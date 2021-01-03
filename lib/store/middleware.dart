import 'package:fans/api.dart';
import 'package:fans/store/actions.dart';
import 'package:redux/redux.dart';
import 'package:fans/models/models.dart';

List<Middleware<AppState>> createStoreMiddleware() {
  final loadHots = _createLoadHots();
  final checkEmail = _createCheckEmail();

  return [
    TypedMiddleware<AppState, LoadHotsAction>(loadHots),
    TypedMiddleware<AppState, CheckEmailAction>(checkEmail),
  ];
}

Middleware<AppState> _createLoadHots() {
  return (Store<AppState> store, action, NextDispatcher next) {
    api('/hots', {}, '').then(
      (hots) {
        store.dispatch(
            HotsLoadedAction(hots['idols'], hots['goods'], hots['cart']));
      },
    ).catchError((err) => store.dispatch(HotsNotLoadedAction(err.toString())));
    next(action);
  };
}

Middleware<AppState> _createCheckEmail() {
  return (Store<AppState> store, action, NextDispatcher next) {
    // api('/user/is_regist', {}, '').then(
    //   (data) {
    //     store.dispatch(EmailCheckedAction(data['is_regist']));
    //   },
    // ).catchError((err) => store.dispatch(HotsNotLoadedAction(err.toString())));
    store.dispatch(EmailCheckedAction(false));
    next(action);
  };
}
