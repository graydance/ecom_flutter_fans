import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TagButton extends StatelessWidget {
  final String text;
  final TextStyle style;
  final VoidCallback onPressed;

  const TagButton({
    Key key,
    this.text,
    this.style = const TextStyle(
      color: Color(0xff48B6EF),
      fontSize: 12,
    ),
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.only(right: 4),
        minimumSize: Size(12, 20),
        textStyle: style,
        // side: BorderSide(color: Colors.red, width: 1),
      ),
      onPressed: onPressed,
      child: Text(
        text,
      ),
    );
  }
}
