import 'package:fans/models/feed.dart';
import 'package:fans/models/product.dart';
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
  final fetchRecommends = _createFetchRecommends();
  final fetchGoods = _createFetchGoods();
  final fetchProductDetail = _createProductDetail();
  final preOrder = _createPreOrder();
  final order = _createOrder();
  final payment = _createPayment();
  final addCart = _createAddCart();
  final fetchCartList = _createFetchCartList();

  return [
    TypedMiddleware<AppState, VerifyEmailAction>(verifyEmail),
    TypedMiddleware<AppState, LoginAction>(login),
    TypedMiddleware<AppState, SignupAction>(signup),
    TypedMiddleware<AppState, SendEmailAction>(sendEmail),
    TypedMiddleware<AppState, FetchInterestAction>(interests),
    TypedMiddleware<AppState, UploadInterestsAction>(uploadInterests),
    TypedMiddleware<AppState, FetchFeedsAction>(fetchFeeds),
    TypedMiddleware<AppState, FetchRecommendSellersAction>(fetchRecommends),
    TypedMiddleware<AppState, SearchByTagAction>(searchByTag),
    TypedMiddleware<AppState, FetchShopDetailAction>(fetchShopDetail),
    TypedMiddleware<AppState, FetchGoodsAction>(fetchGoods),
    TypedMiddleware<AppState, FetchProductDetailAction>(fetchProductDetail),
    TypedMiddleware<AppState, PreOrderAction>(preOrder),
    TypedMiddleware<AppState, OrderAction>(order),
    TypedMiddleware<AppState, PayAction>(payment),
    TypedMiddleware<AppState, AddCartAction>(addCart),
    TypedMiddleware<AppState, FetchCartListAction>(fetchCartList),
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
      store.dispatch(AuthLoadingAction());
      Networking.request(
              LoginAPI(email: action.email, password: action.password))
          .then(
        (data) {
          var user = User.fromMap(data['data']);
          AuthStorage.setToken(user.token);
          AuthStorage.setUser(user);
          store.dispatch(LoginOrSignupSuccessAction(user));
          Keys.navigatorKey.currentState.pushReplacementNamed(Routes.interests);
        },
      ).catchError((err) =>
              store.dispatch(LoginOrSignupFailureAction(err.toString())));
    }
    next(action);
  };
}

Middleware<AppState> _createSignup() {
  return (Store<AppState> store, action, NextDispatcher next) {
    if (action is SignupAction) {
      store.dispatch(AuthLoadingAction());
      Networking.request(
              LoginAPI(email: action.email, password: action.password))
          .then(
        (data) {
          var user = User.fromMap(data['data']);
          AuthStorage.setToken(user.token);
          AuthStorage.setUser(user);
          store.dispatch(LoginOrSignupSuccessAction(user));
          Keys.navigatorKey.currentState.pushReplacementNamed(Routes.interests);
        },
      ).catchError((err) =>
              store.dispatch(LoginOrSignupFailureAction(err.toString())));
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
              (data['data'] as List).map((e) => Interest.fromMap(e)).toList();
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
          store.dispatch(UploadInterestsSuccessAction());
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
          var totalPage = response['totalPage'];
          var currentPage = response['currentPage'];
          var list = response['list'] as List;
          List<Feed> feeds = list.map((e) => Feed.fromMap(e)).toList();

          bool isNoMore = feeds.isEmpty || currentPage == totalPage;
          action.completer.complete(isNoMore);
          store.dispatch(FetchFeedsSuccessAction(
              action.type, totalPage, currentPage, feeds));
        },
      ).catchError((err) {
        action.completer.completeError(err);
        store.dispatch(FetchFeedsFailedAction(action.type, err.toString()));
      });
    }
    next(action);
  };
}

Middleware<AppState> _createFetchRecommends() {
  return (Store<AppState> store, action, NextDispatcher next) {
    if (action is FetchRecommendSellersAction) {
      Networking.request(RecommendSellerAPI()).then(
        (data) {
          var response = data['data'];
          var list = response['list'] as List;
          List<Feed> models = list.map((e) => Feed.fromMap(e)).toList();

          store.dispatch(FetchRecommendSellersSuccessAction(models));
        },
      ).catchError((err) {
        print(err.toString());
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
          var totalPage = response['totalPage'];
          var currentPage = response['currentPage'];
          var list = response['list'] as List;
          List<Feed> feeds = list.map((e) => Feed.fromMap(e)).toList();

          bool isNoMore = feeds.isEmpty || currentPage == totalPage;
          action.completer?.complete(isNoMore);
          store.dispatch(SearchByTagSuccessAction(
              action.userId, action.tag, totalPage, currentPage, feeds));
        },
      ).catchError((err) {
        action.completer?.completeError(err?.toString() ?? '');
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
          var seller = Feed.fromMap(data['data']);
          store.dispatch(FetchShopDetailSuccessAction(seller: seller));
        },
      ).catchError((err) {
        store.dispatch(FetchShopDetailFailedAction(error: err.toString()));
      });
    }
    next(action);
  };
}

