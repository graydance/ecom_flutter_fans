import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:fans/models/appstate.dart';
import 'package:fans/screen/screens.dart';
import 'package:fans/store/actions.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class ReduxApp extends StatelessWidget {
  final Store<AppState> store;
  const ReduxApp({this.store});
  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
        store: store,
        child: CupertinoApp(
          theme: CupertinoThemeData(
            scaffoldBackgroundColor: CupertinoColors.white,
          ),
          initialRoute: '/',
          navigatorKey: navigatorKey,
          routes: {
            '/': (context) => SplashScreen(),
            '/welcome': (context) => WelcomeScreen(),
            '/authemail': (context) => AuthEmailScreen(),
            '/signup': (context) => SignupScreen(),
            '/login': (context) => LoginScreen(),
            '/forgotpwd': (context) => ForgotPasswordScreen(),
            '/home': (context) => HomeScreen(
                  onInit: () {
                    StoreProvider.of<AppState>(context)
                        .dispatch(LoadHotsAction());
                  },
                ),
          },
          builder: EasyLoading.init(),
        ));
  }
}
