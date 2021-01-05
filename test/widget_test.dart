import 'package:dio/dio.dart';
import 'package:fans/screen/screens.dart';
import 'package:fans/store/actions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fans/api.dart';
import 'package:fans/app.dart';
import 'package:fans/models/models.dart';
import 'package:fans/store/middleware.dart';
import 'package:fans/store/reducers/appreducers.dart';
import 'package:logging/logging.dart';
import 'package:mockito/mockito.dart';
import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';

class MockDio extends Mock implements Dio {}

void main() {
  testWidgets('auth email screen test', (WidgetTester tester) async {
    await tester.pumpWidget(StoreProvider<AppState>(
        store: Store<AppState>(
          appReducer,
          initialState: AppState(emailCheckError: 'error test'),
        ),
        child: CupertinoApp(
          home: AuthEmailScreen(),
        )));

    await tester.pumpAndSettle();

    expect(find.text('error test'), findsOneWidget);
  });

  testWidgets('login screen test', (WidgetTester tester) async {
    await tester.pumpWidget(StoreProvider<AppState>(
        store: Store<AppState>(
          appReducer,
          initialState: AppState(email: 'email@test.com', error: 'error test'),
        ),
        child: CupertinoApp(
          home: LoginScreen(),
        )));

    await tester.pumpAndSettle();

    expect(find.text('email@test.com'), findsOneWidget);
    expect(find.text('error test'), findsOneWidget);
  });

  testWidgets('signup screen test', (WidgetTester tester) async {
    await tester.pumpWidget(StoreProvider<AppState>(
        store: Store<AppState>(
          appReducer,
          initialState: AppState(email: 'email@test.com', error: 'error test'),
        ),
        child: CupertinoApp(
          home: SignupScreen(),
        )));

    await tester.pumpAndSettle();

    expect(find.text('email@test.com'), findsOneWidget);
    expect(find.text('error test'), findsOneWidget);
  });

  testWidgets('forgot password screen test', (WidgetTester tester) async {
    await tester.pumpWidget(StoreProvider<AppState>(
        store: Store<AppState>(
          appReducer,
          initialState:
              AppState(email: 'email@test.com', emailCheckError: 'error test'),
        ),
        child: CupertinoApp(
          home: ForgotPasswordScreen(),
        )));

    await tester.pumpAndSettle();

    expect(find.text('email@test.com'), findsOneWidget);
    expect(find.text('error test'), findsOneWidget);
  });

  // testWidgets('basic', (WidgetTester tester) async {
  //   var mockDio = MockDio();

  //   when(mockDio.post('https://127.0.0.1:10080/hots',
  //           data: anyNamed('data'),
  //           queryParameters: anyNamed('queryParameters'),
  //           options: anyNamed('options'),
  //           cancelToken: anyNamed('cancelToken'),
  //           onSendProgress: anyNamed('onSendProgress'),
  //           onReceiveProgress: anyNamed('onReceiveProgress')))
  //       .thenAnswer((_) async => Response(
  //           data: {"code": 100, "msg": 'error test'}, statusCode: 200));
  //   // throwOnMissingStub(mockDio);
  //   setApiIO(mockDio);

  //   final logger = new Logger('redux');
  //   logger.onRecord
  //       .where((record) => record.loggerName == logger.name)
  //       .listen((loggingMiddlewareRecord) => print(loggingMiddlewareRecord));
  //   final middleware = new LoggingMiddleware(logger: logger);

  //   await tester.pumpWidget(ReduxApp(
  //     store: Store<AppState>(
  //       appReducer,
  //       initialState: AppState.loading(),
  //       middleware: [...createStoreMiddleware(), middleware],
  //     ),
  //   ));

  //   await tester.pumpAndSettle();

  //   expect(find.text('error test'), findsOneWidget);
  // });
}
