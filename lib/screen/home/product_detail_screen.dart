import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fans/app.dart';
import 'package:fans/screen/components/cart_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:fans/models/models.dart';
import 'package:fans/r.g.dart';
import 'package:fans/screen/components/product_attributes_bottom_sheet.dart';
import 'package:fans/screen/components/product_feed_item.dart';
import 'package:fans/screen/components/verified_username_view.dart';
import 'package:fans/store/actions.dart';
import 'package:fans/theme.dart';
import 'package:fans/utils/list_extension.dart';

class ProductDetailScreen extends StatefulWidget {
  ProductDetailScreen({Key key}) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String _productId;
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      onInit: (store) {
        _productId = store.state.productDetails.currentId;
      },
      converter: (store) => _ViewModel.fromStore(store, _productId),
      distinct: true,
      builder: (ctx, model) => Scaffold(
        appBar: AppBar(
          title: VerifiedUserNameView(
            name: model.model.nickName,
            isLarge: true,
            verified: model.model.isOfficial == 1,
          ),
          elevation: 0,
          centerTitle: true,
          actions: [
            CartButton(
              count: model.cartCount,
            ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: EasyRefresh(
            onRefresh: () async {
              final action = FetchProductDetailAction(_productId, Completer());
              StoreProvider.of<AppState>(context).dispatch(action);
              await action.completer.future;
            },
            firstRefresh: true,
            firstRefreshWidget: Center(
              child: CircularProgressIndicator(),
            ),
            child: model.model.idolGoodsId.isEmpty
                ? Container()
                : ListView(
                    children: [
                      ProductFeedItem(
                        currency: model.currency,
                        onlyShowImage: true,
                        model: Feed(
                            productName: model.model.productName,
                            currentPriceStr:
                                '${model.firstSku.currentPriceStr}',
                            originalPriceStr:
                                '${model.firstSku.originalPriceStr}',
                            tagNormal:
                                model.model.tag.map((e) => e.name).toList(),
                            goodsDescription: model.model.description,
                            goods: model.model.goodsPictures
                                .map((e) => e.picture)
                                .toList()),
                      ),
                      model.model.recommend != null &&
                              model.model.recommend.isNotEmpty
                          ? SimilarProducts(recommends: model.model.recommend)
                          : Container(),
                    ],
                  ),
          ),
        ),
        bottomNavigationBar: model.model.idolGoodsId.isEmpty
            ? null
            : Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom),
                child: Row(
                  children: [
                    if (!model.isAnonymous)
                      Expanded(
                        flex: 1,
                        child: FavoriteButton(
                          isSaved: false,
                        ),
                      ),
                    Expanded(
                      flex: 2,
                      child: TextButton(
                        onPressed: model.model == null
                            ? null
                            : () async {
                                await showProductAttributesBottomSheet(
                                  context,
                                  ProductAttributesViewModel(
                                    currency: model.currency,
                                    model: model.model,
                                    quantity: _quantity,
                                    actionType:
                                        ProductAttributesActionType.addToCart,
                                    onQuantityChange: (newValue) {
                                      _quantity = newValue;
                                    },
                                    onTapAction: (skuSpecIds) {
                                      model.onTapAddToCart(
                                          _quantity, skuSpecIds, context);
                                    },
                                  ),
                                );
                              },
                        style: TextButton.styleFrom(
                          minimumSize: Size(44, 44),
                          primary: Colors.white,
                          backgroundColor: AppTheme.colorFEAC1B,
                          shape: RoundedRectangleBorder(),
                        ),
                        child: Text(
                          'Add to cart'.toUpperCase(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: TextButton(
                        onPressed: model.model == null
                            ? null
                            : () async {
                                await showProductAttributesBottomSheet(
                                  context,
                                  ProductAttributesViewModel(
                                    currency: model.currency,
                                    model: model.model,
                                    quantity: _quantity,
                                    actionType:
                                        ProductAttributesActionType.buyNow,
                                    onQuantityChange: (newValue) {
                                      _quantity = newValue;
                                    },
                                    onTapAction: (skuSpecIds) {
                                      model.onTapBuyNow(_quantity, skuSpecIds);
                                    },
                                  ),
                                );
                              },
                        style: TextButton.styleFrom(
                          minimumSize: Size(44, 44),
                          primary: Colors.white,
                          backgroundColor: AppTheme.colorED8514,
                          shape: RoundedRectangleBorder(),
                        ),
                        child: Text(
                          'Buy now'.toUpperCase(),
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}

class SimilarProducts extends StatelessWidget {
  final List<Goods> recommends;
  const SimilarProducts({
    Key key,
    @required this.recommends,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            'Similar items from Desiperkins',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F1015),
            ),
          ),
        ),
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 4),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          crossAxisCount: 3,
          children: recommends
              .map(
                (e) => GestureDetector(
                  onTap: () {
                    StoreProvider.of<AppState>(context)
                        .dispatch(ShowProductDetailAction(e.idolGoodsId));
                    Keys.navigatorKey.currentState
                        .pushNamed(Routes.productDetail);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: CachedNetworkImage(
                      placeholder: (context, _) => Container(
                        color: AppTheme.colorEDEEF0,
                      ),
                      imageUrl: e.picture,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class FavoriteButton extends StatefulWidget {
  final bool isSaved;
  final Function(bool) onChanged;
  const FavoriteButton({
    Key key,
    this.isSaved = false,
    this.onChanged,
  }) : super(key: key);

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool _isSaved;
  @override
  void initState() {
    _isSaved = widget.isSaved;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final color = _isSaved ? AppTheme.colorED3544 : AppTheme.colorC4C5CD;
    return TextButton(
      style: TextButton.styleFrom(
        minimumSize: Size(44, 44),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(),
      ),
      onPressed: () {
        if (widget.onChanged != null) {
          widget.onChanged(!_isSaved);
        }
        setState(() {
          _isSaved = !_isSaved;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.favorite,
            size: 14,
            color: color,
          ),
          Text(
            'SAVED',
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
          )
        ],
      ),
    );
  }
}

class _ViewModel {
  final bool isAnonymous;
  final int cartCount;
  final Product model;
  final String currency;
  final GoodsSkus firstSku;
  final Function(int, String, BuildContext) onTapAddToCart;
  final Function(int, String) onTapBuyNow;

  _ViewModel({
    this.isAnonymous,
    this.cartCount,
    this.model,
    this.currency,
    this.firstSku,
    this.onTapAddToCart,
    this.onTapBuyNow,
  });

  static _ViewModel fromStore(Store<AppState> store, String id) {
    final state = store.state.productDetails.allStates[id];
    _onTapAddToCart(int quantity, String skuSpecIds, BuildContext context) {
      EasyLoading.show();
      final completer = Completer();
      completer.future.then((value) {
        EasyLoading.dismiss();

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Added to cart successfully~'),
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            textColor: AppTheme.colorED8514,
            label: 'Go to cart>',
            onPressed: () {
              Keys.navigatorKey.currentState.pushNamed(Routes.cart);
            },
          ),
        ));
      }).catchError((error) {
        EasyLoading.dismiss();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error.toString()),
          duration: const Duration(seconds: 5),
        ));
      });

      final action = AddCartAction(
        OrderParameter(
          idolGoodsId: state.model.idolGoodsId,
          skuSpecIds: skuSpecIds,
          number: quantity,
        ),
        completer,
      );

      store.dispatch(action);
    }

    _onTapBuyNow(int quantity, String skuSpecIds) {
      EasyLoading.show();
      final completer = Completer();
      completer.future.then((value) {
        EasyLoading.dismiss();
        Keys.navigatorKey.currentState
            .pushNamed(Routes.preOrder, arguments: value);
      }).catchError((error) {
        EasyLoading.dismiss();
        EasyLoading.showToast(error.toString());
      });

      final action = PreOrderAction(
        buyGoods: [
          OrderParameter(
            idolGoodsId: state.model.idolGoodsId,
            skuSpecIds: skuSpecIds,
            number: quantity,
          )
        ],
        completer: completer,
      );

      store.dispatch(action);
    }

    final selectionSpecIds = List.generate(state.model.specList.length,
        (index) => state.model.specList[index].specValues.first.id ?? 0);

    List<GoodsSkus> skus = state.model.goodsSkus;
    final firstSku = skus.firstWhere(
        (element) => element.skuSpecIds == selectionSpecIds.join('_'),
        orElse: () => skus.firstOrNull() ?? GoodsSkus());

    final currency = store.state.auth.user.monetaryUnit;
    return _ViewModel(
        isAnonymous: store.state.auth.user.isAnonymous == 1,
        cartCount: store.state.cart.list.length,
        model: state.model,
        currency: currency,
        firstSku: firstSku,
        onTapAddToCart: _onTapAddToCart,
        onTapBuyNow: _onTapBuyNow);
  }
}
