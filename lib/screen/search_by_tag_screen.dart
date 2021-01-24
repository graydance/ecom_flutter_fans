import 'dart:async';

import 'package:fans/screen/components/emtpy_view.dart';
import 'package:fans/screen/components/product_feed_item.dart';
import 'package:fans/screen/components/verified_username_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:fans/models/models.dart';
import 'package:fans/r.g.dart';
import 'package:fans/screen/components/avatar_widget.dart';
import 'package:fans/screen/components/tag_button.dart';
import 'package:fans/store/actions.dart';

class SearchByTagScreen extends StatefulWidget {
  SearchByTagScreen({Key key}) : super(key: key);

  @override
  _SearchByTagScreenState createState() => _SearchByTagScreenState();
}

class _SearchByTagScreenState extends State<SearchByTagScreen> {
  final _refreshController = EasyRefreshController();

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (ctx, model) => Scaffold(
        appBar: AppBar(
          title: VerifiedUserNameView(
            name: model.feed.nickName,
            isLarge: true,
            verified: model.feed.isOfficial == 1,
          ),
          elevation: 0,
        ),
        body: SafeArea(
          child: Container(
            color: Color(0xfff8f8f8),
            child: EasyRefresh(
              controller: _refreshController,
              enableControlFinishRefresh: true,
              enableControlFinishLoad: true,
              onRefresh: () async {
                var action = SearchByTagAction(
                  userId: model.feed.userId,
                  page: 1,
                  tag: model.tag,
                  limit: 10,
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
              onLoad: model.currentPage == model.totalPage
                  ? null
                  : () async {
                      if (model.currentPage == model.totalPage) {
                        _refreshController.finishLoad(noMore: true);
                        return;
                      }
                      var action = SearchByTagAction(
                        userId: model.feed.userId,
                        page: model.currentPage + 1,
                        tag: model.tag,
                        limit: 10,
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
              firstRefresh: model.list.isEmpty ? true : false,
              firstRefreshWidget: Center(
                child: CircularProgressIndicator(),
              ),
              emptyWidget: model.list.isEmpty ? EmptyView() : null,
              child: ListView.builder(
                itemBuilder: (ctx, i) {
                  return Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      color: Colors.white,
                      child: TagProductItem(
                        key: ValueKey(model.list[i].id),
                        model: model.list[i],
                      ),
                    ),
                  );
                },
                itemCount: model.list.length,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TagProductItem extends StatelessWidget {
  final Feed model;
  const TagProductItem({Key key, this.model}) : super(key: key);

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
                  VerifiedUserNameView(name: model.nickName),
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
                        ...model.tagSelected
                            .map(
                              (e) => TagButton(
                                text: e,
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                                onPressed: () {},
                              ),
                            )
                            .toList(),
                      ],
                    ),
                  ),
                ],
              ),
              Spacer(),
              IconButton(
                icon: Image(
                  image: R.image.more_vert(),
                ),
                alignment: Alignment.centerRight,
                onPressed: () {},
              ),
            ],
          ),
          ProductFeedItem(model: model),
        ],
      ),
    );
  }
}

class _ViewModel {
  final Feed feed;
  final String tag;
  final int currentPage;
  final int totalPage;
  final List<Feed> list;

  _ViewModel(this.feed, this.tag, this.currentPage, this.totalPage, this.list);

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
        store.state.tagSearch.feed,
        store.state.tagSearch.tag,
        store.state.tagSearch.currentPage,
        store.state.tagSearch.totalPage,
        store.state.tagSearch.list);
  }
}
