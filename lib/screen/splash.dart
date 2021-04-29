import 'package:fans/app.dart';
import 'package:fans/event/app_event.dart';
import 'package:fans/screen/components/default_button.dart';
import 'package:fans/screen/shop/shop_screen.dart';
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
            mainAxisSize: MainAxisSize.min,
            children: [
              AuthHeroLogo(),
              FutureBuilder(
                future: AuthStorage.getString('lastUser'),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  final userName = snapshot.data;
                  if (userName != null && userName.isNotEmpty) {
                    AppEvent.shared.report(event: AnalyticsEvent.splash);
                    return Padding(
                      padding: const EdgeInsets.only(
                        top: 60.0,
                        left: 40,
                        right: 40,
                      ),
                      child: FansButton(
                        onPressed: () {
                          Keys.navigatorKey.currentState
                              .pushReplacementNamed('${Routes.shop}/$userName');
                        },
                        title: 'Continue shopping',
                      ),
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
            image: R.image.splash_background(),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
