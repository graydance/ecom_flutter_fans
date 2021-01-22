import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:fans/models/appstate.dart';
import 'package:fans/screen/interest_list_screen.dart';
import 'package:fans/screen/screens.dart';
import 'package:fans/screen/shop_screen.dart';
import 'package:fans/store/actions.dart';

class ReduxApp extends StatelessWidget {
  final Store<AppState> store;
  const ReduxApp({this.store});
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
            Routes.searchByTag: (context) => SearchByTagScreen(
                  onInit: () {
                    StoreProvider.of<AppState>(context)
                        .dispatch(SearchByTagAction());
                  },
                ),
            Routes.shop: (context) => ShopDetailScreen(),
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
  static final shop = 'shop';
}
