import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:redux/redux.dart';

import 'package:fans/models/models.dart';
import 'package:fans/r.g.dart';
import 'package:fans/screen/components/avatar_widget.dart';
import 'package:fans/screen/components/meida_carousel_widget.dart';
import 'package:fans/screen/components/tag_button.dart';
import 'package:fans/store/actions.dart';

class SearchByTagScreen extends StatefulWidget {
  final VoidCallback onInit;

  SearchByTagScreen({Key key, this.onInit}) : super(key: key);

  @override
  _SearchByTagScreenState createState() => _SearchByTagScreenState();
}

class _SearchByTagScreenState extends State<SearchByTagScreen> {
  final _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    if (widget.onInit != null) widget.onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (ctx, model) => Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'User.name',
                style: TextStyle(
                  color: Color(0xff0F1015),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                height: 12,
                margin: const EdgeInsets.only(left: 4),
                child: Image(
                  image: R.image.interest_selected(),
                ),
              ),
            ],
          ),
          elevation: 0,
        ),
        body: SafeArea(
          child: Container(
            color: Color(0xfff8f8f8),
            child: SmartRefresher(
              controller: _refreshController,
              onRefresh: () async {
                var action = SearchByTagAction(
                  userId: model.userId,
                  page: 1,
                  tag: model.tag,
                  limit: 10,
                  completer: Completer(),
                );
                StoreProvider.of<AppState>(context).dispatch(action);
                try {
                  await action.completer.future;
                  _refreshController.refreshCompleted();
                } catch (e) {
                  _refreshController.refreshFailed();
                }
              },
              onLoading: () async {
                var action = SearchByTagAction(
                  userId: model.userId,
                  page: model.currentPage + 1,
                  tag: model.tag,
                  limit: 10,
                  completer: Completer(),
                );
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
                itemBuilder: (ctx, i) {
                  return Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      color: Colors.white,
                      child: TagProductItem(),
                    ),
                  );
                },
                itemCount: 10,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TagProductItem extends StatelessWidget {
  const TagProductItem({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                        'User.name',
                        style: TextStyle(
                          color: Color(0xffED8514),
                          fontSize: 14,
                        ),
                      ),
                      Container(
                        height: 12,
                        margin: const EdgeInsets.only(left: 4),
                        child: Image(
                          image: R.image.interest_selected(),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Row(
                      children: [
                        Text(
                          'Releated:',
                          style: TextStyle(
                            color: Color(0xff555764),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        TagButton(
                          text: '#lifestyle',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          onPressed: () {},
                        ),
                        TagButton(
                          text: '#lifestyle',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          onPressed: () {},
                        ),
                        TagButton(
                          text: '#lifestyle',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.more_vert),
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
                'Product Name',
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
                      items: [
                        ..._testLinks.map((url) {
                          return Image(
                            fit: BoxFit.cover,
                            image: NetworkImage(url),
                          );
                        }).toList()
                      ],
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
                                '233',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
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
                                '1.4k',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
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
                  '\$21',
                  style: TextStyle(
                      color: Color(0xff0F1015),
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  '\$30',
                  style: TextStyle(
                      color: Color(0xff979AA9),
                      fontSize: 12,
                      decoration: TextDecoration.lineThrough),
                ),
                Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
              'Product description product description product description product description xxxxxx',
              style: TextStyle(
                color: Color(0xff555764),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final _testLinks = [
  'https://www.nio.cn/ecs/prod/s3fs-public/mynio-2021/images/et7/et7-hero-desktop.jpg',
  'https://www.nio.cn/ecs/prod/s3fs-public/ec6/hero-background-mobile.jpg',
  'https://www.nio.cn/ecs/prod/s3fs-public/mynio-2021/images/et7/design/et7-hero-design-aquila-desktop.jpg',
  'https://www.nio.cn/ecs/prod/s3fs-public/inline-images/es8-202004/es8-hero-pc.jpg',
  'https://tesla-cdn.thron.cn/delivery/public/image/tesla/3304be3b-dd0a-4128-9c26-eb61c0b98d61/bvlatuR/std/800x2100/Mobile-ModelY',
  'https://tesla-cdn.thron.cn/delivery/public/image/tesla/011f6961-d539-48e9-b714-c154bfbaaf8b/bvlatuR/std/800x2100/homepage-model-3-hero-mobile-cn'
];

class _ViewModel {
  final String userId;
  final String tag;
  final int currentPage;
  final int totalPage;
  final List<Goods> list;

  _ViewModel(
      this.userId, this.tag, this.currentPage, this.totalPage, this.list);

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
        store.state.tagSearch.userId,
        store.state.tagSearch.tag,
        store.state.tagSearch.currentPage,
        store.state.tagSearch.totalPage,
        store.state.tagSearch.list);
  }
}
