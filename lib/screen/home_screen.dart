import 'package:fans/screen/screens.dart';
import 'package:flutter/cupertino.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    TextStyle selectedStyle = new TextStyle(
      color: Color(0xff0F1015),
      fontSize: 20.0,
    );
    TextStyle normalStyle = new TextStyle(
      color: Color(0xff979AA9),
      fontSize: 16.0,
    );

    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: CupertinoColors.white,
          middle: Column(
            children: [
              CupertinoSegmentedControl(
                children: {
                  'following': Text(
                    'Following',
                    style: selectedStyle,
                  ),
                  'for you': Text(
                    'For you',
                    style: normalStyle,
                  ),
                },
                onValueChanged: (value) {},
                selectedColor: CupertinoColors.white,
                unselectedColor: CupertinoColors.white,
                borderColor: CupertinoColors.white,
                pressedColor: CupertinoColors.white,
              ),
            ],
          ),
        ),
        child: PageView(
          children: [FollowingFeedScreen(), WelcomeScreen()],
        ));
  }
}
