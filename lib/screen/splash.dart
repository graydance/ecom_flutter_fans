import 'package:flutter/material.dart';

import 'package:fans/r.g.dart';
import 'package:fans/screen/components/auth_hero_logo.dart';

class SplashScreen extends StatelessWidget {
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
