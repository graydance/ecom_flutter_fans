import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

import 'package:fans/app.dart';
import 'package:fans/r.g.dart';
import 'package:fans/theme.dart';

class CartButton extends StatelessWidget {
  final int count;
  final bool isDark;
  const CartButton({Key key, this.count = 0, this.isDark = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Badge(
        showBadge: count > 0,
        elevation: 0,
        badgeColor: AppTheme.colorED3544,
        padding: const EdgeInsets.all(4),
        position: isDark
            ? BadgePosition.topEnd(
                top: -2,
                end: -6,
              )
            : BadgePosition.topEnd(
                top: -8,
                end: -6,
              ),
        badgeContent: Text(
          '${count > 99 ? '99+' : count}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Keys.navigatorKey.currentState.pushNamed(Routes.cart);
          },
          child: Image(
            image: isDark ? R.image.cart() : R.image.cart_white(),
          ),
        ),
      ),
    );
  }
}
