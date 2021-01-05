import 'package:fans/models/appstate.dart';
import 'package:fans/screen/components/default_button.dart';
import 'package:fans/store/actions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen({Key key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      onInit: (store) =>
          _controller = TextEditingController(text: store.state.email),
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
      color: Colors.white,
      height: 1.5,
    );

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
              child: Text("Forgot password".toUpperCase(), style: headingStyle),
            ),
            Flexible(
              child: FractionallySizedBox(
                heightFactor: 0.15,
              ),
            ),
            Flexible(
              child: Text(
                "Don't worry, it happens to all of us.\n\nEnter your email and we'll send you a link to reset your paasword.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            Flexible(
              child: FractionallySizedBox(
                heightFactor: 0.15,
              ),
            ),
            _buildForm(model),
          ],
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
          _buildTextField(model),
          SizedBox(height: 40),
          DefaultButton(
            text: "Send email".toUpperCase(),
            press: () {
              if (model.error == null) {
                model.onSend(_controller.text);
              }
            },
          ),
        ],
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
  final String email;
  final Function(String) onSend;
  final Function(String) onClientCheckEmail;

  _ViewModel(this.loading, this.error, this.email, this.onSend,
      this.onClientCheckEmail);
  static _ViewModel fromStore(Store<AppState> store) {
    _onSend(String email) {
      store.dispatch(SendEmailAction(email));
    }

    _onCheck(String email) {
      store.dispatch(LocalCheckEmailAction(email));
    }

    return _ViewModel(store.state.isLoading, store.state.emailCheckError,
        store.state.email, _onSend, _onCheck);
  }
}
