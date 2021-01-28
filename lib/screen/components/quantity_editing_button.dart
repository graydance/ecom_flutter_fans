import 'package:fans/theme.dart';
import 'package:flutter/material.dart';

class QuantityEditingButton extends StatefulWidget {
  QuantityEditingButton({Key key}) : super(key: key);

  @override
  _QuantityEditingButtonState createState() => _QuantityEditingButtonState();
}

class _QuantityEditingButtonState extends State<QuantityEditingButton> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          'Quantity',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.color0F1015,
          ),
        ),
        SizedBox(
          height: 30,
          width: 30,
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              primary: AppTheme.color979AA9,
              backgroundColor: AppTheme.colorEDEEF0,
            ),
            child: Icon(
              Icons.remove,
              size: 15,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            '1',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.color0F1015,
            ),
          ),
        ),
        SizedBox(
          height: 30,
          width: 30,
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              primary: AppTheme.color979AA9,
              backgroundColor: AppTheme.colorEDEEF0,
              padding: EdgeInsets.all(1),
            ),
            child: Icon(
              Icons.add,
              size: 15,
            ),
          ),
        ),
      ],
    );
  }
}
