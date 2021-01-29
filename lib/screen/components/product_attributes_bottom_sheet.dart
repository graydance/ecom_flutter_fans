import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:fans/models/product.dart';
import 'package:fans/r.g.dart';
import 'package:fans/screen/components/quantity_editing_button.dart';
import 'package:fans/theme.dart';

class ProductAttributesBottomSheet extends StatefulWidget {
  final ProductAttributesViewModel viewModel;
  ProductAttributesBottomSheet({Key key, @required this.viewModel})
      : super(key: key);

  @override
  _ProductAttributesBottomSheetState createState() =>
      _ProductAttributesBottomSheetState();
}

class _ProductAttributesBottomSheetState
    extends State<ProductAttributesBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _titleBar(context, widget.viewModel.model),
            SizedBox(
              height: 30,
            ),
            ListView(
              shrinkWrap: true,
              children: [
                QuantityEditingButton(
                  min: 1,
                  quantity: widget.viewModel.quantity,
                  onChanged: widget.viewModel.onQuantityChange,
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: TextButton(
                onPressed: widget.viewModel.onTapAction,
                child: Text(widget.viewModel.actionType.displayTitle),
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: AppTheme.colorED8514,
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _titleBar(BuildContext context, Product model) {
    final sku = model.goodsSkus.first;
    return Container(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -30,
            child: GestureDetector(
              onTap: () => debugPrint('on tap product image'),
              child: SizedBox(
                height: 110,
                width: 110,
                child: Stack(
                  children: [
                    FansImageView(url: sku.skuImage),
                    Positioned(
                      right: 4,
                      bottom: 4,
                      child: Image(
                        image: R.image.product_search(),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 120),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          model.productName,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff0F1015),
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '\$${sku.currentPriceStr}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff0F1015),
                              ),
                            ),
                            SizedBox(width: 2),
                            Text(
                              '\$${sku.originalPriceStr}',
                              style: TextStyle(
                                color: Color(0xff979AA9),
                                fontSize: 12,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                  width: 30,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      primary: AppTheme.colorC4C5CD,
                      padding: EdgeInsets.all(1),
                    ),
                    child: Icon(
                      Icons.close,
                      size: 15,
                    ),
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

class FansImageView extends StatelessWidget {
  const FansImageView({
    Key key,
    @required this.url,
  }) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4.0),
      child: FadeInImage(
        placeholder: R.image.kol_album_bg(),
        image: NetworkImage(url),
      ),
    );
  }
}

class FloatingModal extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;

  const FloatingModal({Key key, @required this.child, this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Material(
          color: backgroundColor,
          clipBehavior: Clip.none,
          borderRadius: BorderRadius.circular(12),
          child: child,
        ),
      ),
    );
  }
}

Future showProductAttributesBottomSheet(
    BuildContext context, ProductAttributesViewModel viewModel) {
  return showCustomModalBottomSheet(
      context: context,
      builder: (context) => ProductAttributesBottomSheet(viewModel: viewModel),
      containerWidget: (_, animation, child) => FloatingModal(
            child: child,
          ),
      expand: false,
      isDismissible: false);
}

enum ProductAttributesActionType { addToCart, buyNow }

extension ProductAttributesActionTypeExt on ProductAttributesActionType {
  // ignore: missing_return
  String get displayTitle {
    switch (this) {
      case ProductAttributesActionType.addToCart:
        return 'Add to cart';
      case ProductAttributesActionType.buyNow:
        return 'Buy now';
    }
  }
}

class ProductAttributesViewModel {
  final Product model;
  final int quantity;
  final ProductAttributesActionType actionType;
  final Function(int) onQuantityChange;
  final Function onTapAction;

  ProductAttributesViewModel({
    this.model,
    this.quantity,
    this.actionType,
    this.onQuantityChange,
    this.onTapAction,
  });
}
