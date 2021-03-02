import 'dart:async';

import 'package:fans/screen/components/tag_button.dart';
import 'package:fans/screen/components/tag_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:redux/redux.dart';

import 'package:fans/app.dart';
import 'package:fans/models/goods_item.dart';
import 'package:fans/models/models.dart';
import 'package:fans/r.g.dart';
import 'package:fans/screen/components/cart_button.dart';
import 'package:fans/screen/components/empty_view.dart';
import 'package:fans/store/actions.dart';
import 'package:fans/theme.dart';

class ShopScreen extends StatefulWidget {
  final String userName;
  ShopScreen({Key key, @required this.userName}) : super(key: key);

  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  Feed _seller = Feed();

  final _refreshGoodsController = EasyRefreshController();
  int _page = 1;
  final _pageSize = 20;
  List<GoodsItem> _goods = [];

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) {
        return _ViewModel.fromStore(
            store, widget.userName); //ModalRoute.of(context).settings.arguments
      },
      onInitialBuild: (viewModel) async {
        final completer = Completer();
        StoreProvider.of<AppState>(context).dispatch(FetchSellerInfoAction(
            userName: viewModel.userName, completer: completer));

        final Feed seller = await completer.future;
        setState(() {
          _seller = seller;
        });
      },
      builder: (ctx, viewModel) => Scaffold(
        backgroundColor: AppTheme.colorF8F8F8,
        appBar: AppBar(
          title: Text(_seller.nickName),
          elevation: 0,
          centerTitle: true,
          leading: Container(),
          actions: [
            CartButton(
              count: viewModel.cartCount,
            ),
          ],
        ),
        body: EasyRefresh(
          firstRefresh: true,
          controller: _refreshGoodsController,
          enableControlFinishRefresh: true,
          enableControlFinishLoad: true,
          onRefresh: () async {
            final action = FetchIdolGoodsAction(
                userName: viewModel.userName,
                page: 1,
                limit: _pageSize,
                completer: Completer());
            StoreProvider.of<AppState>(context).dispatch(action);

            try {
              final response = await action.completer.future;
              final totalPage = response['totalPage'];
              final currentPage = response['currentPage'];
              final list = response['list'] as List;
              List<GoodsItem> models =
                  list.map((e) => GoodsItem.fromMap(e)).toList();

              _page = 1;
              setState(() {
                _goods = models;
              });

              final isNoMore = currentPage == totalPage;
              _refreshGoodsController.finishRefresh(noMore: isNoMore);
              _refreshGoodsController.resetRefreshState();
            } catch (error) {
              _refreshGoodsController.finishRefresh(success: false);
            }
          },
          onLoad: _goods.isEmpty
              ? null
              : () async {
                  final action = FetchIdolGoodsAction(
                      userName: viewModel.userName,
                      page: _page + 1,
                      limit: _pageSize,
                      completer: Completer());
                  StoreProvider.of<AppState>(context).dispatch(action);

                  try {
                    final response = await action.completer.future;
                    final totalPage = response['totalPage'];
                    final currentPage = response['currentPage'];
                    final list = response['list'] as List;
                    List<GoodsItem> models =
                        list.map((e) => GoodsItem.fromMap(e)).toList();

                    _page += 1;
                    setState(() {
                      _goods.addAll(models);
                    });

                    final isNoMore = currentPage == totalPage;
                    _refreshGoodsController.finishLoad(noMore: isNoMore);
                  } catch (error) {
                    _refreshGoodsController.finishLoad(success: false);
                  }
                },
          emptyWidget: _goods.isEmpty ? EmptyView() : null,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  height: 160,
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
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverStaggeredGrid.countBuilder(
                  itemCount: _goods.length,
                  crossAxisCount: 4,
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                  itemBuilder: (context, index) => _Tile(viewModel.currency,
                      _goods[index], _getSize(_goods[index])),
                  staggeredTileBuilder: (index) => StaggeredTile.fit(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _Size _getSize(GoodsItem item) {
    var screenWidth = (MediaQuery.of(context).size.width - 16 * 2 - 4 * 4) / 2;
    var height = item.height / item.width * screenWidth;
    return _Size(screenWidth, height);
  }
}

class _Size {
  const _Size(this.width, this.height);

  final double width;
  final double height;
}

class _Tile extends StatelessWidget {
  const _Tile(this.currency, this.model, this.size);

  final String currency;
  final GoodsItem model;
  final _Size size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        StoreProvider.of<AppState>(context)
            .dispatch(ShowProductDetailAction(model.idolGoodsId));
        Keys.navigatorKey.currentState.pushNamed(Routes.productDetail);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: size.height,
              child: FadeInImage(
                placeholder: R.image.kol_album_bg(),
                image: NetworkImage(model.picture),
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 已知问题：web无法同时支持maxLines和ellipsis，详见 https://github.com/flutter/flutter/issues/44802#issuecomment-555707104
                  Text(
                    '${model.goodsName}',
                    style: TextStyle(
                      color: AppTheme.color555764,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.ideographic,
                    children: [
                      Text(
                        '$currency${model.currentPriceStr}',
                        style: TextStyle(
                          color: Color(0xff0F1015),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          textBaseline: TextBaseline.ideographic,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        '$currency${model.originalPriceStr}',
                        style: TextStyle(
                          color: AppTheme.color979AA9,
                          fontSize: 14,
                          decoration: TextDecoration.lineThrough,
                          textBaseline: TextBaseline.ideographic,
                        ),
                      ),
                    ],
                  ),
                  if (model.tag.isNotEmpty)
                    SizedBox(
                      height: 8,
                    ),
                  Wrap(
                    spacing: 2,
                    runSpacing: 2,
                    children: model.tag
                        .map(
                          (e) => TagView(
                            text: e.name.toUpperCase(),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildTag(String text) {
    const double fontSize = 10;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.colorED8514, width: 1),
        borderRadius: BorderRadius.circular(4.0),
      ),
      padding:
          EdgeInsets.symmetric(vertical: 4, horizontal: 8) * (fontSize / 14),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: AppTheme.colorED8514,
          fontSize: fontSize,
        ),
      ),
    );
  }
}

class _ViewModel {
  final String currency;
  final String userName;
  final int cartCount;

  _ViewModel(this.userName, this.cartCount, this.currency);

  static _ViewModel fromStore(Store<AppState> store, String userId) {
    return _ViewModel(userId, store.state.cart.list.length,
        store.state.auth.user.monetaryUnit);
  }
}
