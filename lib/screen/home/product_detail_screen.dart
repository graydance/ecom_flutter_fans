import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';

import 'package:fans/app.dart';
import 'package:fans/event/app_event.dart';
import 'package:fans/models/models.dart';
import 'package:fans/r.g.dart';
import 'package:fans/screen/components/cart_button.dart';
import 'package:fans/screen/components/default_button.dart';
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
  String _skuTitle = 'Select';
  String _selectedSkuDesc = 'not selected';

  GoodsSkus _selectedSku;
  ExpressTemplete _selectedExpress;
  Product _model;

  _precacheSkuImages(Product model) {
    if (!mounted) return;
    model.goodsSkus.forEach((e) {
      precacheImage(
        CachedNetworkImageProvider(e.skuImage),
        context,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      onInit: (store) {
        AppEvent.shared.report(event: AnalyticsEvent.product_view_c);

        _productId = store.state.productDetails.currentId;
        _model = store.state.productDetails.allStates[_productId].model;
      },
      converter: (store) => _ViewModel.fromStore(store, _productId),
      distinct: true,
      builder: (ctx, model) => Scaffold(
        backgroundColor: AppTheme.colorF4F4F4,
        appBar: AppBar(
          title: VerifiedUserNameView(
            name: _model.nickName,
            isLarge: true,
            verified: _model.isOfficial == 1,
          ),
          elevation: 0,
          centerTitle: true,
          actions: [
            CartButton(
              count: model.cartCount,
            ),
          ],
        ),
        body: EasyRefresh(
          onRefresh: () async {
            final completer = Completer();
            final action = FetchProductDetailAction(_productId, completer);
            StoreProvider.of<AppState>(context).dispatch(action);
            try {
              final model = await completer.future;
              if (mounted) {
                setState(() {
                  _model = model;
                  _skuTitle = _model.specList.isNotEmpty
                      ? 'Select ' +
                          _model.specList
                              .map((e) =>
                                  '${e.specName}(${e.specValues.length})')
                              .join(', ')
                      : 'Select';
                  _selectedExpress = _model.expressTemplete.first;
                });
              }
              _precacheSkuImages(model);
            } catch (e) {
              debugPrint(e.toString());
            }
          },
          firstRefresh: true,
          firstRefreshWidget: Center(
            child: CircularProgressIndicator(),
          ),
          child: _model.idolGoodsId.isEmpty
              ? Container()
              : ListView(
                  children: [
                    Container(
                      color: Colors.white,
                      child: ProductFeedItem(
                        currency: model.currency,
                        onlyShowImage: true,
                        padding: 0,
                        model: Feed(
                            productName: _model.productName,
                            currentPriceStr:
                                '${model.firstSku.currentPriceStr}',
                            originalPriceStr:
                                '${model.firstSku.originalPriceStr}',
                            tagNormal: _model.tag.map((e) => e.name).toList(),
                            goodsDescription: _model.description,
                            goods: _model.goodsPictures
                                .map((e) => e.picture)
                                .toList()),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Column(
                        children: [
                          if (_model.goodsSkus.isNotEmpty)
                            GestureDetector(
                              onTap: () async {
                                await _showSkuBottomSheet(
                                  context,
                                  model,
                                  ProductAttributesActionType.addToCart,
                                );
                              },
                              child: Container(
                                constraints: BoxConstraints(minHeight: 54),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        _skuTitle,
                                        style: TextStyle(
                                          color: AppTheme.color0F1015,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text(
                                          _selectedSkuDesc,
                                          maxLines: 2,
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            color: AppTheme.color555764,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 10,
                                      color: AppTheme.color555764,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          Divider(
                            color: AppTheme.colorE7E8EC,
                            height: 1,
                          ),
                          GestureDetector(
                            onTap: () async {
                              await _showDeliveryBottomSheet(
                                context,
                                model,
                              );
                            },
                            child: Container(
                              constraints: BoxConstraints(minHeight: 54),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _selectedExpress != null
                                              ? _selectedExpress.name +
                                                  ' ' +
                                                  _formatPrice(
                                                      _selectedExpress.price,
                                                      model.currency)
                                              : 'Free Shipping',
                                          style: TextStyle(
                                            color: AppTheme.color0F1015,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Image(
                                                image: R.image.icon_airplane()),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: Text(
                                                  _formatShippingMessage(
                                                    _model.shippedFrom,
                                                    _model.shippedTo,
                                                    _selectedExpress,
                                                  ),
                                                  style: TextStyle(
                                                    color: AppTheme.color555764,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 10,
                                    color: AppTheme.color555764,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (_model.serviceConfigs.isNotEmpty)
                            Divider(
                              color: AppTheme.colorE7E8EC,
                              height: 1,
                            ),
                          if (_model.serviceConfigs.isNotEmpty)
                            GestureDetector(
                              onTap: () async {
                                await _showServiceBottomSheet(context, model);
                              },
                              child: Container(
                                constraints: BoxConstraints(minHeight: 54),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Service',
                                            style: TextStyle(
                                              color: AppTheme.color0F1015,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  _model.serviceConfigs
                                                      .map((e) => e.title)
                                                      .join(', '),
                                                  style: TextStyle(
                                                    color: AppTheme.color555764,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 10,
                                      color: AppTheme.color555764,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            child: Text(
                              'Description',
                              style: TextStyle(
                                color: AppTheme.color0F1015,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            child: Html(
                              data: _model.description,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    _model.recommend != null && _model.recommend.isNotEmpty
                        ? Container(
                            color: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            child:
                                SimilarProducts(recommends: _model.recommend),
                          )
                        : Container(),
                  ],
                ),
        ),
        bottomNavigationBar: _model.idolGoodsId.isEmpty
            ? null
            : Container(
                height: 44,
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
                        onPressed: _model == null
                            ? null
                            : () async {
                                await _showSkuBottomSheet(
                                  context,
                                  model,
                                  ProductAttributesActionType.addToCart,
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
                        onPressed: _model == null
                            ? null
                            : () async {
                                await _showSkuBottomSheet(
                                  context,
                                  model,
                                  ProductAttributesActionType.buyNow,
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

  Future<void> _showSkuBottomSheet(BuildContext context, _ViewModel viewModel,
      ProductAttributesActionType actionType) async {
    await showProductAttributesBottomSheet(
      context,
      ProductAttributesViewModel(
        currency: viewModel.currency,
        model: _model,
        quantity: _quantity,
        actionType: actionType,
        onQuantityChange: (newValue) {
          _quantity = newValue;
        },
        selectedSku: _selectedSku,
        onSkuChanged: (sku) {
          _selectedSku = sku;
          debugPrint('onSkuChanged >>> ${sku.toString()}');
          List<String> skuSpecIds = _selectedSku.skuSpecIds.split('_');
          if (skuSpecIds.length != _model.specList.length) {
            return;
          }

          List<String> specDescs = [];
          for (int i = 0; i < _model.specList.length; i++) {
            final spec = _model.specList[i];
            final specValue = spec.specValues.firstWhere(
              (e) => e.id.toString() == skuSpecIds[i],
              orElse: () => null,
            );
            if (specValue != null) {
              specDescs.add('${spec.specName}(${specValue.specValue})');
            }
          }
          setState(() {
            _selectedSkuDesc = specDescs.join(', ');
          });
        },
        onTapAction: (skuSpecIds, isCustomiz, customiz) {
          switch (actionType) {
            case ProductAttributesActionType.addToCart:
              AppEvent.shared.report(
                  event: AnalyticsEvent.add_to_cart,
                  parameters: {AnalyticsEventParameter.id: _model.idolGoodsId});
              viewModel.onTapAddToCart(
                _quantity,
                skuSpecIds,
                isCustomiz,
                customiz,
                _selectedExpress.id,
                context,
              );
              break;
            case ProductAttributesActionType.buyNow:
              AppEvent.shared.report(
                  event: AnalyticsEvent.buy_now,
                  parameters: {AnalyticsEventParameter.id: _model.idolGoodsId});
              viewModel.onTapBuyNow(
                _quantity,
                skuSpecIds,
                isCustomiz,
                customiz,
                _selectedExpress.id,
              );
              break;
          }
        },
      ),
    );
  }

  Future<void> _showDeliveryBottomSheet(
      BuildContext context, _ViewModel viewModel) async {
    if (_model.expressTemplete.isEmpty) {
      EasyLoading.showToast('No shipping');
      return;
    }

    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        ),
        builder: (context) {
          return _DeliveryOptionView(
            shippedFrom: _model.shippedFrom,
            shippedTo: _model.shippedTo,
            list: _model.expressTemplete,
            onChanged: (value) {
              setState(() {
                _selectedExpress = value;
              });

              _showSkuBottomSheet(
                context,
                viewModel,
                ProductAttributesActionType.addToCart,
              );
            },
            defaultExpress: _selectedExpress,
            currency: viewModel.currency,
          );
        },
        isDismissible: true);
  }

  Future<void> _showServiceBottomSheet(
      BuildContext context, _ViewModel viewModel) async {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        ),
        builder: (context) {
          return _ServiceView(
            list: _model.serviceConfigs,
            onTapAddToCart: () {
              _showSkuBottomSheet(
                context,
                viewModel,
                ProductAttributesActionType.addToCart,
              );
            },
          );
        },
        isDismissible: true);
  }
}

class _DeliveryOptionView extends StatefulWidget {
  final String shippedFrom;
  final String shippedTo;
  final List<ExpressTemplete> list;
  final Function(ExpressTemplete) onChanged;
  final ExpressTemplete defaultExpress;
  final String currency;

  _DeliveryOptionView(
      {Key key,
      @required this.shippedFrom,
      @required this.shippedTo,
      @required this.list,
      @required this.onChanged,
      @required this.currency,
      this.defaultExpress})
      : super(key: key);

  @override
  __DeliveryOptionViewState createState() => __DeliveryOptionViewState();
}

class __DeliveryOptionViewState extends State<_DeliveryOptionView> {
  ExpressTemplete _expressGroupValue;

  @override
  void initState() {
    super.initState();
    _expressGroupValue = widget.defaultExpress ?? widget.list.first;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        child: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(
              height: 40,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Delivery Opention',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppTheme.color0F1015,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        primary: AppTheme.colorC4C5CD,
                        padding: EdgeInsets.all(1),
                      ),
                      child: Image(
                        image: R.image.icon_close(),
                        width: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final model = widget.list[index];
                final price = _formatPrice(model.price, widget.currency);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: RadioListTile(
                    value: model,
                    groupValue: _expressGroupValue,
                    onChanged: (value) {
                      setState(() {
                        _expressGroupValue = value;
                      });
                      widget.onChanged(model);
                    },
                    contentPadding: EdgeInsets.zero,
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        '${model.name} $price',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.color0F1015,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    subtitle: Text(
                      _formatShippingMessage(
                          widget.shippedFrom, widget.shippedTo, model),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.color555764,
                      ),
                    ),
                    activeColor: Color(0xFFFFA700),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(color: AppTheme.colorC4C5CD, height: 1);
              },
              itemCount:
                  widget.list.length, //view_model.expressTemplete.length,
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
                bottom: 20,
              ),
              child: FansButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.onChanged(_expressGroupValue);
                },
                title: 'ADD TO CART',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceView extends StatelessWidget {
  final List<ServiceConfig> list;
  final VoidCallback onTapAddToCart;

  const _ServiceView({
    Key key,
    @required this.list,
    @required this.onTapAddToCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
              height: 210 / 375 * MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: R.image.icon_service(),
                  fit: BoxFit.fill,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 10,
                    right: 10,
                    bottom: 30,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Shop with Confidence',
                          style: TextStyle(
                            color: AppTheme.colorED8514,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          'We provids guarantess to all Olaak purchases',
                          style: TextStyle(
                            color: AppTheme.colorED8514,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 5,
                    top: 5,
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          primary: AppTheme.colorC4C5CD,
                          padding: EdgeInsets.all(1),
                        ),
                        child: Image(
                          image: R.image.icon_close(),
                          width: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return _buildTile(list[index]);
              },
              itemCount: list.length,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              child: FansButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (onTapAddToCart != null) {
                    onTapAddToCart();
                  }
                },
                title: 'ADD TO CART',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(ServiceConfig model) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: model.icon,
            width: 30,
            height: 30,
          ),
          SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.title,
                  style: TextStyle(
                    color: AppTheme.color0F1015,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  model.content,
                  style: TextStyle(
                    color: AppTheme.color555764,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
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

String _formatShippingMessage(
    String shippedFrom, String shippedTo, ExpressTemplete model) {
  if (model == null) {
    return '';
  }
  final earlyDate = DateTime.now().add(Duration(days: model.min));
  final earlyDateString = DateFormat('MM/dd').format(earlyDate);
  final theShippedTo = shippedTo.trim().isEmpty ? 'United States' : shippedTo;
  if (shippedFrom.isEmpty) {
    return 'Shipped to $theShippedTo\nEstimated delivery as early as $earlyDateString';
  }
  return 'Shipped from $shippedFrom To $theShippedTo\nEstimated delivery as early as $earlyDateString';
}

String _formatPrice(String price, String currency) {
  return double.tryParse(price) != 0 ? currency + price : 'Free';
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
          padding: const EdgeInsets.symmetric(
            vertical: 16,
          ),
          child: Text(
            'Recommended items',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.color0F1015,
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
                      fit: BoxFit.contain,
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
  final String currency;
  final GoodsSkus firstSku;
  final Function(int, String, bool, String, int, BuildContext) onTapAddToCart;
  final Function(int, String, bool, String, int) onTapBuyNow;

  _ViewModel({
    this.isAnonymous,
    this.cartCount,
    this.currency,
    this.firstSku,
    this.onTapAddToCart,
    this.onTapBuyNow,
  });

  static _ViewModel fromStore(Store<AppState> store, String id) {
    final state = store.state.productDetails.allStates[id];
    _onTapAddToCart(int quantity, String skuSpecIds, bool isCustomiz,
        String customiz, int expressTemplateId, BuildContext context) {
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
          isCustomiz: isCustomiz && customiz.trim().isNotEmpty ? 1 : 0,
          customiz: customiz,
          expressTemplateId: expressTemplateId,
        ),
        completer,
      );

      store.dispatch(action);
    }

    _onTapBuyNow(int quantity, String skuSpecIds, bool isCustomiz,
        String customiz, int expressTemplateId) {
      EasyLoading.show();
      final completer = Completer();
      completer.future.then((value) {
        EasyLoading.dismiss();
        Keys.navigatorKey.currentState
            .pushNamed(Routes.preOrderMVP, arguments: value);
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
            isCustomiz: isCustomiz && customiz.trim().isNotEmpty ? 1 : 0,
            customiz: customiz,
            expressTemplateId: expressTemplateId,
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
        currency: currency,
        firstSku: firstSku,
        onTapAddToCart: _onTapAddToCart,
        onTapBuyNow: _onTapBuyNow);
  }
}
