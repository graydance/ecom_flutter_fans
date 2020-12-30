import 'package:flutter/cupertino.dart';
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
        child: CupertinoApp(
          theme: CupertinoThemeData(
            scaffoldBackgroundColor: CupertinoColors.white,
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => HomeScreen(
                  onInit: () {
                    StoreProvider.of<AppState>(context)
                        .dispatch(LoadHotsAction());
                  },
                ),
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
