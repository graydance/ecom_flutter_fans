import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:fans/models/appstate.dart';
import 'package:fans/screen/components/default_button.dart';
import 'package:fans/store/actions.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({Key key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (ctx, model) => CupertinoPageScaffold(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            // 触摸收起键盘
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: _buildBody(model),
        ),
      ),
    );
  }

  Widget _buildBody(_ViewModel model) {
    final headingStyle = TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: CupertinoColors.white,
      height: 1.5,
    );

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/auth_background.png'),
            fit: BoxFit.cover),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            // mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
              ),
              Text("Set your password".toUpperCase(), style: headingStyle),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Text(
                model.email,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: CupertinoColors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 26),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              _buildTextField(model),
              SizedBox(height: 40),
              DefaultButton(
                text: "Sign up".toUpperCase(),
                press: () {
                  if (model.error == null) {
                    model.onSignup(_controller.text);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  final _controller = TextEditingController();
  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  _buildTextField(_ViewModel model) {
    var color = model.error == null || model.error.isEmpty
        ? CupertinoColors.white
        : CupertinoColors.destructiveRed;
    return Column(
      children: [
        CupertinoTextField(
          controller: _controller,
          obscureText: _obscureText,
          placeholder: "Enter your password",
          placeholderStyle: TextStyle(color: CupertinoColors.white),
          keyboardType: TextInputType.text,
          textAlign: TextAlign.center,
          clearButtonMode: OverlayVisibilityMode.editing,
          onChanged: (value) => model.onCheck(value),
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.0,
              color: Color(0x00FFFFFF),
            ),
          ),
          style: TextStyle(color: color),
          suffixMode: OverlayVisibilityMode.always,
          suffix: SizedBox(
            width: 50,
            child: CupertinoButton(
              onPressed: _toggle,
              child: Image(
                image: _obscureText
                    ? AssetImage('assets/images/eyes_close.png')
                    : AssetImage('assets/images/eyes_open.png'),
              ),
            ),
          ),
          prefix: SizedBox(
            width: 40,
          ),
        ),
        Container(
          height: 2,
          color: color,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            model.error ?? '',
            style: TextStyle(color: CupertinoColors.white, fontSize: 12),
          ),
        ),
      ],
    );
  }
}

class _ViewModel {
  final bool loading;
  final String error;
  final String email;
  final Function(String) onSignup;
  final Function(String) onCheck;

  _ViewModel(this.loading, this.error, this.email, this.onSignup, this.onCheck);
  static _ViewModel fromStore(Store<AppState> store) {
    _onLogin(String password) {
      store.dispatch(SignupAction(store.state.email, password));
    }

    _onCheck(String password) {
      store.dispatch(CheckPasswordAction(password));
    }

    return _ViewModel(store.state.isLoading, store.state.passwordCheckError,
        store.state.email, _onLogin, _onCheck);
  }
}