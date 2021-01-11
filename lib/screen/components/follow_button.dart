import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final bool followed;
  final VoidCallback onPressed;

  const FollowButton({Key key, this.followed = false, @required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        color: followed ? Color(0xffC4C5CD) : Color(0xffED8514),
        onPressed: onPressed,
        child: Text(
          followed ? 'Following' : 'Follow',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
