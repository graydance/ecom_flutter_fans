import 'package:fans/r.g.dart';
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2.0),
        child: FadeInImage(
          width: size,
          height: size,
          placeholder: R.image.avatar_placeholder(),
          image: NetworkImage(image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
