import 'dart:async';

import 'package:fans/app.dart';
import 'package:fans/models/models.dart';
import 'package:fans/r.g.dart';
import 'package:fans/store/actions.dart';
import 'package:fans/theme.dart';
import 'package:fans/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({Key key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwrodController = TextEditingController();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (ctx, model) => Scaffold(
        appBar: AppBar(
          title: Text('Sign In'),
          centerTitle: true,
          elevation: 0,
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            // 触摸收起键盘
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppTheme.color0F1015),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppTheme.color0F1015),
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppTheme.color0F1015),
                        ),
                        contentPadding: EdgeInsets.only(
                            left: 15, bottom: 11, top: 11, right: 15),
                        hintText: "Enter your email",
                        // hintStyle: TextStyle(color: Colors.white),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      validator: (value) => validateEmail(value) ? null : '',
                      // style: TextStyle(color: color),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _passwrodController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        hintText: "Enter your password",
                        // hintStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppTheme.color0F1015),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppTheme.color0F1015),
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppTheme.color0F1015),
                        ),
                        suffix: InkWell(
                          onTap: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
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
                      validator: (value) => validatePassowrd(value) ? null : '',
                      // style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    TextButton(
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());

                        EasyLoading.show();
                        final action = SignInAction(_emailController.text,
                            _passwrodController.text, Completer());

                        action.completer.future.then((value) {
                          EasyLoading.dismiss();
                          Keys.navigatorKey.currentState.pop();
                        }).catchError((error) {
                          EasyLoading.dismiss();
                          EasyLoading.showToast(error.toString());
                        });
                        StoreProvider.of<AppState>(context).dispatch(action);
                      },
                      child: Text(
                        'Sign in',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: TextButton.styleFrom(
                          minimumSize: Size(44, 44),
                          backgroundColor: AppTheme.colorED8514),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ViewModel {
  final Function(String, String) onLogin;

  _ViewModel(this.onLogin);
  static _ViewModel fromStore(Store<AppState> store) {
    _onLogin(String email, String password) {
      store.dispatch(LoginAction(email, password));
    }

    return _ViewModel(_onLogin);
  }
}
