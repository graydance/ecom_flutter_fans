import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:fans/models/models.dart';
import 'package:fans/screen/components/auth_hero_logo.dart';
import 'package:fans/screen/components/default_button.dart';
import 'package:fans/screen/size_config.dart';
import 'package:fans/store/actions.dart';

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

  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  _buildBody(_ViewModel model) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/auth_background.png'),
            fit: BoxFit.cover),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.15),
              AuthHeroLogo(),
              SizedBox(
                height: 40,
              ),
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    _buildFormField(model),
                    SizedBox(height: 40),
                    DefaultButton(
                      text: "Log in/Sign up".toUpperCase(),
                      press: () {
                        if (model.error == null) {
                          model.onCheckEmail(_controller.text);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _buildFormField(_ViewModel model) {
    return TextFormField(
      controller: _controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) => model.error,
      onChanged: (value) => model.onClientCheckEmail(_controller.text),
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(
        color: Colors.white,
      ),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: "Enter your email",
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
      ),
    );
  }
}

class _ViewModel {
  final bool loading;
  final String error;
  final Function(String) onClientCheckEmail;
  final Function(String) onCheckEmail;

  _ViewModel(
      this.loading, this.error, this.onClientCheckEmail, this.onCheckEmail);
  static _ViewModel fromStore(Store<AppState> store) {
    _onClientCheckEmail(String email) {
      store.dispatch(ClientCheckEmailAction(email));
    }

    _onCheckEmail(String email) {
      store.dispatch(CheckEmailAction(email));
    }

    return _ViewModel(store.state.isLoading, store.state.emailCheckError,
        _onClientCheckEmail, _onCheckEmail);
  }
}
