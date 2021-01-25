import 'dart:async';

import 'package:fans/screen/components/emtpy_view.dart';
import 'package:fans/store/actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:fans/models/models.dart';
import 'package:fans/r.g.dart';
import 'package:fans/screen/components/avatar_widget.dart';
import 'package:fans/screen/components/follow_button.dart';
import 'package:fans/store/product/shop_detail_state.dart';

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
      onInit: (store) {
        store.dispatch(
            FetchShopDetailAction(userId: store.state.shopDetail.userId));
        store.dispatch(FetchGoodsAction(
            userId: store.state.shopDetail.userId,
            type: 0,
            page: 1,
            completer: Completer()));
        store.dispatch(FetchGoodsAction(
            userId: store.state.shopDetail.userId,
            type: 1,
            page: 1,
            completer: Completer()));
      },
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
                      collapsedHeight: 40,
                      expandedHeight: 330,
                      paddingTop: MediaQuery.of(context).padding.top,
                      coverImage: R.image.kol_detail_bg(),
                      userId: model.model.userId,
                      model: model.model.seller,
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
                        PhotoListView(
                          userId: model.model.userId,
                          model: model.model.photos,
                        ),
                        AlbumListView(
                          userId: model.model.userId,
                          model: model.model.albums,
                        ),
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

class PhotoListView extends StatefulWidget {
  final String userId;
  final ShopDetailListState model;
  PhotoListView({Key key, @required this.userId, @required this.model})
      : super(key: key);

  @override
  _PhotoListViewState createState() => _PhotoListViewState();
}

class _PhotoListViewState extends State<PhotoListView>
    with AutomaticKeepAliveClientMixin {
  final _refreshController = EasyRefreshController();

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    const pageSize = 3 * 5;
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: EasyRefresh(
          controller: _refreshController,
          enableControlFinishRefresh: true,
          enableControlFinishLoad: true,
          onRefresh: () async {
            var action = FetchGoodsAction(
              type: 0,
              page: 1,
              limit: pageSize,
              userId: widget.userId,
              completer: Completer(),
            );
            StoreProvider.of<AppState>(context).dispatch(action);
            try {
              await action.completer.future;
              _refreshController.finishRefresh();
              _refreshController.resetLoadState();
            } catch (e) {
              _refreshController.finishRefresh(success: false);
            }
          },
          onLoad: widget.model.currentPage == widget.model.totalPage
              ? null
              : () async {
                  if (widget.model.currentPage == widget.model.totalPage) {
                    _refreshController.finishLoad(noMore: true);
                    return;
                  }
                  var action = FetchGoodsAction(
                    type: 0,
                    page: widget.model.currentPage + 1,
                    limit: pageSize,
                    userId: widget.userId,
                    completer: Completer(),
                  );
                  StoreProvider.of<AppState>(context).dispatch(action);
                  try {
                    bool isNoMore = await action.completer.future;
                    _refreshController.finishLoad(
                        success: true, noMore: isNoMore);
                  } catch (e) {
                    _refreshController.finishLoad(success: false);
                  }
                },
          firstRefresh: widget.model.list.isEmpty ? true : false,
          firstRefreshWidget: Center(
            child: CircularProgressIndicator(),
          ),
          emptyWidget: widget.model.list.isEmpty ? EmptyView() : null,
          child: GridView.count(
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            crossAxisCount: 3,
            padding: const EdgeInsets.only(top: 20),
            children: widget.model.list
                .map((e) => PhotoItem(
                      key: ValueKey(e.id),
                      url: e.picture,
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class PhotoItem extends StatelessWidget {
  final String url;
  const PhotoItem({Key key, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4.0),
      child: FadeInImage(
        placeholder: R.image.kol_album_bg(),
        image: NetworkImage(url),
        fit: BoxFit.cover,
      ),
    );
  }
}

class AlbumListView extends StatefulWidget {
  final String userId;
  final ShopDetailListState model;
  AlbumListView({Key key, @required this.userId, @required this.model})
      : super(key: key);

  @override
  _AlbumListViewState createState() => _AlbumListViewState();
}

class _AlbumListViewState extends State<AlbumListView>
    with AutomaticKeepAliveClientMixin {
  final _refreshController = EasyRefreshController();

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    const pageSize = 10;
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: EasyRefresh(
          controller: _refreshController,
          enableControlFinishRefresh: true,
          enableControlFinishLoad: true,
          onRefresh: () async {
            var action = FetchGoodsAction(
              type: 1,
              page: 1,
              limit: pageSize,
              userId: widget.userId,
              completer: Completer(),
            );
            StoreProvider.of<AppState>(context).dispatch(action);
            try {
              await action.completer.future;
              _refreshController.finishRefresh();
              _refreshController.resetLoadState();
            } catch (e) {
              _refreshController.finishRefresh(success: false);
            }
          },
          onLoad: widget.model.currentPage == widget.model.totalPage
              ? null
              : () async {
                  if (widget.model.currentPage == widget.model.totalPage) {
                    _refreshController.finishLoad(noMore: true);
                    return;
                  }
                  var action = FetchGoodsAction(
                    type: 1,
                    page: widget.model.currentPage + 1,
                    limit: pageSize,
                    userId: widget.userId,
                    completer: Completer(),
                  );
                  StoreProvider.of<AppState>(context).dispatch(action);
                  try {
                    bool isNoMore = await action.completer.future;
                    _refreshController.finishLoad(
                        success: true, noMore: isNoMore);
                  } catch (e) {
                    _refreshController.finishLoad(success: false);
                  }
                },
          firstRefresh: widget.model.list.isEmpty ? true : false,
          firstRefreshWidget: Center(
            child: CircularProgressIndicator(),
          ),
          emptyWidget: widget.model.list.isEmpty ? EmptyView() : null,
          child: GridView.count(
            padding: const EdgeInsets.only(top: 20),
            mainAxisSpacing: 20,
            crossAxisSpacing: 8,
            crossAxisCount: 2,
            children: widget.model.list
                .map((e) => AlbumItem(
                      key: ValueKey(e.id),
                      url: e.picture,
                      tag: e.interestName,
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class AlbumItem extends StatelessWidget {
  final String url;
  final String tag;
  const AlbumItem({Key key, this.url, this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          tag,
          style: TextStyle(
            fontSize: 14,
            color: Color(0xff0F1015),
          ),
        ),
      ],
    );
  }
}

class SliverCustomHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double collapsedHeight;
  final double expandedHeight;
  final double paddingTop;
  final AssetImage coverImage;
  final String userId;
  final Feed model;
  String statusBarMode = 'light';

  SliverCustomHeaderDelegate({
    this.collapsedHeight,
    this.expandedHeight,
    this.paddingTop,
    this.coverImage,
    this.userId,
    this.model,
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
                        '',
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
            child: ProfileHeader(
              userId: userId,
              model: model,
            ),
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
  final String userId;
  final Feed model;

  const ProfileHeader({Key key, this.userId, this.model}) : super(key: key);

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
                    model.nickName,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    model.userName,
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
                      model.products.toString(),
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
                      model.followers.toString(),
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
                    isFollowed: model.followStatus == 1,
                    userId: userId,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            model.aboutMe,
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
