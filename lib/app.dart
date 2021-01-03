import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fans/models/appstate.dart';
import 'package:fans/screen/screens.dart';
import 'package:fans/store/actions.dart';
import 'package:redux/redux.dart';

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
          ),
          initialRoute: '/',
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
        ));
  }
}
