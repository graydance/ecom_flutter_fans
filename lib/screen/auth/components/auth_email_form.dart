import 'package:fans/screen/components/default_button.dart';
import 'package:flutter/material.dart';

class AuthEmailForm extends StatefulWidget {
  AuthEmailForm({Key key}) : super(key: key);

  @override
  _AuthEmailFormState createState() => _AuthEmailFormState();
}

class _AuthEmailFormState extends State<AuthEmailForm> {
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
              text: "Log in/Sign up".toUpperCase(),
              press: () => Navigator.of(context).pushNamed('/login')
              // onPressed: () => StoreProvider.of<AppState>(context)
              // .dispatch(CheckEmailAction(_email)),
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
