import 'package:fans/app.dart';
import 'package:fans/screen/components/default_button.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            children: [
              AuthHeroLogo(),
              FutureBuilder(
                future: AuthStorage.getString('lastUser'),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.hasData) {
                    final userName = snapshot.data;
                    return FansButton(
                      onPressed: () {
                        if (userName != null && userName.isNotEmpty) {
                          Keys.navigatorKey.currentState
                              .pushReplacementNamed('${Routes.shop}/$userName');
                        }
                      },
                      title: 'Continue shopping',
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
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
