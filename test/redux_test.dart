import 'package:fans/models/appstate.dart';
import 'package:fans/store/actions.dart';
import 'package:fans/store/reducers/appreducers.dart';
// import 'package:fans/store/states/verify_email_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:redux/redux.dart';

void main() {
  // test('local check email action test', () {
  //   var store = Store<AppState>(
  //     appReducer,
  //     initialState: AppState(verifyEmail: VerifyEmailState(error: '')),
  //   );

  //   // store.dispatch(LocalVerifyEmailAction('123'));

  //   expect(store.state.verifyEmail.error, '');
  //   expect(store.state.verifyEmail.email, '');
  // });

  test('check password action test', () {
    var store = Store<AppState>(
      appReducer,
      initialState: AppState.loading(),
    );

    store.dispatch(CheckPasswordAction('123'));

    expect(store.state.auth.error, 'Make sure it’s at least 8 characters');

    var password = '12345678';
    store.dispatch(CheckPasswordAction(password));

    expect(store.state.auth.error, '');
  });
}
