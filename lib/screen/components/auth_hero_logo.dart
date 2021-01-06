import 'package:flutter/cupertino.dart';

class AuthHeroLogo extends StatelessWidget {
  const AuthHeroLogo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Hero(
        tag: 'hero_logo',
        child: Container(
          constraints: BoxConstraints(
              minHeight: 50, minWidth: 50, maxHeight: 160, maxWidth: 160),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                image: AssetImage('assets/images/logo.png'),
                fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
