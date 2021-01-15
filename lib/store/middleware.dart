import 'package:fans/storage/auth_storage.dart';
import 'package:redux/redux.dart';

import 'package:fans/api.dart';
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

  return [
    TypedMiddleware<AppState, VerifyEmailAction>(verifyEmail),
    TypedMiddleware<AppState, LoginAction>(login),
    TypedMiddleware<AppState, SignupAction>(signup),
    TypedMiddleware<AppState, SendEmailAction>(sendEmail),
    TypedMiddleware<AppState, FetchInterestAction>(interests),
    TypedMiddleware<AppState, UploadInterestsAction>(uploadInterests),
    TypedMiddleware<AppState, FetchFeedsAction>(fetchFeeds),
  ];
}

Middleware<AppState> _createVerifyEmail() {
  return (Store<AppState> store, action, NextDispatcher next) {
    if (action is VerifyEmailAction) {
      var email = action.email;
      api('/user/login', {'email': email, 'password': ''}).then(
        (data) {
          var code = data['code'];
          if (code == 401) {
            // 用户不存在
            store.dispatch(VerifyEmailSuccessAction(email));
            Keys.navigatorKey.currentState.pushReplacementNamed(Routes.signup);
          } else if (code == 402) {
            // 邮箱已注册
            store.dispatch(VerifyEmailSuccessAction(email));
            Keys.navigatorKey.currentState.pushReplacementNamed(Routes.login);
          } else {
            print(data['msg'].toString());
          }
        },
      ).catchError((error) => print(error.toString()));
    }
    next(action);
  };
}

Middleware<AppState> _createLogin() {
  return (Store<AppState> store, action, NextDispatcher next) {
    if (action is LoginAction) {
      api('/user/login', {'email': action.email, 'password': action.password})
          .then(
        (data) {
          if (data['code'] == 0) {
            var user = User.fromJson(data['data']);
            AuthStorage.setToken(user.token);
            store.dispatch(LoginSuccessAction(user));
            Keys.navigatorKey.currentState
                .pushReplacementNamed(Routes.interests);
          } else {
            // store.dispatch(LoginFailureAction(data['msg'].toString()));
            print(data['msg'].toString());
          }
        },
      ).catchError((err) => print(err.toString()));
    }
    next(action);
  };
}

Middleware<AppState> _createSignup() {
  return (Store<AppState> store, action, NextDispatcher next) {
    if (action is SignupAction) {
      api('/user/login', {'email': action.email, 'password': action.password})
          .then(
        (data) {
          if (data['code'] == 0) {
            var user = User.fromJson(data['data']);
            AuthStorage.setToken(user.token);
            store.dispatch(SignupSuccessAction(user));
            Keys.navigatorKey.currentState
                .pushReplacementNamed(Routes.interests);
          } else {
            print(data['msg'].toString());
            // store.dispatch(SignupFailureAction(data['msg'].toString()));
          }
        },
      ).catchError((err) => print(err.toString()));
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
      api('/user/interest_list', {}).then(
        (data) {
          if (data['code'] == 0) {
            var list = (data['data'] as List)
                .map((e) => Interest.fromJson(e))
                .toList();
            store.dispatch(FetchInterestSuccessAction(list));
          } else {
            store.dispatch(InterestsFailedAction(data['msg'].toString()));
          }
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
      api('/user/interest_updata', {'interestIdList': action.idList}).then(
        (data) {
          if (data['code'] == 0) {
            store.dispatch(Keys.navigatorKey.currentState
                .pushReplacementNamed(Routes.home));
          } else {
            store.dispatch(InterestsFailedAction(data['msg'].toString()));
          }
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
      api('/user/following', {'type': action.type, 'page': action.page}).then(
        (data) {
          if (data['code'] == 0) {
            var response = data['data'];
            var totalPage = response['total_page'];
            var currentPage = response['current_page'];
            var list = response['list'] as List;
            List<Goods> feeds = list.map((e) => Goods.fromJson(e)).toList();

            bool isNoMore = feeds.isEmpty || currentPage == totalPage;
            action.completer.complete(isNoMore);
            store.dispatch(FeedsResponseAction(
                action.type, totalPage, currentPage, feeds));
          } else {
            print(data['msg'].toString());

            action.completer.completeError(data['msg'].toString());
            store.dispatch(
                FeedsResponseFailedAction(action.type, data['msg'].toString()));
          }
        },
      ).catchError((err) {
        print(err.toString());

        action.completer.completeError(err);
        store.dispatch(FeedsResponseFailedAction(action.type, err.toString()));
      });
    }
    next(action);
  };
}
