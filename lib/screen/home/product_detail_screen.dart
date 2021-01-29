import 'package:fans/screen/components/product_attributes_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:fans/models/feed.dart';
import 'package:fans/models/models.dart';
import 'package:fans/r.g.dart';
import 'package:fans/screen/components/product_feed_item.dart';
import 'package:fans/screen/components/verified_username_view.dart';
import 'package:fans/store/actions.dart';
import 'package:fans/theme.dart';

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
        store.dispatch(FetchProductDetailAction(_productId));
      },
      converter: (store) => _ViewModel.fromStore(store, _productId),
      distinct: true,
      builder: (ctx, model) => Scaffold(
        appBar: AppBar(
          title: VerifiedUserNameView(
            name: model.model.productName,
            isLarge: true,
            verified: model.model.isOfficial == 1,
          ),
          elevation: 0,
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              ProductFeedItem(
                model: Feed(
                    productName: model.model.productName,
                    currentPriceStr: '${model.model.currentPrice}',
                    originalPriceStr: '${model.model.originalPrice}',
                    tagNormal: [],
                    goodsDescription: model.model.description,
                    goods: model.model.goodsPictures
                        .map((e) => e.picture)
                        .toList()),
              ),
              model.model.recommend != null && model.model.recommend.isNotEmpty
                  ? SimilarProducts(recommends: model.model.recommend)
                  : Container(),
            ],
          ),
        ),
        bottomNavigationBar: Container(
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
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
                                  onTapAction: () {},
                                ));
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
                                    setState(() {
                                      _quantity = newValue;
                                    });
                                  },
                                  onTapAction: () {},
                                ));
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
            )),
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
                (e) => ClipRRect(
                  borderRadius: BorderRadius.circular(4.0),
                  child: FadeInImage(
                    placeholder: R.image.kol_album_bg(),
                    image: NetworkImage(e.picture),
                    fit: BoxFit.cover,
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

  _ViewModel({this.model = const Product()});

  static _ViewModel fromStore(Store<AppState> store, String id) {
    final state = store.state.productDetails.allStates[id];
    return _ViewModel(model: state.model);
  }
}
