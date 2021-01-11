import 'dart:async';

import 'package:fans/app.dart';
import 'package:flutter/material.dart';

import 'package:fans/screen/components/auth_hero_logo.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
        Duration(seconds: 3),
        () => Keys.navigatorKey.currentState
            .pushReplacementNamed(Routes.welcome));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: AuthHeroLogo(),
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/auth_background.png'),
              fit: BoxFit.cover),
        ),
      ),
    );
  }
}
