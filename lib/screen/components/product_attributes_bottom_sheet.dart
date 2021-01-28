import 'package:fans/screen/components/default_button.dart';
import 'package:fans/theme.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:fans/r.g.dart';
import 'package:fans/screen/components/quantity_editing_button.dart';

class ProductAttributesBottomSheet extends StatefulWidget {
  final Widget child;
  final Animation<double> animation;
  ProductAttributesBottomSheet({Key key, this.child, this.animation})
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
            _titleBar(context),
            SizedBox(
              height: 20,
            ),
            ListView(
              shrinkWrap: true,
              children: [
                QuantityEditingButton(),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: TextButton(
                onPressed: () {},
                child: Text('Add to cart'),
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

  _titleBar(BuildContext context) {
    return Container(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -30,
            child: SizedBox(
              height: 110,
              width: 110,
              child: Image(
                image: R.image.kol_album_bg(),
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
                          'Mini Facial xxxxxxxxxxxxxxxxxxxxxxxxx',
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
                              '\$15',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff0F1015),
                              ),
                            ),
                            SizedBox(width: 2),
                            Text(
                              '\$30',
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

Future showProductAttributesBottomSheet(BuildContext context) {
  return showCustomModalBottomSheet(
      context: context,
      builder: (context) => ProductAttributesBottomSheet(),
      containerWidget: (_, animation, child) => FloatingModal(
            child: child,
          ),
      expand: false);
}
