import 'package:fans/r.g.dart';
import 'package:fans/theme.dart';
import 'package:flutter/material.dart';

enum OrderStatus { shipping, payment }

class OrderStatusImageView extends StatelessWidget {
  final OrderStatus status;

  const OrderStatusImageView({Key key, @required this.status})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildStep('Shipping'.toUpperCase(), R.image.icon_shipping(), true),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            '........',
            style: TextStyle(color: AppTheme.color555764),
          ),
        ),
        _buildStep('Payment'.toUpperCase(), R.image.icon_payment(),
            status == OrderStatus.payment),
      ],
    );
  }

  _buildStep(String text, AssetImage image, bool visible) {
    final decoration = visible
        ? BoxDecoration(color: AppTheme.color555764)
        : BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: AppTheme.color979AA9, width: 1));
    final textColor = visible ? Colors.white : AppTheme.color979AA9;
    return Column(
      children: [
        Image(
          image: image,
        ),
        SizedBox(
          height: 4,
        ),
        Container(
          decoration: decoration,
          padding: const EdgeInsets.all(4),
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 10,
            ),
          ),
        )
      ],
    );
  }
}
