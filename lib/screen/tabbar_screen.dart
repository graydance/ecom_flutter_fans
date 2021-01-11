import 'package:fans/screen/home_screen.dart';
import 'package:fans/screen/screens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fans/models/models.dart';
import 'package:redux/redux.dart';
import 'package:fans/r.g.dart';

class TabbarScreen extends StatefulWidget {
  final void Function() onInit;
  TabbarScreen({this.onInit});
  @override
  State<StatefulWidget> createState() {
    return TabbarScreenState();
  }
}

class TabbarScreenState extends State<TabbarScreen> {
  int selectIndex = 1;

  @override
  void initState() {
    if (widget.onInit != null) widget.onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (ctx, model) => CupertinoPageScaffold(
        child: _buildBottomTabBar(),
      ),
    );
  }

  _buildBottomTabBar() {
    return ClipRRect(
      // decoration: BoxDecoration(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      child: CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            items: [
              BottomNavigationBarItem(
                icon: Image(image: R.image.tabbar_home_normal()),
                activeIcon: Image(image: R.image.tabbar_home_highlight()),
              ),
              BottomNavigationBarItem(
                icon: Image(image: R.image.tabbar_search_normal()),
                activeIcon: Image(image: R.image.tabbar_search_highlight()),
              ),
              BottomNavigationBarItem(
                icon: Image(image: R.image.tabbar_inbox_normal()),
                activeIcon: Image(image: R.image.tabbar_inbox_hightlight()),
              ),
              BottomNavigationBarItem(
                icon: Image(image: R.image.tabbar_profile_normal()),
                activeIcon: Image(image: R.image.tabbar_profile_hightlight()),
              ),
            ],
          ),
          tabBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return HomeScreen();
            }
            return CupertinoPageScaffold(child: WelcomeScreen());
          }),
    );
  }
}

class _ViewModel {
  final bool loading;
  final String error;
  _ViewModel(this.loading, this.error);
  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(store.state.isLoading, store.state.hotLoadError);
  }
}
