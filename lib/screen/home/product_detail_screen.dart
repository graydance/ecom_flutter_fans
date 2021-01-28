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
            verified: true,
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
                    goodsDescription: model.model.description),
              ),
              // Container(
              //   height: 20,
              //   padding: const EdgeInsets.only(top: 4.0),
              //   child: ListView.builder(
              //     scrollDirection: Axis.horizontal,
              //     itemCount: 3,
              //     itemBuilder: (ctx, i) {
              //       return TagButton(
              //         onPressed: () {},
              //         text: '#tag$i',
              //       );
              //     },
              //   ),
              // ),
              Container(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: Text(
                  'Similar items from Desiperkins',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F1015),
                  ),
                ),
              ),
              Container(
                height: 110,
                padding: const EdgeInsets.only(top: 4.0),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (ctx, i) {
                    return Image(
                      image: R.image.kol_album_bg(),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      width: 8,
                    );
                  },
                ),
              ),
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
                  child: TextButton(
                    style: TextButton.styleFrom(
                      primary: Color(0xffED3544),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(),
                    ),
                    onPressed: () {},
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.favorite,
                          size: 18,
                          color: Color(0xffED3544),
                        ),
                        Text(
                          'SAVED',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xffED3544),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: TextButton(
                    onPressed: () async {
                      await showProductAttributesBottomSheet(context);
                    },
                    style: TextButton.styleFrom(
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
                    onPressed: () {},
                    style: TextButton.styleFrom(
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

class _ViewModel {
  final Product model;

  _ViewModel({this.model = const Product()});

  static _ViewModel fromStore(Store<AppState> store, String id) {
    final state = store.state.productDetails.allStates[id];
    return _ViewModel();
  }
}
