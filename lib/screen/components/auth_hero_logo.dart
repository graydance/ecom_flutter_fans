import 'package:flutter/cupertino.dart';

class AuthHeroLogo extends StatelessWidget {
  const AuthHeroLogo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Hero(
        tag: 'hero_logo',
        child: Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                image: AssetImage('assets/images/logo.png'), fit: BoxFit.fill),
          ),
        ),
      ),
    );
  }
}
