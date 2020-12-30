import 'package:flutter/cupertino.dart';
import 'package:fans/app.dart';
import 'package:fans/models/appstate.dart';
import 'package:fans/store/middleware.dart';
import 'package:fans/store/reducers/appreducers.dart';
import 'package:redux/redux.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ReduxApp(
    store: Store<AppState>(
      appReducer,
      initialState: AppState.loading(),
      middleware: createStoreMiddleware(),
    ),
  ));
}