Middleware<AppState> _createFetchGoods() {
  return (Store<AppState> store, action, NextDispatcher next) {
    if (action is FetchGoodsAction) {
      Networking.request(GoodsAPI(
              userId: action.userId,
              type: action.type,
              page: action.page,
              limit: action.limit))
          .then(
        (data) {
          var response = data['data'];
          var totalPage = response['totalPage'];
          var currentPage = response['currentPage'];
          var list = response['list'] as List;
          List<Goods> models = list.map((e) => Goods.fromMap(e)).toList();

          var isNoMore = currentPage == totalPage;
          action.completer.complete(isNoMore);
          store.dispatch(FetchGoodsSuccessAction(
              currentPage: currentPage,
              totalPage: totalPage,
              type: action.type,
              list: models));
        },
      ).catchError((err) {
        action.completer.completeError(err.toString());
      });
    }
    next(action);
  };
}

Middleware<AppState> _createProductDetail() {
  return (Store<AppState> store, action, NextDispatcher next) {
    if (action is FetchProductDetailAction) {
      Networking.request(ProductDetailAPI(
        idolGoodsId: action.idolGoodsId,
      )).then(
        (data) {
          var response = data['data'];
          var model = Product.fromMap(response);
          action.completer.complete();
          store.dispatch(FetchProductDetailSuccessAction(model));
        },
      ).catchError((err) {
        action.completer.completeError(err);
      });
    }
    next(action);
  };
}

Middleware<AppState> _createPreOrder() {
  return (Store<AppState> store, action, NextDispatcher next) {
    if (action is PreOrderAction) {
      Networking.request(PreOrderAPI(
        buyGoods: action.buyGoods,
      )).then(
        (data) {
          var response = data['data'];
          final model = OrderDetail.fromMap(response);
          action.completer.complete(model);
          store.dispatch(PreOrderSuccessAction(orderDetail: model));
        },
      ).catchError((err) {
        action.completer.completeError(err.toString());
      });
    }
    next(action);
  };
}

Middleware<AppState> _createOrder() {
  return (Store<AppState> store, action, NextDispatcher next) {
    if (action is OrderAction) {
      Networking.request(OrderAPI(
        action.buyGoods,
        action.shippingAddressId,
        action.billingAddressId,
      )).then(
        (data) {
          final model = data['data'];
          action.completer.complete(model);
        },
      ).catchError((err) {
        action.completer.completeError(err.toString());
      });
    }
    next(action);
  };
}

Middleware<AppState> _createPayment() {
  return (Store<AppState> store, action, NextDispatcher next) {
    if (action is PayAction) {
      Networking.request(PayAPI(
        orderId: action.orderId,
        payName: action.payName,
      )).then(
        (data) {
          final response = data['data'];
          action.completer.complete(response['payInfo']);
        },
      ).catchError((err) {
        action.completer.completeError(err.toString());
      });
    }
    next(action);
  };
}

Middleware<AppState> _createAddCart() {
  return (Store<AppState> store, action, NextDispatcher next) {
    if (action is AddCartAction) {
      Networking.request(AddCartAPI(params: action.parameters)).then(
        (data) {
          action.completer.complete();
        },
      ).catchError((err) {
        action.completer.completeError(err.toString());
      });
    }
    next(action);
  };
}

Middleware<AppState> _createFetchCartList() {
  return (Store<AppState> store, action, NextDispatcher next) {
    if (action is FetchCartListAction) {
      Networking.request(CartListAPI()).then(
        (data) {
          final response = data['data'];
          final cart = Cart.fromMap(response);
          store.dispatch(OnUpdateCartAction(cart));
          action.completer.complete();
        },
      ).catchError((err) {
        action.completer.completeError(err.toString());
      });
    }
    next(action);
  };
}
