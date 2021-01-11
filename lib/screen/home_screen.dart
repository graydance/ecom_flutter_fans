import 'package:flutter/material.dart';

import 'package:fans/screen/screens.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  final List<String> _tabValues = ['Following', 'For you'];

  @override
  void initState() {
    _tabController = TabController(
      length: _tabValues.length,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle selectedStyle = new TextStyle(
      color: Color(0xff0F1015),
      fontSize: 16.0,
    );
    TextStyle normalStyle = new TextStyle(
      color: Color(0xff979AA9),
      fontSize: 16.0,
    );
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: SizedBox(
            height: 24,
            child: TabBar(
              tabs: _tabValues.map((title) {
                return Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                );
              }).toList(),
              isScrollable: true,
              controller: _tabController,
              indicatorColor: Color(0xffFEAC1B),
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: selectedStyle,
              unselectedLabelStyle: normalStyle,
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              FeedListScreen(),
              FeedListScreen(
                showTop: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
