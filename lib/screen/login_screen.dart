import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:fans/models/appstate.dart';
import 'package:fans/r.g.dart';
import 'package:fans/screen/components/default_button.dart';
import 'package:fans/store/actions.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      onDidChange: (viewModel) {
        if (viewModel.isLoading) {
          EasyLoading.show();
        } else {
          EasyLoading.dismiss();
        }
      },
      builder: (ctx, model) => Scaffold(
        body: GestureDetector(
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildBody(_ViewModel model) {
    final headingStyle = TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      height: 1.5,
    );

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: R.image.auth_background(),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
              ),
              Text("Log in".toUpperCase(), style: headingStyle),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Text(
                model.email,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 26),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              _buildTextField(model),
              SizedBox(height: 40),
              GestureDetector(
                onTap: () => Navigator.of(context).pushNamed('/forgotpwd'),
                child: Text(
                  "Forgot Password",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              DefaultButton(
                text: "login in".toUpperCase(),
                press: () {
                  model.onLogin(_controller.text);
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
    var color = model.error.isEmpty ? Colors.white : Colors.redAccent;
    return Column(
      children: [
        TextFormField(
          controller: _controller,
          obscureText: _obscureText,
          decoration: InputDecoration(
            hintText: "Enter your password",
            hintStyle: TextStyle(color: Colors.white),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: color),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: color),
            ),
            suffix: InkWell(
              onTap: _toggle,
              child: Image(
                image: _obscureText
                    ? R.image.eyes_visibility_off()
                    : R.image.eyes_visibility(),
              ),
            ),
            prefix: SizedBox(
              width: 22,
            ),
          ),
          keyboardType: TextInputType.text,
          textAlign: TextAlign.center,
          onChanged: (value) => model.onCheck(value),
          style: TextStyle(color: color),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          model.error,
          style: TextStyle(
            color: color,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _ViewModel {
  final bool isLoading;
  final String error;
  final String email;
  final Function(String) onLogin;
  final Function(String) onCheck;

  _ViewModel(
      this.isLoading, this.error, this.email, this.onLogin, this.onCheck);
  static _ViewModel fromStore(Store<AppState> store) {
    _onLogin(String password) {
      store.dispatch(LoginAction(store.state.verifyEmail.email, password));
    }

    _onCheck(String password) {
      store.dispatch(CheckPasswordAction(password));
    }

    return _ViewModel(store.state.auth.isLoading, store.state.auth.error,
        store.state.verifyEmail.email, _onLogin, _onCheck);
  }
}
