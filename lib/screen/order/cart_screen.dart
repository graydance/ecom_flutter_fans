import 'package:flutter/material.dart';

import 'package:fans/r.g.dart';
import 'package:fans/screen/components/quantity_editing_button.dart';
import 'package:fans/theme.dart';

class CartScreen extends StatefulWidget {
  CartScreen({Key key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isEditing = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart(2)'),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextButton(
              onPressed: () {
                setState(() {
                  _isEditing = !_isEditing;
                });
              },
              child: Text(
                'Manage',
                style: TextStyle(
                  color: AppTheme.colorED8514,
                ),
              ),
              style: TextButton.styleFrom(
                side: BorderSide(color: AppTheme.colorED8514),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: CustomScrollView(
          slivers: [
            SliverFixedExtentList(
              itemExtent: 120.0,
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return CartListTile(
                    isEditing: _isEditing,
                  );
                  // return new Container(
                  //   alignment: Alignment.center,
                  //   color: Colors.lightBlue[100 * (index % 9)],
                  //   child: new Text('list item $index'),
                  // );
                },
                childCount: 5, //50个列表项
              ),
            ),
            SliverFixedExtentList(
              itemExtent: 50.0,
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return ListTile(
                    leading: Text('Subtotal:'),
                    trailing: Text('\$79'),
                  );
                },
                childCount: 5, //50个列表项
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CartListTile extends StatefulWidget {
  final bool isEditing;
  final Function(bool) onEditingChanged;
  CartListTile({Key key, this.isEditing = false, this.onEditingChanged})
      : super(key: key);

  @override
  _CartListTileState createState() => _CartListTileState();
}

class _CartListTileState extends State<CartListTile> {
  bool _isEditing;

  @override
  void initState() {
    _isEditing = widget.isEditing;
    super.initState();
  }

  // onEditingChanged(newValue) {
  //   setState(() {
  //     _isEditing = newValue;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _isEditing
            ? CircleCheckBox(value: false, onChanged: (value) {})
            : Container(),
        SizedBox(
          width: 16,
        ),
        SizedBox(
          height: 110,
          width: 110,
          child: FadeInImage(
            placeholder: R.image.kol_album_bg(),
            image: NetworkImage(''),
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title'),
            Text('\$15'),
            QuantityEditingButton(
              style: QuantityEditingButtonStyle.small,
              onChanged: (newValue) {},
            ),
            Text('* error message')
          ],
        ),
      ],
    );
  }
}

class CircleCheckBox extends StatefulWidget {
  final bool value;
  final Function(bool) onChanged;
  CircleCheckBox({Key key, this.value, this.onChanged}) : super(key: key);

  @override
  _CircleCheckBoxState createState() => _CircleCheckBoxState();
}

class _CircleCheckBoxState extends State<CircleCheckBox> {
  bool _value = false;

  @override
  void initState() {
    _value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _value = !_value;
        });
        widget.onChanged(_value);
      },
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _value ? AppTheme.colorFEAC1B : AppTheme.colorE7E8EC),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Icon(
            Icons.check,
            size: 12.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
