import 'package:fans/models/appstate.dart';
import 'package:fans/store/actions.dart';
import 'package:fans/store/reducers/appreducers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:redux/redux.dart';

void main() {
  test('local check email action test', () {
    var store = Store<AppState>(
      appReducer,
      initialState: AppState.loading(),
    );

    store.dispatch(LocalCheckEmailAction('123'));

    expect(store.state.emailCheckError, 'The email is invalid');

    var email = 'test@mail.com';
    store.dispatch(LocalCheckEmailAction(email));

    expect(store.state.emailCheckError, null);
    expect(store.state.email, email);
  });

  test('check password action test', () {
    var store = Store<AppState>(
      appReducer,
      initialState: AppState.loading(),
    );

    store.dispatch(CheckPasswordAction('123'));

    expect(
        store.state.passwordCheckError, 'Make sure it’s at least 8 characters');

    var password = '12345678';
    store.dispatch(CheckPasswordAction(password));

    expect(store.state.passwordCheckError, null);
  });
}
