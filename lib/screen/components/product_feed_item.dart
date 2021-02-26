import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'package:fans/models/models.dart';
import 'package:fans/r.g.dart';
import 'package:fans/screen/components/media_carousel_widget.dart';
import 'package:fans/theme.dart';

class ProductFeedItem extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              model.productName,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xff0F1015)),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            debugPrint('GestureDetector ${model.idolGoodsId}');
            if (onTap != null) onTap(model.id);
          },
          child: SizedBox(
            height: 300,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: Container(
                color: Color(0xfff8f8f8),
                child: Stack(
                  children: [
                    MediaCarouselWidget(
                      items: model.goods.map((url) {
                        return Image(
                          fit: BoxFit.cover,
                          image: NetworkImage(url),
                        );
                      }).toList(),
                    ),
                    if (model.discount.isNotEmpty)
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
                              '${model.discount} off',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    // 购物车和收藏
                    if (!onlyShowImage)
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
                                      .format(model.shoppingCar),
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
                                      .format(model.collectNum),
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
                '$currency${model.currentPriceStr}',
                style: TextStyle(
                    color: Color(0xff0F1015),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                '$currency${model.originalPriceStr}',
                style: TextStyle(
                    color: AppTheme.color979AA9,
                    fontSize: 12,
                    decoration: TextDecoration.lineThrough),
              ),
              Spacer(),
              ...model.tagNormal
                  .map(
                    (e) => Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xffED3544), width: 1),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text(
                        e.toUpperCase(),
                        style: TextStyle(
                          color: Color(0xffED3544),
                          fontSize: 10,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            model.goodsDescription,
            style: TextStyle(
              color: Color(0xff555764),
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
