import 'package:fans/r.g.dart';
import 'package:flutter/material.dart';

class AuthHeroLogo extends StatelessWidget {
  const AuthHeroLogo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Hero(
        tag: 'hero_logo',
        child: CircleAvatar(
          radius: 80,
          backgroundImage: R.image.logo(),
        ),
      ),
    );
  }
}
