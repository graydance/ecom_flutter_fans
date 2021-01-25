import 'package:flutter/material.dart';

import 'package:fans/r.g.dart';
import 'package:fans/screen/home/home_screen.dart';
import 'package:fans/screen/screens.dart';

class TabbarScreen extends StatefulWidget {
  final void Function() onInit;
  TabbarScreen({this.onInit});
  @override
  State<StatefulWidget> createState() {
    return TabbarScreenState();
  }
}

class TabbarScreenState extends State<TabbarScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    if (widget.onInit != null) widget.onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBottomTabBar();
  }

  var _pages = [
    HomeScreen(),
    WelcomeScreen(),
    WelcomeScreen(),
    WelcomeScreen(),
  ];

  _buildBottomTabBar() {
    return Scaffold(
      body: SafeArea(child: _pages[_selectedIndex]),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                offset: Offset(0, -2.0),
                color: Color(0x1A777777),
                blurRadius: 1.0,
                spreadRadius: 1.0),
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Image(image: R.image.tabbar_home_normal()),
              activeIcon: Image(image: R.image.tabbar_home_highlight()),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Image(image: R.image.tabbar_search_normal()),
              activeIcon: Image(image: R.image.tabbar_search_highlight()),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Image(image: R.image.tabbar_inbox_normal()),
              activeIcon: Image(image: R.image.tabbar_inbox_hightlight()),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Image(image: R.image.tabbar_profile_normal()),
              activeIcon: Image(image: R.image.tabbar_profile_hightlight()),
              label: '',
            ),
          ],
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
        ),
      ),
    );
  }
}
