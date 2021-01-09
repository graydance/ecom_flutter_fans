import 'package:flutter/cupertino.dart';
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
            image: AssetImage('assets/images/auth_background.png'),
            fit: BoxFit.cover),
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
                press: () {
                  if (model.error.isEmpty && _controller.text.isNotEmpty) {
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
    var color = model.error.isEmpty
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
        Container(
          height: 2,
          color: color,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            model.error,
            style: TextStyle(color: CupertinoColors.white, fontSize: 12),
          ),
        ),
      ],
    );
  }
}

class _ViewModel {
  final String error;
  final Function(String) onClientCheckEmail;
  final Function(String) onCheckEmail;

  _ViewModel(this.error, this.onClientCheckEmail, this.onCheckEmail);
  static _ViewModel fromStore(Store<AppState> store) {
    _onClientCheckEmail(String email) {
      store.dispatch(LocalVerifyEmailAction(email));
    }

    _onCheckEmail(String email) {
      store.dispatch(VerifyEmailAction(email));
    }

    return _ViewModel(
        store.state.verifyEmail.error, _onClientCheckEmail, _onCheckEmail);
  }
}
