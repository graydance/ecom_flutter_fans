import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fans/models/coupon_info.dart';
import 'package:fans/screen/components/alert_view.dart';
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
import 'package:fans/screen/components/tag_view.dart';
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
  String _expressInfo = '';

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

        _showCoupon(viewModel.currency);

        // 获取配置
        StoreProvider.of<AppState>(context).dispatch(FetchConfigAction());
      },
      builder: (ctx, viewModel) => Scaffold(
        backgroundColor: AppTheme.colorF8F8F8,
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
              _refreshGoodsController.finishLoad(noMore: isNoMore);
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

                    final isNoMore = currentPage >= totalPage;
                    _refreshGoodsController.finishLoad(noMore: isNoMore);
                  } catch (error) {
                    _refreshGoodsController.finishLoad(success: false);
                  }
                },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                          image: _seller.portrait.isNotEmpty
                              ? NetworkImage(_seller.portrait)
                              : R.image.idol_default_bg(),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      height: 160 + MediaQuery.of(context).padding.top,
                      child: ClipRRect(
                        child: BackdropFilter(
                          filter: _seller.portrait.isNotEmpty
                              ? ImageFilter.blur(sigmaX: 15, sigmaY: 15)
                              : ImageFilter.blur(),
                          child: Container(
                            padding: EdgeInsets.only(bottom: 6),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: _seller.portrait.isNotEmpty
                                            ? NetworkImage(_seller.portrait)
                                            : R.image.idol_avatar_placeholder(),
                                        fit: BoxFit.cover),
                                    border: Border.all(
                                        color: Colors.white, width: 1.0),
                                    color: AppTheme.colorF8F8F8,
                                  ),
                                  child: _seller.portrait.isNotEmpty ||
                                          _seller.userName.isEmpty
                                      ? null
                                      : Center(
                                          child: Text(
                                            _seller.userName[0].toUpperCase(),
                                            style: TextStyle(
                                                fontSize: 50,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white60),
                                          ),
                                        ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  '@${_seller.userName}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    shadows: [
                                      Shadow(
                                          offset: Offset(1.0, 1.0),
                                          blurRadius: 2.0,
                                          color: Color(0xFF575859)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 8,
                      right: 8,
                      child: CartButton(
                        count: viewModel.cartCount,
                        isDark: false,
                      ),
                    ),
                  ],
                ),
              ),
              if (_expressInfo.isNotEmpty)
                SliverToBoxAdapter(
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: 32,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFF68A51),
                          Color(0xFFEA5228),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          _expressInfo,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              SliverPadding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 14),
                sliver: SliverSafeArea(
                  top: false,
                  bottom: false,
                  sliver: _goods.isEmpty
                      ? SliverToBoxAdapter(
                          child: Center(
                            child: Text('No Goods'),
                          ),
                        )
                      : SliverStaggeredGrid.countBuilder(
                          itemCount: _goods.length,
                          crossAxisCount: 4,
                          mainAxisSpacing: 4.0,
                          crossAxisSpacing: 4.0,
                          itemBuilder: (context, index) => _Tile(
                              viewModel.currency,
                              _goods[index],
                              _getSize(_goods[index])),
                          staggeredTileBuilder: (index) => StaggeredTile.fit(2),
                        ),
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

  _showCoupon(String currency) async {
    final completer = Completer();
    StoreProvider.of<AppState>(context).dispatch(ShowCouponAction(completer));

    try {
      final data = await completer.future;
      final String expressInfo = data['expressInfo'];
      setState(() {
        _expressInfo = expressInfo;
      });

      final CouponInfo info = CouponInfo.fromMap(data['couponInfo']);

      if (info.status != 1) {
        return;
      }

      showDialog(
          context: context,
          builder: (ctx) {
            return AlertView(
              content: Column(
                children: [
                  Image(
                    image: R.image.coupon_discount(),
                    fit: BoxFit.contain,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Code: ${info.code}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.color0F1015,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    'On order of $currency${(info.min / 100.0).toStringAsFixed(0)}+',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.color0F1015,
                    ),
                  ),
                ],
              ),
              buttonText: 'Shop now'.toUpperCase(),
            );
          });
    } catch (e) {}
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
              child: Stack(
                children: [
                  CachedNetworkImage(
                    placeholder: (context, _) => Container(
                      color: AppTheme.colorEDEEF0,
                    ),
                    imageUrl: model.picture,
                    fit: BoxFit.cover,
                  ),
                  if (model.discount.isNotEmpty)
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        padding: EdgeInsets.only(
                          left: 6,
                          top: 4,
                          right: 14,
                          bottom: 4,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFFF68A51),
                              Color(0xFFEA5228),
                            ],
                          ),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomRight: Radius.circular(100)),
                        ),
                        child: Text(
                          '${model.discount} off',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                ],
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
