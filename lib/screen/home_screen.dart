import 'package:flutter/material.dart';

import 'package:fans/screen/screens.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // TextStyle selectedStyle = new TextStyle(
    //   color: Color(0xff0F1015),
    //   fontSize: 20.0,
    // );
    // TextStyle normalStyle = new TextStyle(
    //   color: Color(0xff979AA9),
    //   fontSize: 16.0,
    // );

    return PageView(
      children: [
        FollowingFeedScreen(),
        WelcomeScreen(),
      ],
    );
  }
}
