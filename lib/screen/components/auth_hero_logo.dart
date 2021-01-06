import 'package:flutter/cupertino.dart';

class AuthHeroLogo extends StatelessWidget {
  const AuthHeroLogo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Hero(
        tag: 'hero_logo',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(160 / 2),
          child: Image(
            image: AssetImage('assets/images/logo.png'),
            height: 160,
            width: 160,
          ),
        ),
      ),
    );
  }
}
