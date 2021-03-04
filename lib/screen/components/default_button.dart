import 'package:fans/r.g.dart';
import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key key,
    this.text,
    this.press,
  }) : super(key: key);
  final String text;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: FlatButton(
        color: Colors.white54,
        disabledColor: Colors.white12,
        disabledTextColor: Colors.white38,
        onPressed: press,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class FansButton extends StatelessWidget {
  final Function onPressed;
  final Size minimumSize;
  final String title;
  final bool isDisable;
  final double fontSize;

  const FansButton({
    Key key,
    @required this.onPressed,
    this.minimumSize = const Size(44, 44),
    this.title = '',
    this.isDisable = false,
    this.fontSize = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isDisable ? null : onPressed,
      child: Container(
        constraints: BoxConstraints(
          minWidth: minimumSize.width,
          minHeight: minimumSize.height,
          maxHeight: minimumSize.height,
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: R.image.common_button_bg(),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isDisable ? Colors.white.withAlpha(80) : Colors.white,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
    );
  }
}
