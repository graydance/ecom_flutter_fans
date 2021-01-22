import 'dart:async';

import 'package:fans/app.dart';
import 'package:fans/screen/components/tag_button.dart';
import 'package:fans/store/actions.dart';
import 'package:fans/store/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:redux/redux.dart';

import 'package:fans/models/models.dart';
import 'package:fans/r.g.dart';
import 'package:fans/screen/components/avatar_widget.dart';
import 'package:fans/screen/components/follow_button.dart';
import 'package:fans/screen/components/meida_carousel_widget.dart';

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
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      distinct: true,
      onInit: (store) {
        store.dispatch(FetchRecommendSellersAction());
        store.dispatch(FetchFeedsAction(0, 1, Completer()));
        store.dispatch(FetchFeedsAction(1, 1, Completer()));
      },
      builder: (ctx, model) => Column(
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
                FeedListScreen(
                  viewModel: model.followingViewModel,
                ),
                FeedListScreen(
                  viewModel: model.foryouViewModel,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FeedListScreen extends StatefulWidget {
  final _FeedViewModel viewModel;
  final VoidCallback onInit;

  const FeedListScreen({
    Key key,
    this.viewModel,
    this.onInit,
  }) : super(key: key);

  @override
  _FeedListScreenState createState() => _FeedListScreenState();
}

class _FeedListScreenState extends State<FeedListScreen> {
  final _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    if (widget.onInit != null) widget.onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xfff8f8f8),
      child: widget.viewModel.isEmpty
          ? Center(
              child: Text('No Data'),
            )
          : SmartRefresher(
              controller: _refreshController,
              onRefresh: () async {
                var action =
                    FetchFeedsAction(widget.viewModel.type, 1, Completer());
                StoreProvider.of<AppState>(context).dispatch(action);

                StoreProvider.of<AppState>(context)
                    .dispatch(FetchRecommendSellersAction());
                try {
                  await action.completer.future;
                  _refreshController.refreshCompleted();
                } catch (e) {
                  _refreshController.refreshFailed();
                }
              },
              onLoading: () async {
                var type = widget.viewModel.type;
                var currentPage = widget.viewModel.state.currentPage;
                var action =
                    FetchFeedsAction(type, currentPage + 1, Completer());
                StoreProvider.of<AppState>(context).dispatch(action);
                try {
                  bool isNoMore = await action.completer.future;
                  if (isNoMore) {
                    _refreshController.loadNoData();
                  } else {
                    _refreshController.loadComplete();
                  }
                } catch (e) {
                  _refreshController.loadFailed();
                }
              },
              enablePullDown: true,
              enablePullUp: true,
              child: ListView.builder(
                addAutomaticKeepAlives: true,
                itemCount:
                    widget.viewModel.items.length + widget.viewModel.offset,
                itemBuilder: (ctx, i) {
                  if (i == 0 && widget.viewModel.showRecommends) {
                    // 'Start by following your favorite stores!',
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: RecommendListBar(
                          list: widget.viewModel.recommendUsers),
                    );
                  }
                  if (i == 1 && widget.viewModel.showRecommends) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                      child: Text(
                        'Recommended for you',
                        style: TextStyle(
                          color: Color(0xff0F1015),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }

                  if (widget.viewModel.items.isEmpty) {
                    return Center(
                      child: Text('Following is empty'),
                    );
                  }

                  var item =
                      widget.viewModel.items[i - widget.viewModel.offset];
                  var childWidget;
                  if (item.model.responseType == 0) {
                    childWidget = ProductItem(viewModel: item);
                  } else {
                    childWidget = ActivityItem();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                      child: childWidget,
                    ),
                  );
                },
              ),
            ),
    );
  }
}

class RecommendListBar extends StatelessWidget {
  final List<_RecommendItemViewModel> list;

  const RecommendListBar({Key key, this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 20),
      height: 210,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemBuilder: (ctx, i) {
          return RecommendItem(viewModel: list[i]);
        },
        itemCount: list.length,
      ),
    );
  }
}

class RecommendItem extends StatelessWidget {
  final _RecommendItemViewModel viewModel;

  const RecommendItem({Key key, this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      width: 120,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AvatarWidget(
            image: viewModel.model.portrait,
            onTap: viewModel.onTapAvatar,
          ),
          SizedBox(
            height: 4,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                viewModel.model.nickName.isNotEmpty
                    ? viewModel.model.nickName
                    : 'Nick name',
                style: TextStyle(color: Color(0xffED8514), fontSize: 14),
              ),
              SizedBox(
                width: 2,
              ),
              SizedBox(
                height: 12,
                child: Image(
                  image: R.image.verified(),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            viewModel.model.aboutMe.isNotEmpty
                ? viewModel.model.aboutMe
                : 'Desc',
            textAlign: TextAlign.center,
            maxLines: 2,
            textScaleFactor: 0.9,
          ),
          SizedBox(
            height: 8,
          ),
          SizedBox(
            height: 30,
            child: FollowButton(
              userId: viewModel.model.id,
              isFollowed: viewModel.model.followStatus == 1,
            ),
          ),
        ],
      ),
    );
  }
}

