import 'package:fans/screen/forgot_password/components/forgot_password_form.dart';
import 'package:fans/screen/size_config.dart';
import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  const Body({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final headingStyle = TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      height: 1.5,
    );

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/auth_background.png'),
            fit: BoxFit.cover),
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(children: [
              SingleChildScrollView(
                child: Column(
                  // mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(height: SizeConfig.screenHeight * 0.08), // 4%
                    Text("Forgot password".toUpperCase(), style: headingStyle),
                    SizedBox(height: SizeConfig.screenHeight * 0.02),
                    Text(
                      "Don't worry, it happens to all of us.\n\nEnter your email and we'll send you a link to reset your paasword.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.04),
                    ForgotPasswordForm(),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
