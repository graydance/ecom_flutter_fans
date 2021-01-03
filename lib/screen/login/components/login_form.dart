import 'package:fans/screen/components/default_button.dart';
import 'package:fans/screen/size_config.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  LoginForm({Key key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  bool _obscureText = true;
  String _password;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          _buildPasswordFormField(),
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
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                // if all are valid then go to success screen
                Navigator.pushNamed(context, '/');
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField _buildPasswordFormField() {
    return TextFormField(
      obscureText: _obscureText,
      onSaved: (newValue) => _password = newValue,
      validator: (value) {
        if (value.isEmpty) {
          return "Password is empty";
        }
        return null;
      },
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
