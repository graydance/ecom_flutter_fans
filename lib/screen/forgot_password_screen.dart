import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:fans/models/appstate.dart';
import 'package:fans/screen/components/default_button.dart';
import 'package:fans/store/actions.dart';

import '../r.g.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen({Key key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController _controller;

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
      onInit: (store) => _controller =
          TextEditingController(text: store.state.verifyEmail.email),
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
              Text("Forgot password".toUpperCase(), style: headingStyle),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Text(
                "Don't worry, it happens to all of us.\n\nEnter your email and we'll send you a link to reset your paasword.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              _buildTextField(model),
              SizedBox(height: 40),
              DefaultButton(
                text: "Send email".toUpperCase(),
                press: () {
                  if (model.error.isEmpty && _controller.text.isNotEmpty) {
                    model.onSend(_controller.text);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildTextField(_ViewModel model) {
    var color = model.error == null || model.error.isEmpty
        ? Colors.white
        : Colors.redAccent;
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: new InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding:
                  EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
              hintText: "Enter your email",
              hintStyle: TextStyle(color: Colors.white)),
          keyboardType: TextInputType.emailAddress,
          textAlign: TextAlign.center,
          onChanged: (value) => model.onClientCheckEmail(value),
          style: TextStyle(color: color),
        ),
        Container(
          height: 2,
          color: color,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            model.error ?? '',
            style: TextStyle(color: Colors.white, fontSize: 12),
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
  final Function(String) onSend;
  final Function(String) onClientCheckEmail;

  _ViewModel(this.isLoading, this.error, this.email, this.onSend,
      this.onClientCheckEmail);
  static _ViewModel fromStore(Store<AppState> store) {
    _onSend(String email) {
      store.dispatch(SendEmailAction(email));
    }

    _onCheck(String email) {
      store.dispatch(LocalVerifyEmailAction(email));
    }

    return _ViewModel(store.state.auth.isLoading, store.state.auth.error,
        store.state.verifyEmail.email, _onSend, _onCheck);
  }
}
