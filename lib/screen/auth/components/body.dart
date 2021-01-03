import 'package:fans/screen/auth/components/auth_email_form.dart';
import 'package:fans/screen/components/auth_hero_logo.dart';
import 'package:fans/screen/size_config.dart';
import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  const Body({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.15),
              AuthHeroLogo(),
              SizedBox(
                height: 40,
              ),
              AuthEmailForm(),
            ],
          ),
        ),
      ),
    );
  }
}
