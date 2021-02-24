import 'package:fans/screen/order/payment_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:logging/logging.dart';
import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';

import 'package:fans/models/appstate.dart';
import 'package:fans/screen/home/shop_detail_screen.dart';
import 'package:fans/screen/login/interest_list_screen.dart';
import 'package:fans/screen/order/payment_screen.dart';
import 'package:fans/screen/order/payment_success_screen.dart';
import 'package:fans/screen/screens.dart';
import 'package:fans/screen/shop/shop_screen.dart';
import 'package:fans/store/actions.dart';
import 'package:fans/store/appreducers.dart';
import 'package:fans/store/middleware.dart';

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
            Routes.paypalResult: (context) => PaymentResultScreen(),
          },
          builder: EasyLoading.init(),
          onGenerateRoute: RouteConfiguration.onGenerateRoute,
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
  static final paypalPayment = '/paypal_payment';
  static final paypalResult = '/paypal_result';
}

class Path {
  const Path(this.pattern, this.useQueryString, this.builder);

  /// A RegEx string for route matching.
  final String pattern;

  final bool useQueryString;

  /// The builder for the associated pattern route. The first argument is the
  /// [BuildContext] and the second argument is a RegEx match if it is
  /// included inside of the pattern.
  final Widget Function(BuildContext, dynamic) builder;
}

class RouteConfiguration {
  /// List of [Path] to for route matching. When a named route is pushed with
  /// [Navigator.pushNamed], the route name is matched with the [Path.pattern]
  /// in the list below. As soon as there is a match, the associated builder
  /// will be returned. This means that the paths higher up in the list will
  /// take priority.
  static List<Path> paths = [
    Path(
      r'^' + Routes.shop + r'/([\w-]+)$',
      false,
      (context, match) => ShopScreen(
        userId: match,
      ),
    ),
    Path(
      Routes.paypalResult,
      true,
      (context, args) => PaymentResultScreen(
        arguments: args,
      ),
    ),
  ];

  /// The route generator callback used when the app is navigated to a named
  /// route. Set it on the [MaterialApp.onGenerateRoute] or
  /// [WidgetsApp.onGenerateRoute] to make use of the [paths] for route
  /// matching.
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    for (Path path in paths) {
      if (path.useQueryString && settings.name.startsWith(path.pattern)) {
        final queryParameters = Uri.parse(settings.name).queryParameters;
        return MaterialPageRoute<void>(
          builder: (context) => path.builder(
              context, PaymentResultArguments.fromMap(queryParameters)),
          settings: settings,
        );
      } else {
        final regExpPattern = RegExp(path.pattern);
        if (regExpPattern.hasMatch(settings.name)) {
          final firstMatch = regExpPattern.firstMatch(settings.name);
          final match =
              (firstMatch.groupCount == 1) ? firstMatch.group(1) : null;
          return MaterialPageRoute<void>(
            builder: (context) => path.builder(context, match),
            settings: settings,
          );
        }
      }
    }

    // If no match was found, we let [WidgetsApp.onUnknownRoute] handle it.
    return null;
  }
}
