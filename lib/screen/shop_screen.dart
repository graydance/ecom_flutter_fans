import 'package:fans/store/actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:redux/redux.dart';

import 'package:fans/models/models.dart';
import 'package:fans/r.g.dart';
import 'package:fans/screen/components/avatar_widget.dart';
import 'package:fans/screen/components/follow_button.dart';
import 'package:fans/store/states/shop_detail_state.dart';

class ShopDetailScreen extends StatefulWidget {
  ShopDetailScreen({Key key}) : super(key: key);

  @override
  _ShopDetailScreenState createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends State<ShopDetailScreen>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 2, vsync: this)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (ctx, model) => Scaffold(
        body: NestedScrollView(
          physics: BouncingScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverSafeArea(
                  top: false,
                  bottom: false,
                  sliver: SliverPersistentHeader(
                    pinned: true,
                    delegate: SliverCustomHeaderDelegate(
                      title: '',
                      collapsedHeight: 40,
                      expandedHeight: 330,
                      paddingTop: MediaQuery.of(context).padding.top,
                      coverImage: R.image.kol_detail_bg(),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              children: [
                TabBar(
                  controller: _controller,
                  indicatorColor: Color(0xff1E2539),
                  labelColor: Color(0xff1E2539),
                  unselectedLabelColor: Colors.white,
                  tabs: [
                    Tab(
                      icon: Image(
                          image: _controller.index == 0
                              ? R.image.kol_tab_photos()
                              : R.image.kol_tab_photos_unselected()),
                    ),
                    Tab(
                      icon: Image(
                          image: _controller.index == 1
                              ? R.image.kol_tab_album()
                              : R.image.kol_tab_album_unselected()),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white),
                    child: TabBarView(
                      controller: _controller,
                      children: [
                        PhotoListView(),
                        AlbumListView(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final _testLinks = [
  'https://images.pexels.com/photos/4409307/pexels-photo-4409307.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
  'https://images.pexels.com/photos/2351274/pexels-photo-2351274.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
  'https://images.pexels.com/photos/3607084/pexels-photo-3607084.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
  'https://images.pexels.com/photos/4409307/pexels-photo-4409307.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
  'https://images.pexels.com/photos/2351274/pexels-photo-2351274.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
  'https://images.pexels.com/photos/3607084/pexels-photo-3607084.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
  'https://images.pexels.com/photos/4409307/pexels-photo-4409307.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
  'https://images.pexels.com/photos/2351274/pexels-photo-2351274.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
  'https://images.pexels.com/photos/3607084/pexels-photo-3607084.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
  'https://images.pexels.com/photos/4409307/pexels-photo-4409307.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
  'https://images.pexels.com/photos/2351274/pexels-photo-2351274.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
  'https://images.pexels.com/photos/3607084/pexels-photo-3607084.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
  'https://images.pexels.com/photos/4409307/pexels-photo-4409307.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
  'https://images.pexels.com/photos/2351274/pexels-photo-2351274.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
  'https://images.pexels.com/photos/3607084/pexels-photo-3607084.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
  'https://images.pexels.com/photos/4409307/pexels-photo-4409307.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
  'https://images.pexels.com/photos/2351274/pexels-photo-2351274.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
  'https://images.pexels.com/photos/3607084/pexels-photo-3607084.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
  'https://images.pexels.com/photos/4409307/pexels-photo-4409307.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
  'https://images.pexels.com/photos/2351274/pexels-photo-2351274.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
  'https://images.pexels.com/photos/3607084/pexels-photo-3607084.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
  'https://images.pexels.com/photos/4409307/pexels-photo-4409307.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
  'https://images.pexels.com/photos/2351274/pexels-photo-2351274.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
  'https://images.pexels.com/photos/3607084/pexels-photo-3607084.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
  'https://images.pexels.com/photos/4409307/pexels-photo-4409307.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
  'https://images.pexels.com/photos/2351274/pexels-photo-2351274.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
];

class PhotoListView extends StatefulWidget {
  PhotoListView({Key key}) : super(key: key);

  @override
  _PhotoListViewState createState() => _PhotoListViewState();
}

class _PhotoListViewState extends State<PhotoListView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: GridView.count(
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          crossAxisCount: 3,
          padding: const EdgeInsets.only(top: 20),
          children: _buildList(),
        ),
      ),
    );
  }

  _buildList() {
    return _testLinks.map((url) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(4.0),
        child: FadeInImage(
          placeholder: R.image.kol_album_bg(),
          image: NetworkImage(url),
          fit: BoxFit.cover,
        ),
      );
    }).toList();
  }
}

class AlbumListView extends StatefulWidget {
  AlbumListView({Key key}) : super(key: key);

  @override
  _AlbumListViewState createState() => _AlbumListViewState();
}

class _AlbumListViewState extends State<AlbumListView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: GridView.count(
          padding: const EdgeInsets.only(top: 20),
          mainAxisSpacing: 20,
          crossAxisSpacing: 8,
          crossAxisCount: 2,
          children: _buildList(),
        ),
      ),
    );
  }

  _buildList() {
    return _testLinks.map((url) {
      return Column(
        children: [
          Center(
            child: SizedBox(
              height: 152,
              width: 152,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    right: 0,
                    height: 144,
                    width: 144,
                    child: Image(
                      image: R.image.kol_album_bg(),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    bottom: 0,
                    height: 144,
                    width: 144,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.0),
                      child: Image.network(
                        url,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            '#tag',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xff0F1015),
            ),
          ),
        ],
      );
    }).toList();
  }
}

class SliverCustomHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double collapsedHeight;
  final double expandedHeight;
  final double paddingTop;
  final AssetImage coverImage;
  final String title;
  String statusBarMode = 'dark';

  SliverCustomHeaderDelegate({
    this.collapsedHeight,
    this.expandedHeight,
    this.paddingTop,
    this.coverImage,
    this.title,
  });

  @override
  double get minExtent => this.collapsedHeight + this.paddingTop;

  @override
  double get maxExtent => this.expandedHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  void updateStatusBarBrightness(shrinkOffset) {
    if (shrinkOffset > 50 && this.statusBarMode == 'dark') {
      this.statusBarMode = 'light';
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ));
    } else if (shrinkOffset <= 50 && this.statusBarMode == 'light') {
      this.statusBarMode = 'dark';
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ));
    }
  }

  Color makeStickyHeaderBgColor(shrinkOffset) {
    final int alpha = (shrinkOffset / (this.maxExtent - this.minExtent) * 255)
        .clamp(0, 255)
        .toInt();
    return Color.fromARGB(alpha, 255, 255, 255);
  }

  Color makeStickyHeaderTextColor(shrinkOffset, isIcon) {
    if (shrinkOffset <= 50) {
      return isIcon ? Colors.white : Colors.transparent;
    } else {
      final int alpha = (shrinkOffset / (this.maxExtent - this.minExtent) * 255)
          .clamp(0, 255)
          .toInt();
      return Color.fromARGB(alpha, 0, 0, 0);
    }
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    this.updateStatusBarBrightness(shrinkOffset);
    return Container(
      height: this.maxExtent,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: coverImage,
                fit: BoxFit.cover,
              ),
            ),
            // child: Image.network(this.coverImgUrl, fit: BoxFit.cover),
          ),
          Positioned(
            left: 0,
            top: this.maxExtent / 2,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x00000000),
                    Color(0x90000000),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Container(
              color: this.makeStickyHeaderBgColor(shrinkOffset),
              child: SafeArea(
                bottom: false,
                child: Container(
                  height: this.collapsedHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: this
                              .makeStickyHeaderTextColor(shrinkOffset, true),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        this.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: this
                              .makeStickyHeaderTextColor(shrinkOffset, false),
                        ),
                      ),
                      IconButton(
                        icon: Image(
                          image: R.image.kol_cart(),
                          color: this
                              .makeStickyHeaderTextColor(shrinkOffset, true),
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            child: ProfileHeader(),
            // Opacity(
            //   opacity: makeHeaderAlpha(shrinkOffset),
            //   child: ProfileHeader(),
            // ),
          ),
        ],
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AvatarWidget(),
              SizedBox(
                width: 6,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Flutter",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "@desiperkins",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      '233',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Products',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 40,
                ),
                Column(
                  children: [
                    Text(
                      '1.2k',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Followers',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.0,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                SizedBox(
                  height: 26,
                  width: 90,
                  child: FollowButton(
                    isFollowed: false,
                    userId: '',
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            "Google’s mobile app SDK for building beautiful native apps on iOS and Android in record time // For support visit http://stackoverflow.com/tags/flutter",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.0,
            ),
            maxLines: 4,
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

class _ViewModel {
  final ShopDetailState model;
  _ViewModel({
    this.model,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(model: store.state.shopDetail);
  }
}
