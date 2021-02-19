import 'package:flutter/widgets.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('No Data'),
    );
  }
}
