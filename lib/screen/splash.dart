import 'package:fans/app.dart';
import 'package:fans/storage/auth_storage.dart';
import 'package:flutter/material.dart';

import 'package:fans/r.g.dart';
import 'package:fans/screen/components/auth_hero_logo.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() async {
    super.initState();

    final String userName = await AuthStorage.getString('lastUser');
    if (userName != null && userName.isNotEmpty) {
      Future.delayed(Duration(milliseconds: 200)).then((value) => Keys
          .navigatorKey.currentState
          .pushReplacementNamed('${Routes.shop}/$userName'));
    }
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
