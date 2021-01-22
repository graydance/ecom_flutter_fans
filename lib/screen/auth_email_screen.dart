import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:fans/models/models.dart';
import 'package:fans/screen/components/auth_hero_logo.dart';
import 'package:fans/screen/components/default_button.dart';
import 'package:fans/store/actions.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../r.g.dart';

class AuthEmailScreen extends StatefulWidget {
  AuthEmailScreen({Key key}) : super(key: key);

  @override
  _AuthEmailScreenState createState() => _AuthEmailScreenState();
}

class _AuthEmailScreenState extends State<AuthEmailScreen> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
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

  final _controller = TextEditingController();

  _buildBody(_ViewModel model) {
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
              AuthHeroLogo(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              _buildTextField(model),
              SizedBox(height: 40),
              DefaultButton(
                text: "Log in/Sign up".toUpperCase(),
                press: model.isLoading
                    ? null
                    : () {
                        if (model.error.isEmpty &&
                            _controller.text.isNotEmpty) {
                          model.onCheckEmail(_controller.text);
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
    var color = model.error.isEmpty ? Colors.white : Colors.redAccent;
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
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
            model.error,
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
  final Function(String) onClientCheckEmail;
  final Function(String) onCheckEmail;

  _ViewModel({
    this.isLoading,
    this.error,
    this.onClientCheckEmail,
    this.onCheckEmail,
  });
  static _ViewModel fromStore(Store<AppState> store) {
    _onClientCheckEmail(String email) {
      store.dispatch(LocalVerifyEmailAction(email));
    }

    _onCheckEmail(String email) {
      store.dispatch(VerifyEmailAction(email));
    }

    return _ViewModel(
      isLoading: store.state.verifyEmail.isLoading,
      error: store.state.verifyEmail.error,
      onClientCheckEmail: _onClientCheckEmail,
      onCheckEmail: _onCheckEmail,
    );
  }
}
