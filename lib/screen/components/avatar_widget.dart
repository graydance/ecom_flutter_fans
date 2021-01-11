import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  final String image;
  final bool isLarge;
  final VoidCallback onTap;

  const AvatarWidget(
      {Key key, this.image = '', this.isLarge = true, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = isLarge ? 60.0 : 40.0;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size / 2),
          child: Image(
            image: NetworkImage(
                'https://dev.static.ramboo.live/static/tagicons/04.png'),
            height: size,
            width: size,
          ),
        ),
      ),
    );
  }
}
