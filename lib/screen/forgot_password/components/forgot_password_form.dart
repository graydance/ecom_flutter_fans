import 'package:fans/screen/components/default_button.dart';
import 'package:flutter/material.dart';

class ForgotPasswordForm extends StatefulWidget {
  ForgotPasswordForm({Key key}) : super(key: key);

  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();

  String _email;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          _buildFormField(),
          SizedBox(height: 40),
          DefaultButton(
            text: "Send email".toUpperCase(),
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

  TextFormField _buildFormField() {
    return TextFormField(
      onSaved: (newValue) => _email = newValue,
      validator: (value) {
        if (value.isEmpty) {
          return "Email is empty";
        } else if (!value.contains("@")) {
          return "Email is not valid";
        }
        return null;
      },
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
