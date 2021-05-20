import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';

import 'package:fans/models/models.dart';
import 'package:fans/r.g.dart';
import 'package:fans/screen/components/media_carousel_widget.dart';
import 'package:fans/screen/components/tag_view.dart';
import 'package:fans/theme.dart';

class ProductFeedItem extends StatefulWidget {
  final String currency;
  final Feed model;
  final bool onlyShowImage;
  final double padding;
  final Function(String) onTap;

  const ProductFeedItem({
    Key key,
    @required this.currency,
    @required this.model,
    this.onlyShowImage = false,
    this.padding = 20,
    this.onTap,
  }) : super(key: key);

  @override
  _ProductFeedItemState createState() => _ProductFeedItemState();
}

class _ProductFeedItemState extends State<ProductFeedItem> {
  var _isPreload = false;
  @override
  void didChangeDependencies() {
    if (_isPreload == false) {
      _isPreload = true;

      widget.model.goods
          .sublist(0, min(2, widget.model.goods.length))
          .forEach((e) {
        precacheImage(
          CachedNetworkImageProvider(e),
          context,
        );
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (widget.onTap != null) widget.onTap(widget.model.id);
          },
          child: SizedBox(
            height: MediaQuery.of(context).size.width - widget.padding * 2,
            child: Container(
              color: AppTheme.colorF4F4F4,
              child: Stack(
                children: [
                  MediaCarouselWidget(
                    items: widget.model.goods.map((url) {
                      return Center(
                        child: CachedNetworkImage(
                          placeholder: (context, _) => Image(
                            image: R.image.goods_placeholder(),
                            fit: BoxFit.cover,
                          ),
                          imageUrl: url,
                          fit: BoxFit.contain,
                        ),
                      );
                    }).toList(),
                  ),
                  if (widget.model.discount.isNotEmpty)
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        height: 20,
                        width: 70,
                        decoration: BoxDecoration(
                          color: Color(0xffFEAC1B),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(50),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${widget.model.discount} off',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  // 购物车和收藏
                  if (!widget.onlyShowImage)
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Image(image: R.image.add_cart()),
                              Text(
                                NumberFormat.compact()
                                    .format(widget.model.shoppingCar),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Column(
                            children: [
                              Image(image: R.image.favorite()),
                              Text(
                                NumberFormat.compact()
                                    .format(widget.model.collectNum),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 20,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.ideographic,
            children: [
              Text(
                '${widget.currency}${widget.model.currentPriceStr}',
                style: TextStyle(
                    color: AppTheme.colorC20010,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                '${widget.currency}${widget.model.originalPriceStr}',
                style: TextStyle(
                    color: AppTheme.color979AA9,
                    fontSize: 14,
                    decoration: TextDecoration.lineThrough),
              ),
              Spacer(),
              ...widget.model.tagNormal
                  .map((e) => TagView(text: e.toUpperCase()))
                  .toList(),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.model.productName,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.color0F1015,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 12,
        ),
      ],
    );
  }
}
