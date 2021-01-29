import 'package:fans/theme.dart';
import 'package:flutter/material.dart';

class QuantityEditingButton extends StatefulWidget {
  final int quantity;
  final int min;
  final int max;
  final Function(int) onChanged;

  QuantityEditingButton(
      {Key key,
      this.quantity = 1,
      this.min = 1,
      this.max = 99999,
      this.onChanged})
      : super(key: key);

  @override
  _QuantityEditingButtonState createState() => _QuantityEditingButtonState();
}

class _QuantityEditingButtonState extends State<QuantityEditingButton> {
  int _quantity;

  @override
  void initState() {
    _quantity = widget.quantity;
    super.initState();
  }

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
            onPressed: _quantity > widget.min
                ? () {
                    setState(() {
                      _quantity -= 1;
                    });
                    if (widget.onChanged != null) widget.onChanged(_quantity);
                  }
                : null,
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
        Container(
          constraints: new BoxConstraints(
            minWidth: 20.0,
          ),
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            '$_quantity',
            textAlign: TextAlign.center,
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
            onPressed: _quantity < widget.max
                ? () {
                    setState(() {
                      _quantity += 1;
                    });
                    if (widget.onChanged != null) widget.onChanged(_quantity);
                  }
                : null,
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
