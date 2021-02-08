import 'dart:async';

import 'package:fans/app.dart';
import 'package:fans/screen/components/emtpy_view.dart';
import 'package:fans/store/actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;

import 'package:fans/models/models.dart';
import 'package:fans/r.g.dart';
import 'package:fans/screen/components/cart_button.dart';
import 'package:fans/theme.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:redux/redux.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopScreen extends StatefulWidget {
  final String userId;
  ShopScreen({Key key, this.userId}) : super(key: key);

  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen>
    with SingleTickerProviderStateMixin {
  final _tabs = ['Link', 'Shop'];

  TabController _tabController;
  int _tabIndex = 0;

  Feed _seller = Feed();
  List<IdolLink> _links = [];

  final _refreshLinksController = EasyRefreshController();
  final _refreshGoodsController = EasyRefreshController();
  int _page = 1;
  final _pageSize = 20;
  List<Goods> _goods = [];

  // 初始化
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _refreshLinksController.dispose();
    _refreshGoodsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) {
        return _ViewModel.fromStore(
            store, widget.userId); //ModalRoute.of(context).settings.arguments
      },
      onInitialBuild: (viewModel) async {
        _refreshLinksController.callRefresh();
        _refreshGoodsController.callRefresh();

        final completer = Completer();
        StoreProvider.of<AppState>(context).dispatch(FetchSellerInfoAction(
            userId: viewModel.userId, completer: completer));

        final Feed seller = await completer.future;
        setState(() {
          _seller = seller;
        });
      },
      builder: (ctx, viewModel) => Scaffold(
        body: extended.NestedScrollView(
          pinnedHeaderSliverHeightBuilder: () {
            return MediaQuery.of(context).padding.top + kToolbarHeight;
          },
          innerScrollPositionKeyBuilder: () {
            return Key(_tabs[_tabController.index]);
          },
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                title: Text(_seller.nickName),
                centerTitle: true,
                pinned: true,
                expandedHeight: 200.0,
                actions: [
                  CartButton(
                    count: viewModel.cartCount,
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(top: kToolbarHeight),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(80 / 2.0),
                              child: FadeInImage(
                                width: 80,
                                height: 80,
                                placeholder: R.image.avatar_placeholder(),
                                image: NetworkImage(_seller.portrait),
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              '@${_seller.nickName}',
                              style: TextStyle(
                                color: AppTheme.color555764,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: Column(
            children: [
              PreferredSize(
                child: Card(
                  color: Theme.of(context).primaryColor,
                  elevation: 0.0,
                  margin: EdgeInsets.all(0.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0.0)),
                  ),
                  child: TabBar(
                    indicatorColor: Color(0xff1E2539),
                    labelColor: Color(0xff1E2539),
                    controller: _tabController,
                    onTap: (index) {
                      setState(() {
                        _tabIndex = index;
                      });
                    },
                    tabs: _tabs
                        .map((e) => Tab(
                              text: e,
                            ))
                        .toList(),
                  ),
                ),
                preferredSize: Size(double.infinity, 46.0),
              ),
              Expanded(
                child: IndexedStack(
                  index: _tabIndex,
                  children: [
                    extended.NestedScrollViewInnerScrollPositionKeyWidget(
                      Key(_tabs[_tabIndex]),
                      EasyRefresh(
                        child: ListView.builder(
                          itemExtent: 68,
                          padding: EdgeInsets.all(0.0),
                          itemBuilder: (context, index) {
                            final model = _links[index];
                            return GestureDetector(
                              onTap: () async {
                                final url = model.linkUrl;
                                if (await canLaunch(url)) {
                                  await launch(url);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                                child: Card(
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 8,
                                      ),
                                      FadeInImage(
                                        height: 56,
                                        width: 56,
                                        placeholder: R.image.kol_album_bg(),
                                        image: NetworkImage(model.linkIcon),
                                      ),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Text(
                                        model.linkName,
                                        style: TextStyle(
                                          color: AppTheme.color0F1015,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          itemCount: _links.length,
                        ),
                        enableControlFinishRefresh: true,
                        controller: _refreshLinksController,
                        onRefresh: () async {
                          final action = FetchIdolLinksAction(
                              userId: viewModel.userId, completer: Completer());
                          StoreProvider.of<AppState>(context).dispatch(action);

                          try {
                            final links = await action.completer.future;
                            setState(() {
                              _links = links;
                            });
                            _refreshLinksController.finishRefresh();
                          } catch (error) {
                            _refreshLinksController.finishRefresh(
                                success: false);
                          }
                        },
                        emptyWidget: _links.isEmpty ? EmptyView() : null,
                      ),
                    ),
                    extended.NestedScrollViewInnerScrollPositionKeyWidget(
                      Key(_tabs[_tabIndex]),
                      EasyRefresh(
                        enableControlFinishRefresh: true,
                        enableControlFinishLoad: true,
                        controller: _refreshGoodsController,
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 6 / 7,
                          ),
                          itemBuilder: (context, index) {
                            final model = _goods[index];
                            return GestureDetector(
                              onTap: () {
                                StoreProvider.of<AppState>(context).dispatch(
                                    ShowProductDetailAction(model.idolGoodsId));
                                Keys.navigatorKey.currentState
                                    .pushNamed(Routes.productDetail);
                              },
                              child: Card(
                                child: Column(
                                  children: [
                                    FadeInImage(
                                      placeholder: R.image.kol_album_bg(),
                                      image: NetworkImage(model.picture),
                                    ),
                                    // Text('$index')
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount: _goods.length,
                        ),
                        onRefresh: () async {
                          final action = FetchIdolGoodsAction(
                              userId: viewModel.userId,
                              page: 1,
                              limit: _pageSize,
                              completer: Completer());
                          StoreProvider.of<AppState>(context).dispatch(action);

                          try {
                            final response = await action.completer.future;
                            final totalPage = response['totalPage'];
                            final currentPage = response['currentPage'];
                            final list = response['list'] as List;
                            List<Goods> models =
                                list.map((e) => Goods.fromMap(e)).toList();

                            _page = 1;
                            setState(() {
                              _goods = models;
                            });

                            final isNoMore = currentPage == totalPage;
                            _refreshGoodsController.finishRefresh(
                                noMore: isNoMore);
                            _refreshGoodsController.resetRefreshState();
                          } catch (error) {
                            _refreshGoodsController.finishRefresh(
                                success: false);
                          }
                        },
                        onLoad: _goods.isEmpty
                            ? null
                            : () async {
                                final action = FetchIdolGoodsAction(
                                    userId: viewModel.userId,
                                    page: _page + 1,
                                    limit: _pageSize,
                                    completer: Completer());
                                StoreProvider.of<AppState>(context)
                                    .dispatch(action);

                                try {
                                  final response =
                                      await action.completer.future;
                                  final totalPage = response['totalPage'];
                                  final currentPage = response['currentPage'];
                                  final list = response['list'] as List;
                                  List<Goods> models = list
                                      .map((e) => Goods.fromMap(e))
                                      .toList();

                                  _page += 1;
                                  setState(() {
                                    _goods.addAll(models);
                                  });

                                  final isNoMore = currentPage == totalPage;
                                  _refreshGoodsController.finishLoad(
                                      noMore: isNoMore);
                                } catch (error) {
                                  _refreshGoodsController.finishLoad(
                                      success: false);
                                }
                              },
                        emptyWidget: _goods.isEmpty ? EmptyView() : null,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ViewModel {
  final int cartCount;
  final String userId;

  _ViewModel(this.userId, this.cartCount);

  static _ViewModel fromStore(Store<AppState> store, String userId) {
    return _ViewModel(userId, store.state.cart.list.length);
  }
}
