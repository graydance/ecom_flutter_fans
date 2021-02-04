import 'package:fans/app.dart';
import 'package:fans/r.g.dart';
import 'package:fans/theme.dart';
import 'package:flutter/material.dart';

class CartButton extends StatelessWidget {
  final int count;
  const CartButton({Key key, this.count = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        height: 40,
        child: Stack(
          children: [
            TextButton(
              onPressed: () {
                Keys.navigatorKey.currentState.pushNamed(Routes.cart);
              },
              child: Image(
                image: R.image.cart(),
              ),
              style: TextButton.styleFrom(minimumSize: Size(44, 30)),
            ),
            if (count > 0)
              Positioned(
                top: 10,
                right: 10,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(color: AppTheme.colorED3544),
                    constraints: BoxConstraints(minWidth: 14, minHeight: 14),
                    child: Text(
                      '${count > 99 ? '99+' : count}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
