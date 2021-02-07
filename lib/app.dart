import 'package:fans/screen/order/payment_screen.dart';
import 'package:fans/screen/order/payment_success_screen.dart';
import 'package:fans/screen/shop/shop_screen.dart';
import 'package:fans/store/appreducers.dart';
import 'package:fans/store/middleware.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:logging/logging.dart';
import 'package:redux/redux.dart';

import 'package:fans/models/appstate.dart';
import 'package:fans/screen/login/interest_list_screen.dart';
import 'package:fans/screen/screens.dart';
import 'package:fans/screen/home/shop_detail_screen.dart';
import 'package:fans/store/actions.dart';
import 'package:redux_logging/redux_logging.dart';

class ReduxApp extends StatefulWidget {
  @override
  _ReduxAppState createState() => _ReduxAppState();
}

class _ReduxAppState extends State<ReduxApp> {
  Store<AppState> store;

  @override
  void initState() {
    super.initState();

    EasyRefresh.defaultHeader = ClassicalHeader(showInfo: false);
    EasyRefresh.defaultFooter = ClassicalFooter(showInfo: false);

    final logger = new Logger('Fans');
    logger.onRecord
        .where((record) => record.loggerName == logger.name)
        .listen((loggingMiddlewareRecord) => print(loggingMiddlewareRecord));
    final middleware = new LoggingMiddleware(logger: logger);
    store = Store<AppState>(
      appReducer,
      initialState: AppState(),
      middleware: [...createStoreMiddleware(), middleware],
    );
    store.dispatch(VerifyAuthenticationState());
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
        store: store,
        child: MaterialApp(
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            primaryColor: Colors.white,
          ),
          initialRoute: Routes.splash,
          navigatorKey: Keys.navigatorKey,
          routes: {
            Routes.splash: (context) => SplashScreen(),
            Routes.welcome: (context) => WelcomeScreen(),
            Routes.verifyEmail: (context) => AuthEmailScreen(),
            Routes.signup: (context) => SignupScreen(),
            Routes.login: (context) => LoginScreen(),
            Routes.forgotPassword: (context) => ForgotPasswordScreen(),
            Routes.interests: (context) => InterestListScreen(
                  onInit: () {
                    StoreProvider.of<AppState>(context)
                        .dispatch(FetchInterestAction());
                  },
                ),
            Routes.home: (context) => TabbarScreen(
                  onInit: () {},
                ),
            Routes.searchByTag: (context) => SearchByTagScreen(),
            Routes.shopDetail: (context) => ShopDetailScreen(),
            Routes.productDetail: (context) => ProductDetailScreen(),
            Routes.cart: (context) => CartScreen(),
            Routes.preOrder: (context) => PreOrderScreen(),
            Routes.payment: (context) => PaymentScreen(),
            Routes.paymentSuccess: (context) => PaymentSuccessScreen(),
            Routes.shop: (context) => ShopScreen(),
            Routes.signin: (context) => SignInScreen(),
          },
          builder: EasyLoading.init(),
        ));
  }
}

class Keys {
  static final navigatorKey = new GlobalKey<NavigatorState>();
}

class Routes {
  static final splash = '/';
  static final welcome = '/welcome';
  static final verifyEmail = '/verfiy_email';
  static final signup = '/signup';
  static final login = '/login';
  static final forgotPassword = '/forgot_password';
  static final interests = 'interests';
  static final home = '/home';
  static final searchByTag = '/search_by_tag';
  static final shop = '/shop';
  static final productDetail = '/product_detail';
  static final cart = '/cart';
  static final preOrder = '/preorder';
  static final payment = '/payment';
  static final paymentSuccess = '/payment_success';
  static final shopDetail = '/shop_detail';
  static final signin = '/sign_in';
}
