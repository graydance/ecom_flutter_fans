import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:fans/models/models.dart';
import 'package:fans/screen/components/auth_hero_logo.dart';
import 'package:fans/screen/components/default_button.dart';
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
        child: Column(
          children: [
            Flexible(
              child: FractionallySizedBox(
                heightFactor: 0.8,
              ),
            ),
            Flexible(
              child: AuthHeroLogo(),
            ),
            Flexible(
              child: FractionallySizedBox(
                heightFactor: 0.15,
              ),
            ),
            Flexible(
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    // _buildFormField(model),
                    _buildTextField(model),
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
            ),
          ],
        ),
      ),
    );
  }

  _buildTextField(_ViewModel model) {
    var color = model.error == null || model.error.isEmpty
        ? CupertinoColors.white
        : CupertinoColors.destructiveRed;
    return Column(
      children: [
        CupertinoTextField(
          controller: _controller,
          placeholder: "Enter your email",
          placeholderStyle: TextStyle(color: CupertinoColors.white),
          keyboardType: TextInputType.emailAddress,
          textAlign: TextAlign.center,
          clearButtonMode: OverlayVisibilityMode.editing,
          onChanged: (value) => model.onClientCheckEmail(value),
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.0,
              color: Color(0x00FFFFFF),
            ),
          ),
          style: TextStyle(color: color),
        ),
        Divider(
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
  final Function(String) onClientCheckEmail;
  final Function(String) onCheckEmail;

  _ViewModel(
      this.loading, this.error, this.onClientCheckEmail, this.onCheckEmail);
  static _ViewModel fromStore(Store<AppState> store) {
    _onClientCheckEmail(String email) {
      store.dispatch(LocalCheckEmailAction(email));
    }

    _onCheckEmail(String email) {
      store.dispatch(RemoteCheckEmailAction(email));
    }

    return _ViewModel(store.state.isLoading, store.state.emailCheckError,
        _onClientCheckEmail, _onCheckEmail);
  }
}