class ProductItem extends StatefulWidget {
  final _FeedItemViewModel viewModel;

  const ProductItem({Key key, this.viewModel}) : super(key: key);

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    var viewModel = widget.viewModel;
    return Column(
      children: [
        // User Details
        Row(
          children: [
            AvatarWidget(
              onTap: viewModel.onTapAvatar,
            ),
            SizedBox(
              width: 8,
            ),
            Row(
              children: [
                Text(
                  viewModel.model.nickName,
                  style: TextStyle(
                    color: Color(0xffED8514),
                    fontSize: 14,
                  ),
                ),
                Container(
                  height: 12,
                  margin: const EdgeInsets.only(left: 4),
                  child: Image(
                    image: R.image.verified(),
                  ),
                ),
              ],
            ),
            Spacer(),
            IconButton(
              icon: Image(image: R.image.more_vert()),
              alignment: Alignment.centerRight,
              onPressed: () {},
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              viewModel.model.productName,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xff0F1015)),
            ),
          ),
        ),
        SizedBox(
          height: 300,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: Container(
              color: Color(0xfff8f8f8),
              child: Stack(
                children: [
                  MediaCarouselWidget(
                    items: viewModel.model.goods.map((goods) {
                      return Image(
                        fit: BoxFit.cover,
                        image: NetworkImage(goods.picture),
                      );
                    }).toList(),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      height: 20,
                      width: 70,
                      decoration: BoxDecoration(
                        color: Color(0xffFEAC1B),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(50),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '10% off',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Image(image: R.image.add_cart()),
                            Text(
                              viewModel.model.shoppingCar,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Column(
                          children: [
                            Image(image: R.image.favorite()),
                            Text(
                              viewModel.model.collectNum,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.ideographic,
            children: [
              Text(
                viewModel.model.currentPriceStr,
                style: TextStyle(
                    color: Color(0xff0F1015),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                viewModel.model.originalPriceStr,
                style: TextStyle(
                    color: Color(0xff979AA9),
                    fontSize: 12,
                    decoration: TextDecoration.lineThrough),
              ),
              Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xffED3544), width: 1),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text(
                  'Free shipping'.toUpperCase(),
                  style: TextStyle(
                    color: Color(0xffED3544),
                    fontSize: 10,
                  ),
                ),
              ),
              // Text('#Tag'),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            viewModel.model.goodsDescription,
            style: TextStyle(
              color: Color(0xff555764),
              fontSize: 12,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: viewModel.model.tagSelected.length,
            itemBuilder: (ctx, i) {
              return TagButton(
                onPressed: () {
                  Keys.navigatorKey.currentState.pushNamed(Routes.searchByTag);
                },
                text: viewModel.model.tagSelected[i],
              );
            },
          ),
        ),
      ],
    );
  }
}

class ActivityItem extends StatefulWidget {
  ActivityItem({Key key}) : super(key: key);

  @override
  _ActivityItemState createState() => _ActivityItemState();
}

class _ActivityItemState extends State<ActivityItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          // User Details
          Row(
            children: [
              AvatarWidget(),
              SizedBox(
                width: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'user.name',
                        style: TextStyle(
                          color: Color(0xffED8514),
                          fontSize: 14,
                        ),
                      ),
                      Container(
                        height: 12,
                        margin: const EdgeInsets.only(left: 4),
                        child: Image(
                          image: R.image.verified(),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      '12K Fllowers',
                      style: TextStyle(color: Color(0xff979AA9), fontSize: 12),
                    ),
                  )
                ],
              ),
              Spacer(),
              FollowButton(
                userId: 'eLRGN8Bw',
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              crossAxisCount: 3,
              children: _buildGridItems(),
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'username ',
                  style: TextStyle(
                    color: Color(0xff0F1015),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text:
                      'Bio description product description product description product description xxxxxx',
                  style: TextStyle(
                    color: Color(0xff555764),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildGridItems() {
    var list = _testLinks..shuffle();
    return list
        .map((url) => ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image(
                fit: BoxFit.cover,
                image: NetworkImage(url),
              ),
            ))
        .toList();
  }
}

class AdItem extends StatefulWidget {
  AdItem({Key key}) : super(key: key);

  @override
  _AdItemState createState() => _AdItemState();
}

class _AdItemState extends State<AdItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          // User Details
          Row(
            children: [
              AvatarWidget(),
              SizedBox(
                width: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Shop.name @username',
                    style: TextStyle(
                      color: Color(0xff0F1015),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      '#tag',
                      style: TextStyle(
                        color: Color(0xff48B6EF),
                        fontSize: 14,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: Container(
                height: 200,
                child: MediaCarouselWidget(
                    items: _testLinks.map((url) {
                  return Image(
                    fit: BoxFit.cover,
                    image: NetworkImage(url),
                  );
                }).toList())),
          ),
        ],
      ),
    );
  }
}

final _testLinks = [
  'https://www.nio.cn/ecs/prod/s3fs-public/ec6/hero-background-mobile.jpg',
  'https://www.nio.cn/ecs/prod/s3fs-public/mynio-2021/images/et7/design/et7-hero-design-aquila-desktop.jpg',
  'https://www.nio.cn/ecs/prod/s3fs-public/inline-images/es8-202004/es8-hero-pc.jpg',
  'https://tesla-cdn.thron.cn/delivery/public/image/tesla/3304be3b-dd0a-4128-9c26-eb61c0b98d61/bvlatuR/std/800x2100/Mobile-ModelY',
  'https://tesla-cdn.thron.cn/delivery/public/image/tesla/011f6961-d539-48e9-b714-c154bfbaaf8b/bvlatuR/std/800x2100/homepage-model-3-hero-mobile-cn',
  'https://www.nio.cn/ecs/prod/s3fs-public/mynio-2021/images/et7/et7-hero-desktop.jpg',
];

// final _videoLinks = [
//   'https://www.runoob.com/try/demo_source/mov_bbb.mp4',
//   'https://media.w3.org/2010/05/sintel/trailer.mp4',
//   'http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4',
// ];

// final _users = <String>[
//   'currentUser',
//   'grootlover',
//   'rocket',
//   'nebula',
//   'starlord',
//   'gamora',
// ];

class _ViewModel {
  final _FeedViewModel followingViewModel;
  final _FeedViewModel foryouViewModel;

  _ViewModel({
    this.followingViewModel,
    this.foryouViewModel,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      followingViewModel: _FeedViewModel.fromStore(store, 0),
      foryouViewModel: _FeedViewModel.fromStore(store, 1),
    );
  }
}

class _FeedViewModel {
  final bool isLoading;
  final String error;
  final int type;
  final bool showRecommends;
  final FeedsState state;
  final List<_RecommendItemViewModel> recommendUsers;
  final List<_FeedItemViewModel> items;
  final int offset;
  final bool isEmpty;

  _FeedViewModel({
    this.isLoading = false,
    this.error = '',
    this.type = 0,
    this.showRecommends = false,
    this.state = const FeedsState(),
    this.recommendUsers = const [],
    this.items = const [],
    this.offset = 0,
    this.isEmpty = true,
  });

  static _FeedViewModel fromStore(Store<AppState> store, int type) {
    if (type == 0) {
      var items = store.state.feeds.followingFeeds.list
          .map((model) => _FeedItemViewModel.fromStore(store, model))
          .toList();
      var recommendUsers = store.state.feeds.followingFeeds.recommendUsers
          .map((model) => _RecommendItemViewModel.fromStore(store, model))
          .toList();
      var showRecommends = recommendUsers.isNotEmpty;
      var offset = 0;
      if (showRecommends) {
        offset = items.isEmpty ? 1 : 2;
      }
      var isEmpty = (items.length + offset) == 0;
      var model = _FeedViewModel(
        type: type,
        showRecommends: showRecommends,
        state: store.state.feeds.followingFeeds,
        recommendUsers: recommendUsers,
        items: items,
        offset: offset,
        isEmpty: isEmpty,
      );
      return model;
    }

    var items = store.state.feeds.forYouFeeds.list
        .map((model) => _FeedItemViewModel.fromStore(store, model))
        .toList();
    var model = _FeedViewModel(
      type: type,
      items: items,
      state: store.state.feeds.forYouFeeds,
      isEmpty: items.isEmpty,
    );
    return model;
  }
}

class _RecommendItemViewModel {
  final Feed model;
  final VoidCallback onTapAvatar;

  _RecommendItemViewModel({this.model, this.onTapAvatar});

  static _RecommendItemViewModel fromStore(Store<AppState> store, Feed item) {
    _onTapAvatar() {
      store.dispatch(ShowShopDetailAction(userId: item.id));
      Keys.navigatorKey.currentState.pushNamed(Routes.shop);
    }

    return _RecommendItemViewModel(model: item, onTapAvatar: _onTapAvatar);
  }
}

class _FeedItemViewModel {
  final Feed model;
  final VoidCallback onTapAvatar;

  _FeedItemViewModel({this.model, this.onTapAvatar});

  static _FeedItemViewModel fromStore(Store<AppState> store, Feed item) {
    _onTapAvatar() {
      store.dispatch(ShowShopDetailAction(userId: item.userId));
      Keys.navigatorKey.currentState.pushNamed(Routes.shop);
    }

    return _FeedItemViewModel(model: item, onTapAvatar: _onTapAvatar);
  }
}
