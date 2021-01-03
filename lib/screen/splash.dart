import 'dart:async';

import 'package:fans/screen/components/auth_hero_logo.dart';
import 'package:fans/screen/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 3),
        () => Navigator.of(context).pushReplacementNamed('/welcome'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return CupertinoPageScaffold(
      child: Container(
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
