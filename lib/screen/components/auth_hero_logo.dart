import 'package:flutter/material.dart';

class AuthHeroLogo extends StatelessWidget {
  const AuthHeroLogo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Hero(
            tag: 'hero_logo',
            child: CircleAvatar(
              radius: 78.0,
              backgroundImage: AssetImage('assets/images/logo.png'),
            )));
  }
}
