import 'package:fans/screen/auth/components/body.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fans/models/models.dart';
import 'package:redux/redux.dart';

class AuthEmailScreen extends StatefulWidget {
  AuthEmailScreen({Key key}) : super(key: key);

  @override
  _AuthEmailScreenState createState() => _AuthEmailScreenState();
}

class _AuthEmailScreenState extends State<AuthEmailScreen> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (ctx, model) => Scaffold(
        body: Body(),
      ),
    );
  }
}

class _ViewModel {
  final bool loading;
  final String error;
  _ViewModel(this.loading, this.error);
  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(store.state.isLoading, store.state.hotLoadError);
  }
}
