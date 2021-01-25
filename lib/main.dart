import 'package:fans/storage/auth_storage.dart';
import 'package:flutter/material.dart';
import 'package:fans/app.dart';
import 'package:fans/models/appstate.dart';
import 'package:fans/store/middleware.dart';
import 'package:fans/store/appreducers.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:logging/logging.dart';
import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final logger = new Logger('Fans');
  logger.onRecord
      .where((record) => record.loggerName == logger.name)
      .listen((loggingMiddlewareRecord) => print(loggingMiddlewareRecord));
  final middleware = new LoggingMiddleware(logger: logger);

  EasyRefresh.defaultHeader = ClassicalHeader(showInfo: false);
  EasyRefresh.defaultFooter = ClassicalFooter(showInfo: false);

  await AuthStorage.getInstance();
  runApp(ReduxApp(
    store: Store<AppState>(
      appReducer,
      initialState: AppState(),
      middleware: [...createStoreMiddleware(), middleware],
    ),
  ));
}
