import 'package:fans/theme.dart';
import 'package:flutter/material.dart';

class TagView extends StatelessWidget {
  final String text;
  const TagView({
    Key key,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppTheme.colorED8514, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Text(
          text,
          style: TextStyle(
            color: AppTheme.colorED8514,
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}
