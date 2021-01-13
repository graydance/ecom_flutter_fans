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
      child: CircleAvatar(
        radius: size / 2,
        backgroundImage: NetworkImage(image.isEmpty
            ? 'https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=159637421,4079816873&fm=26&gp=0.jpg'
            : image),
      ),
    );
  }
}
