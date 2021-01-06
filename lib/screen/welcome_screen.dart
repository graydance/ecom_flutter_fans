import 'package:fans/screen/components/default_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:fans/screen/components/auth_hero_logo.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/auth_background.png'),
              fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AuthHeroLogo(),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'SLOGAN',
                    style: TextStyle(
                        color: CupertinoColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  DefaultButton(
                    text: "Get Started!".toUpperCase(),
                    press: () => Navigator.of(context).pushNamed('/authemail'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
