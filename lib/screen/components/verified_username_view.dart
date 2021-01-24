import 'package:flutter/widgets.dart';

import 'package:fans/r.g.dart';

class VerifiedUserNameView extends StatelessWidget {
  final String name;
  final bool isLarge;
  final bool verified;
  const VerifiedUserNameView({
    Key key,
    @required this.name,
    this.isLarge = false,
    this.verified = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double fontSize = isLarge ? 16 : 14;
    return verified
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: Color(0xff0F1015),
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                height: 12,
                margin: const EdgeInsets.only(left: 4),
                child: Image(
                  image: R.image.verified(),
                ),
              ),
            ],
          )
        : Text(
            name,
            style: TextStyle(
              color: Color(0xff0F1015),
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          );
  }
}
