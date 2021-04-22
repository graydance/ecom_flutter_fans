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
  final Function(String) onTap;

  const ProductFeedItem({
    Key key,
    @required this.currency,
    @required this.model,
    this.onlyShowImage = false,
    this.onTap,
  }) : super(key: key);

  @override
  _ProductFeedItemState createState() => _ProductFeedItemState();
}

class _ProductFeedItemState extends State<ProductFeedItem> {
  @override
  void didChangeDependencies() {
    widget.model.goods.forEach((e) {
      precacheImage(
        CachedNetworkImageProvider(e),
        context,
      );
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.model.productName,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xff0F1015)),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            debugPrint('GestureDetector ${widget.model.idolGoodsId}');
            if (widget.onTap != null) widget.onTap(widget.model.id);
          },
          child: SizedBox(
            height: MediaQuery.of(context).size.width - 20 * 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: Container(
                color: Color(0xfff8f8f8),
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
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.ideographic,
            children: [
              Text(
                '${widget.currency}${widget.model.currentPriceStr}',
                style: TextStyle(
                    color: AppTheme.color0F1015,
                    fontSize: 18,
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
        Align(
          alignment: Alignment.centerLeft,
          child: Html(
            data: widget.model.goodsDescription,
          ),
        ),
      ],
    );
  }
}
