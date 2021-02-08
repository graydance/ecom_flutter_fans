import 'dart:async';

import 'package:fans/app.dart';
import 'package:fans/screen/components/cart_button.dart';
import 'package:fans/screen/components/emtpy_view.dart';
import 'package:fans/screen/components/product_feed_item.dart';
import 'package:fans/screen/components/tag_button.dart';
import 'package:fans/screen/components/verified_username_view.dart';
import 'package:fans/store/actions.dart';
import 'package:fans/store/states.dart';
import 'package:fans/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
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
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      distinct: true,
      onInit: (store) => store.dispatch(FetchCartListAction(Completer())),
      builder: (ctx, model) => Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 44,
              child: Stack(
                children: [
                  Center(
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
                        labelStyle: TextStyle(
                          fontSize: 16.0,
                        ),
                        unselectedLabelColor: Color(0xff979aa9),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    child: SizedBox(
                      height: 44,
                      child: CartButton(
                        count: model.cartCount,
                      ),
                    ),
                  )
                ],
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
  final _refreshController = EasyRefreshController();

  @override
  void initState() {
    if (widget.onInit != null) widget.onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xfff8f8f8),
      child: EasyRefresh(
        controller: _refreshController,
        enableControlFinishRefresh: true,
        enableControlFinishLoad: true,
        onRefresh: () async {
          StoreProvider.of<AppState>(context)
              .dispatch(FetchRecommendSellersAction());

          var action = FetchFeedsAction(widget.viewModel.type, 1, Completer());
          StoreProvider.of<AppState>(context).dispatch(action);
          try {
            await action.completer.future;
            _refreshController.finishRefresh();
            _refreshController.resetLoadState();
          } catch (e) {
            _refreshController.finishRefresh(success: false);
          }
        },
        onLoad: widget.viewModel.state.currentPage ==
                widget.viewModel.state.totalPage
            ? null
            : () async {
                var model = widget.viewModel.state;
                var currentPage = model.currentPage;
                if (model.currentPage == model.totalPage) {
                  _refreshController.finishLoad(noMore: true);
                  return;
                }
                var type = widget.viewModel.type;
                var action =
                    FetchFeedsAction(type, currentPage + 1, Completer());
                StoreProvider.of<AppState>(context).dispatch(action);
                try {
                  bool isNoMore = await action.completer.future;
                  _refreshController.finishLoad(
                      success: true, noMore: isNoMore);
                } catch (e) {
                  _refreshController.finishLoad(success: false);
                }
              },
        firstRefresh: widget.viewModel.state.list.isEmpty ? true : false,
        firstRefreshWidget: Center(
          child: CircularProgressIndicator(),
        ),
        emptyWidget: widget.viewModel.isEmpty ? EmptyView() : null,
        child: ListView.builder(
          addAutomaticKeepAlives: true,
          itemCount: widget.viewModel.items.length + widget.viewModel.offset,
          itemBuilder: (ctx, i) {
            if (i == 0 && widget.viewModel.showRecommends) {
              // 'Start by following your favorite stores!',
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: RecommendListBar(list: widget.viewModel.recommendUsers),
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

            var item = widget.viewModel.items[i - widget.viewModel.offset];
            var childWidget;
            if (item.model.responseType == 0) {
              childWidget = ProductItem(viewModel: item);
            } else {
              childWidget = ActivityItem(viewModel: item);
            }
            return Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Container(
                color: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
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
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'Start by following your favorite stores!',
              style: TextStyle(
                color: Color(0xff0F1015),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            height: 160,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              itemBuilder: (ctx, i) {
                return RecommendItem(viewModel: list[i]);
              },
              itemCount: list.length,
            ),
          ),
        ],
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
                style: TextStyle(color: AppTheme.colorED8514, fontSize: 14),
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
            style: TextStyle(
              color: Color(0xff979AA9),
            ),
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
            VerifiedUserNameView(
              name: viewModel.model.nickName,
              verified: viewModel.model.isOfficial == 1,
            ),
            Spacer(),
            IconButton(
              icon: Image(image: R.image.more_vert()),
              alignment: Alignment.centerRight,
              onPressed: () {},
            ),
          ],
        ),
        ProductFeedItem(
          currency: viewModel.currency,
          model: viewModel.model,
          onTap: viewModel.onTapProduct,
        ),
        Container(
          height: 20,
          padding: const EdgeInsets.only(top: 4.0),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: viewModel.model.tagSelected.length,
            itemBuilder: (ctx, i) {
              return TagButton(
                onPressed: () {
                  viewModel.onTapTag(viewModel.model.tagSelected[i]);
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

class ActivityItem extends StatelessWidget {
  final _FeedItemViewModel viewModel;
  ActivityItem({Key key, this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          // User Details
          Row(
            children: [
              AvatarWidget(
                image: viewModel.model.portrait,
                onTap: viewModel.onTapAvatar,
              ),
              SizedBox(
                width: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VerifiedUserNameView(
                    name: viewModel.model.nickName,
                    verified: viewModel.model.isOfficial == 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      '${NumberFormat.compact().format(viewModel.model.followers)} Fllowers',
                      style: TextStyle(color: Color(0xff979AA9), fontSize: 12),
                    ),
                  )
                ],
              ),
              Spacer(),
              FollowButton(
                userId: viewModel.model.id,
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
              children: viewModel.model.goods.map((url) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image(
                    fit: BoxFit.cover,
                    image: NetworkImage(url),
                  ),
                );
              }).toList(),
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: viewModel.model.userName,
                  style: TextStyle(
                    color: Color(0xff0F1015),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: viewModel.model.goodsDescription,
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
                    items: [].map((url) {
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

class _ViewModel {
  final int cartCount;
  final _FeedViewModel followingViewModel;
  final _FeedViewModel foryouViewModel;

  _ViewModel({
    this.cartCount = 0,
    this.followingViewModel,
    this.foryouViewModel,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      cartCount: store.state.cart.list.length,
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
      Keys.navigatorKey.currentState.pushNamed(Routes.shopDetail);
    }

    return _RecommendItemViewModel(model: item, onTapAvatar: _onTapAvatar);
  }
}

class _FeedItemViewModel {
  final String currency;
  final Feed model;
  final VoidCallback onTapAvatar;
  final Function(String) onTapTag;
  final Function(String) onTapProduct;

  _FeedItemViewModel(
      {this.currency,
      this.model,
      this.onTapAvatar,
      this.onTapTag,
      this.onTapProduct});

  static _FeedItemViewModel fromStore(Store<AppState> store, Feed item) {
    _onTapAvatar() {
      store.dispatch(ShowShopDetailAction(userId: item.id));
      Keys.navigatorKey.currentState.pushNamed(Routes.shopDetail);
    }

    _onTapTag(String tag) {
      store.dispatch(ShowSearchByTagAction(feed: item, tag: tag));
      Keys.navigatorKey.currentState.pushNamed(Routes.searchByTag);
    }

    _onTapProduct(String goodsId) {
      store.dispatch(ShowProductDetailAction(goodsId));
      Keys.navigatorKey.currentState.pushNamed(Routes.productDetail);
    }

    return _FeedItemViewModel(
        currency: store.state.auth.user.monetaryUnit,
        model: item,
        onTapAvatar: _onTapAvatar,
        onTapTag: _onTapTag,
        onTapProduct: _onTapProduct);
  }
}
