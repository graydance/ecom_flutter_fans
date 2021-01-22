import 'package:flutter/material.dart';

class MediaCarouselWidget extends StatefulWidget {
  final List<Widget> items;

  const MediaCarouselWidget({Key key, this.items}) : super(key: key);

  @override
  _MediaCarouselWidgetState createState() => _MediaCarouselWidgetState();
}

class _MediaCarouselWidgetState extends State<MediaCarouselWidget> {
  var _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            children: widget.items,
            onPageChanged: (value) {
              setState(() {
                _currentPage = value;
              });
            },
          ),
          Positioned(
            bottom: 10,
            child: PhotoCarouselIndicator(
              photoCount: widget.items.length,
              activePhotoIndex: _currentPage,
            ),
          ),
        ],
      ),
    );
  }
}

class PhotoCarouselIndicator extends StatelessWidget {
  final int photoCount;
  final int activePhotoIndex;

  PhotoCarouselIndicator({
    @required this.photoCount,
    @required this.activePhotoIndex,
  });

  Widget _buildDot({bool isActive}) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 3.0, right: 3.0),
        child: Container(
          height: isActive ? 4.5 : 4.0,
          width: isActive ? 4.5 : 4.0,
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.white38,
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(photoCount, (i) => i)
          .map((i) => _buildDot(isActive: i == activePhotoIndex))
          .toList(),
    );
  }
}
