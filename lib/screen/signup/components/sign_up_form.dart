import 'package:fans/screen/components/default_button.dart';
import 'package:flutter/material.dart';

class SignupForm extends StatefulWidget {
  SignupForm({Key key}) : super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
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
          DefaultButton(
            text: "Sign up".toUpperCase(),
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
        } else if (value.length < 8) {
          return "Password too short";
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
