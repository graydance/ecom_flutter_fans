import 'package:fans/screen/login/components/login_form.dart';
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
                    Text("SET YOUR PASSWORD", style: headingStyle),
                    SizedBox(height: SizeConfig.screenHeight * 0.06),
                    Text(
                      "test@mail.com",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 26),
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.02),
                    LoginForm(),
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
