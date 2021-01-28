import 'dart:async';

import 'package:fans/app.dart';
import 'package:fans/r.g.dart';
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
    var token = AuthStorage.getToken() ?? '';
    var root = token.isEmpty ? Routes.welcome : Routes.home;

    Timer(Duration(seconds: 1),
        () => Keys.navigatorKey.currentState.pushReplacementNamed(root));

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
            image: R.image.auth_background(),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
