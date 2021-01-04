import 'package:fans/models/appstate.dart';
import 'package:fans/screen/components/default_button.dart';
import 'package:fans/screen/size_config.dart';
import 'package:fans/store/actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

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

  Widget _buildBody(_ViewModel model) {
    final headingStyle = TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      height: 1.5,
    );

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/auth_background.png'),
            fit: BoxFit.cover),
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(children: [
              SingleChildScrollView(
                child: Column(
                  // mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(height: SizeConfig.screenHeight * 0.08), // 4%
                    Text("Log in".toUpperCase(), style: headingStyle),
                    SizedBox(height: SizeConfig.screenHeight * 0.06),
                    Text(
                      model.email,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 26),
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.02),
                    _buildForm(model),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  _buildForm(_ViewModel model) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          _buildPasswordFormField(model),
          SizedBox(height: 40),
          GestureDetector(
            onTap: () => Navigator.of(context).pushNamed('/forgotpwd'),
            child: Text(
              "Forgot Password",
              style: TextStyle(
                  decoration: TextDecoration.underline, color: Colors.white),
            ),
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.02),
          DefaultButton(
            text: "login in".toUpperCase(),
            press: () {
              if (model.error == null) {
                model.onLogin(_controller.text);
              }
            },
          ),
        ],
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  TextFormField _buildPasswordFormField(_ViewModel model) {
    return TextFormField(
      obscureText: _obscureText,
      controller: _controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) => model.error,
      onChanged: (value) => model.onCheck(value),
      style: TextStyle(
        color: Colors.white,
      ),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: "Enter your password",
        hintStyle: TextStyle(
          color: Colors.white,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.never,
        prefix: SizedBox(
          width: 40,
        ),
        suffixIcon: SizedBox(
          width: 40,
          child: FlatButton(
            child: Image(
              image: _obscureText
                  ? AssetImage('assets/images/eyes_close.png')
                  : AssetImage('assets/images/eyes_open.png'),
              // width: 22,
              height: 22,
            ),
            onPressed: _toggle,
          ),
        ),
      ),
    );
  }
}

class _ViewModel {
  final bool loading;
  final String error;
  final String email;
  final Function(String) onLogin;
  final Function(String) onCheck;

  _ViewModel(this.loading, this.error, this.email, this.onLogin, this.onCheck);
  static _ViewModel fromStore(Store<AppState> store) {
    _onLogin(String password) {
      store.dispatch(LoginAction(store.state.email, password));
    }

    _onCheck(String password) {
      store.dispatch(CheckPasswordAction(password));
    }

    return _ViewModel(store.state.isLoading, store.state.error,
        store.state.email, _onLogin, _onCheck);
  }
}
