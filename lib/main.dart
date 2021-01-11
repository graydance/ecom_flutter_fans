import 'package:flutter/material.dart';
import 'package:fans/app.dart';
import 'package:fans/models/appstate.dart';
import 'package:fans/store/middleware.dart';
import 'package:fans/store/reducers/appreducers.dart';
import 'package:logging/logging.dart';
import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final logger = new Logger('redux');
  logger.onRecord
      .where((record) => record.loggerName == logger.name)
      .listen((loggingMiddlewareRecord) => print(loggingMiddlewareRecord));
  final middleware = new LoggingMiddleware(logger: logger);

  runApp(ReduxApp(
    store: Store<AppState>(
      appReducer,
      initialState: AppState(),
      middleware: [...createStoreMiddleware(), middleware],
    ),
  ));
}
