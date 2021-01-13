import 'dart:async';

import 'package:fans/app.dart';
import 'package:fans/storage/auth_storage.dart';
import 'package:flutter/material.dart';

import 'package:fans/screen/components/auth_hero_logo.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    AuthStorage.readToken().then((token) {
      var root = token == null || token.isEmpty ? Routes.welcome : Routes.home;

      Timer(Duration(seconds: 2),
          () => Keys.navigatorKey.currentState.pushReplacementNamed(root));
    });
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
