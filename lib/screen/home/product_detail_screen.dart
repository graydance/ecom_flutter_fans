import 'dart:async';

import 'package:fans/app.dart';
import 'package:fans/models/goods_skus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:fans/models/feed.dart';
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
                        model: Feed(
                            productName: model.model.productName,
                            currentPriceStr: '${model.currentPrice}',
                            originalPriceStr: '${model.originalPrice}',
                            tagNormal: [],
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
                                    model: model.model,
                                    quantity: _quantity,
                                    actionType:
                                        ProductAttributesActionType.addToCart,
                                    onQuantityChange: (newValue) {
                                      _quantity = newValue;
                                    },
                                    onTapAction: () {
                                      model.onTapAddToCart(_quantity, context);
                                    },
                                  ),
                                );
                              },
                        style: TextButton.styleFrom(
                          minimumSize: Size(44, 44),
                          primary: Colors.white,
                          backgroundColor: Color(0xffEC3644),
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
                                    model: model.model,
                                    quantity: _quantity,
                                    actionType:
                                        ProductAttributesActionType.buyNow,
                                    onQuantityChange: (newValue) {
                                      _quantity = newValue;
                                    },
                                    onTapAction: () {
                                      model.onTapBuyNow(_quantity);
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
                    child: FadeInImage(
                      placeholder: R.image.kol_album_bg(),
                      image: NetworkImage(e.picture),
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
  final Product model;
  final String currency;
  final String currentPrice;
  final String originalPrice;
  final Function(int, BuildContext) onTapAddToCart;
  final Function(int) onTapBuyNow;

  _ViewModel({
    this.model,
    this.currency,
    this.currentPrice,
    this.originalPrice,
    this.onTapAddToCart,
    this.onTapBuyNow,
  });

  static _ViewModel fromStore(Store<AppState> store, String id) {
    final state = store.state.productDetails.allStates[id];
    _onTapAddToCart(int quantity, BuildContext context) {
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
          skuSpecIds: state.model.goodsSkus.first.skuSpecIds,
          number: quantity,
        ),
        completer,
      );

      store.dispatch(action);
    }

    _onTapBuyNow(int quantity) {
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
            skuSpecIds: state.model.goodsSkus.first.skuSpecIds,
            number: quantity,
          )
        ],
        completer: completer,
      );

      store.dispatch(action);
    }

    final currency = store.state.auth.user.monetaryUnit;
    final first = state.model.goodsSkus.firstOrNull() ?? GoodsSkus();
    return _ViewModel(
        model: state.model,
        currency: currency,
        currentPrice: first.currentPriceStr,
        originalPrice: first.originalPriceStr,
        onTapAddToCart: _onTapAddToCart,
        onTapBuyNow: _onTapBuyNow);
  }
}
