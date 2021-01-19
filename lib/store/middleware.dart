import 'package:fans/networking/api_exceptions.dart';
import 'package:fans/networking/networking.dart';
import 'package:fans/storage/auth_storage.dart';
import 'package:redux/redux.dart';

import 'package:fans/networking/api.dart';
import 'package:fans/app.dart';
import 'package:fans/models/models.dart';
import 'package:fans/store/actions.dart';

List<Middleware<AppState>> createStoreMiddleware() {
  final verifyEmail = _createVerifyEmail();
  final login = _createLogin();
  final sendEmail = _createSendEmail();
  final signup = _createSignup();
  final interests = _createFetchInterests();
  final uploadInterests = _createUploadInterests();
  final fetchFeeds = _createFetchFeeds();
  final searchByTag = _createSearchByTag();
  final fetchShopDetail = _createShopDetail();

  return [
    TypedMiddleware<AppState, VerifyEmailAction>(verifyEmail),
    TypedMiddleware<AppState, LoginAction>(login),
    TypedMiddleware<AppState, SignupAction>(signup),
    TypedMiddleware<AppState, SendEmailAction>(sendEmail),
    TypedMiddleware<AppState, FetchInterestAction>(interests),
    TypedMiddleware<AppState, UploadInterestsAction>(uploadInterests),
    TypedMiddleware<AppState, FetchFeedsAction>(fetchFeeds),
    TypedMiddleware<AppState, SearchByTagAction>(searchByTag),
    TypedMiddleware<AppState, FetchShopDetailAction>(fetchShopDetail),
  ];
}

Middleware<AppState> _createVerifyEmail() {
  return (Store<AppState> store, action, NextDispatcher next) {
    if (action is VerifyEmailAction) {
      store.dispatch(VerifyEmailLoadingAction());
      var email = action.email;
      Networking.request(LoginAPI(email: action.email, password: ''))
          .then((data) {
        store.dispatch(VerifyEmailFailedAction(data.toString()));
      }).catchError((error) {
        if (error is APIException) {
          if (error.code == 401) {
            // 用户不存在
            store.dispatch(VerifyEmailSuccessAction(email));
            Keys.navigatorKey.currentState.pushReplacementNamed(Routes.signup);
          } else if (error.code == 402) {
            // 邮箱已注册
            store.dispatch(VerifyEmailSuccessAction(email));
            Keys.navigatorKey.currentState.pushReplacementNamed(Routes.login);
          } else {
            store.dispatch(VerifyEmailFailedAction(error.message));
          }
        } else {
          store.dispatch(VerifyEmailFailedAction(error.toString()));
        }
      });
    }
    next(action);
  };
}

Middleware<AppState> _createLogin() {
  return (Store<AppState> store, action, NextDispatcher next) {
    if (action is LoginAction) {
      Networking.request(
              LoginAPI(email: action.email, password: action.password))
          .then(
        (data) {
          var user = User.fromMap(data['data']);
          AuthStorage.setToken(user.token);
          AuthStorage.setUser(user);
          store.dispatch(LoginSuccessAction(user));
          Keys.navigatorKey.currentState.pushReplacementNamed(Routes.interests);
        },
      ).catchError((err) => store.dispatch(LoginFailureAction(err.toString())));
    }
    next(action);
  };
}

Middleware<AppState> _createSignup() {
  return (Store<AppState> store, action, NextDispatcher next) {
    if (action is SignupAction) {
      Networking.request(
              LoginAPI(email: action.email, password: action.password))
          .then(
        (data) {
          var user = User.fromMap(data['data']);
          AuthStorage.setToken(user.token);
          AuthStorage.setUser(user);
          store.dispatch(SignupSuccessAction(user));
          Keys.navigatorKey.currentState.pushReplacementNamed(Routes.interests);
        },
      ).catchError(
              (err) => store.dispatch(SignupFailureAction(err.toString())));
    }
    next(action);
  };
}

Middleware<AppState> _createSendEmail() {
  return (Store<AppState> store, action, NextDispatcher next) {
    if (action is SendEmailAction) {
      // String email = action.email;
      store.dispatch(SendEmailFailureAction('Send email failure'));
    }
    next(action);
  };
}

Middleware<AppState> _createFetchInterests() {
  return (Store<AppState> store, action, NextDispatcher next) {
    if (action is FetchInterestAction) {
      store.dispatch(FetchInterestStartLoadingAction());
      Networking.request(InterestListAPI()).then(
        (data) {
          var list =
              (data['data'] as List).map((e) => Interest.fromJson(e)).toList();
          store.dispatch(FetchInterestSuccessAction(list));
        },
      ).catchError(
          (err) => store.dispatch(InterestsFailedAction(err.toString())));
    }
    next(action);
  };
}

Middleware<AppState> _createUploadInterests() {
  return (Store<AppState> store, action, NextDispatcher next) {
    if (action is UploadInterestsAction) {
      store.dispatch(FetchInterestStartLoadingAction());
      Networking.request(UploadInterestsAPI(action.idList)).then(
        (data) {
          store.dispatch(
              Keys.navigatorKey.currentState.pushReplacementNamed(Routes.home));
        },
      ).catchError(
          (err) => store.dispatch(InterestsFailedAction(err.toString())));
    }
    next(action);
  };
}

Middleware<AppState> _createFetchFeeds() {
  return (Store<AppState> store, action, NextDispatcher next) {
    if (action is FetchFeedsAction) {
      store.dispatch(FetchFeedsStartLoadingAction(action.type));
      Networking.request(FeedsAPI(type: action.type, page: action.page)).then(
        (data) {
          var response = data['data'];
          var totalPage = response['total_page'];
          var currentPage = response['current_page'];
          var list = response['list'] as List;
          List<Feed> feeds = list.map((e) => Feed.fromJson(e)).toList();

          bool isNoMore = feeds.isEmpty || currentPage == totalPage;
          action.completer.complete(isNoMore);
          store.dispatch(
              FeedsResponseAction(action.type, totalPage, currentPage, feeds));
        },
      ).catchError((err) {
        action.completer.completeError(err);
        store.dispatch(FeedsResponseFailedAction(action.type, err.toString()));
      });
    }
    next(action);
  };
}

Middleware<AppState> _createSearchByTag() {
  return (Store<AppState> store, action, NextDispatcher next) {
    if (action is SearchByTagAction) {
      Networking.request(TagSearchAPI(
              tag: action.tag,
              userId: action.userId,
              page: action.page,
              limit: action.limit))
          .then(
        (data) {
          var response = data['data'];
          var totalPage = response['total_page'];
          var currentPage = response['current_page'];
          var list = response['list'] as List;
          List<Goods> feeds = list.map((e) => Goods.fromJson(e)).toList();

          bool isNoMore = feeds.isEmpty || currentPage == totalPage;
          action.completer.complete(isNoMore);
          store.dispatch(
              SearchByTagResponseAction(totalPage, currentPage, feeds));
        },
      ).catchError((err) {
        action.completer.completeError(err.toString());
      });
    }
    next(action);
  };
}

Middleware<AppState> _createShopDetail() {
  return (Store<AppState> store, action, NextDispatcher next) {
    if (action is FetchShopDetailAction) {
      Networking.request(ShopDetailAPI(action.userId)).then(
        (data) {
          var response = data['data'];
          var user = User.fromJson(response);

          store.dispatch(ShopDetailResponseAction(user: user));
        },
      ).catchError((err) {
        store.dispatch(ShopDetailFailedAction(error: err.toString()));
      });
    }
    next(action);
  };
}
