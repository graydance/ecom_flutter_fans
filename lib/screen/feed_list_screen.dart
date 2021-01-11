import 'package:flutter/material.dart';

import 'package:fans/r.g.dart';
import 'package:fans/screen/components/avatar_widget.dart';
import 'package:fans/screen/components/follow_button.dart';
import 'package:fans/screen/components/meida_carousel_widget.dart';
import 'package:fans/screen/components/video_player_widget.dart';

final testLinks = [
  'https://www.nio.cn/ecs/prod/s3fs-public/mynio-2021/images/et7/et7-hero-desktop.jpg',
  'https://www.nio.cn/ecs/prod/s3fs-public/ec6/hero-background-mobile.jpg',
  'https://www.nio.cn/ecs/prod/s3fs-public/mynio-2021/images/et7/design/et7-hero-design-aquila-desktop.jpg',
  'https://www.nio.cn/ecs/prod/s3fs-public/inline-images/es8-202004/es8-hero-pc.jpg',
  'https://tesla-cdn.thron.cn/delivery/public/image/tesla/3304be3b-dd0a-4128-9c26-eb61c0b98d61/bvlatuR/std/800x2100/Mobile-ModelY',
  'https://tesla-cdn.thron.cn/delivery/public/image/tesla/011f6961-d539-48e9-b714-c154bfbaaf8b/bvlatuR/std/800x2100/homepage-model-3-hero-mobile-cn'
];

final videoLinks = [
  'https://www.runoob.com/try/demo_source/mov_bbb.mp4',
  'https://media.w3.org/2010/05/sintel/trailer.mp4',
  'http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4',
];

class FeedListScreen extends StatefulWidget {
  final bool showTop;

  const FeedListScreen({Key key, this.showTop = true}) : super(key: key);

  @override
  _FeedListScreenState createState() => _FeedListScreenState();
}

class _FeedListScreenState extends State<FeedListScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xfff8f8f8),
      child: ListView.builder(
        itemBuilder: (ctx, i) {
          if (i == 0 && widget.showTop) {
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: RecommendListBar(),
            );
          }
          if (i == 1 && widget.showTop) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Text(
                'Recommended for you',
                style: TextStyle(
                    color: Color(0xff0F1015),
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            );
          }
          var item;
          if (!widget.showTop) {
            item = i % 2 != 0 ? ActivityItem() : AdItem();
          } else {
            item = i % 2 != 0 ? ActivityItem() : ProductItem();
          }
          return Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              child: item,
            ),
          );
        },
        itemCount: 20,
      ),
    );
  }
}

class RecommendListBar extends StatelessWidget {
  final _users = <String>[
    'currentUser',
    'grootlover',
    'rocket',
    'nebula',
    'starlord',
    'gamora',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 20),
      height: 210.0,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemBuilder: (ctx, i) {
          return RecommendItem(
            image: testLinks[i],
            name: _users[i],
            tag: '#tag tag tag tag tag',
            desc: '$_users',
          );
        },
        itemCount: _users.length,
      ),
    );
  }
}

class RecommendItem extends StatelessWidget {
  final String image;
  final String name;
  final String tag;
  final String desc;

  const RecommendItem(
      {Key key, this.image = '', this.name = '', this.tag = '', this.desc = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      width: 120,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AvatarWidget(
            image: image,
          ),
          SizedBox(
            height: 4,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: TextStyle(color: Color(0xffED8514), fontSize: 14),
              ),
              SizedBox(
                width: 2,
              ),
              SizedBox(
                height: 12,
                child: Image(
                  image: R.image.interest_selected(),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            tag,
            textAlign: TextAlign.center,
            maxLines: 1,
            textScaleFactor: 0.9,
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            desc,
            textAlign: TextAlign.center,
            maxLines: 2,
            textScaleFactor: 0.9,
          ),
          SizedBox(
            height: 8,
          ),
          SizedBox(
            height: 30,
            child: FollowButton(
              followed: false,
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class ProductItem extends StatefulWidget {
  ProductItem({Key key}) : super(key: key);

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // User Details
        Row(
          children: [
            AvatarWidget(),
            SizedBox(
              width: 8,
            ),
            Row(
              children: [
                Text(
                  'User.name',
                  style: TextStyle(
                    color: Color(0xffED8514),
                    fontSize: 14,
                  ),
                ),
                Container(
                  height: 12,
                  margin: const EdgeInsets.only(left: 4),
                  child: Image(
                    image: R.image.interest_selected(),
                  ),
                ),
              ],
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.more_vert),
              alignment: Alignment.centerRight,
              onPressed: () {},
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Product Name',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xff0F1015)),
            ),
          ),
        ),
        SizedBox(
          height: 214,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: Container(
              color: Colors.black26,
              child: Stack(
                children: [
                  MediaCarouselWidget(
                    items: [
                      ...videoLinks.map((url) {
                        return VideoPlayerWideget(
                          url: url,
                        );
                      }).toList(),
                      ...testLinks.map((url) {
                        return Image(
                          fit: BoxFit.cover,
                          image: NetworkImage(url),
                        );
                      }).toList()
                    ],
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      height: 20,
                      width: 70,
                      decoration: BoxDecoration(
                        color: Color(0xffFEAC1B),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(50),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '10% off',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Image(image: R.image.add_cart()),
                            Text(
                              '233',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Column(
                          children: [
                            Image(image: R.image.favorite()),
                            Text(
                              '1.4k',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.ideographic,
            children: [
              Text(
                '\$21',
                style: TextStyle(
                    color: Color(0xff0F1015),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                '\$30',
                style: TextStyle(
                    color: Color(0xff979AA9),
                    fontSize: 12,
                    decoration: TextDecoration.lineThrough),
              ),
              Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xffED3544), width: 1),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text(
                  'Free shipping'.toUpperCase(),
                  style: TextStyle(
                    color: Color(0xffED3544),
                    fontSize: 10,
                  ),
                ),
              ),
              // Text('#Tag'),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Product description product description product description product description xxxxxx',
            style: TextStyle(
              color: Color(0xff555764),
              fontSize: 12,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Row(
            children: [
              Text(
                '#tag1',
                style: TextStyle(
                  color: Color(0xff48B6EF),
                  fontSize: 12,
                ),
              ),
              SizedBox(
                width: 4,
              ),
              Text(
                '#lifestyle',
                style: TextStyle(
                  color: Color(0xff48B6EF),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ActivityItem extends StatefulWidget {
  ActivityItem({Key key}) : super(key: key);

  @override
  _ActivityItemState createState() => _ActivityItemState();
}

class _ActivityItemState extends State<ActivityItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          // User Details
          Row(
            children: [
              AvatarWidget(),
              SizedBox(
                width: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'user.name',
                        style: TextStyle(
                          color: Color(0xffED8514),
                          fontSize: 14,
                        ),
                      ),
                      Container(
                        height: 12,
                        margin: const EdgeInsets.only(left: 4),
                        child: Image(
                          image: R.image.interest_selected(),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      '12K Fllowers',
                      style: TextStyle(color: Color(0xff979AA9), fontSize: 12),
                    ),
                  )
                ],
              ),
              Spacer(),
              FollowButton(
                onPressed: () {},
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              crossAxisCount: 3,
              children: _buildGridItems(),
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'username ',
                  style: TextStyle(
                    color: Color(0xff0F1015),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text:
                      'Bio description product description product description product description xxxxxx',
                  style: TextStyle(
                    color: Color(0xff555764),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildGridItems() {
    var list = testLinks..shuffle();
    return list
        .map((url) => ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image(
                fit: BoxFit.cover,
                image: NetworkImage(url),
              ),
            ))
        .toList();
  }
}

class AdItem extends StatefulWidget {
  AdItem({Key key}) : super(key: key);

  @override
  _AdItemState createState() => _AdItemState();
}

class _AdItemState extends State<AdItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          // User Details
          Row(
            children: [
              AvatarWidget(),
              SizedBox(
                width: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Shop.name @username',
                    style: TextStyle(
                      color: Color(0xff0F1015),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      '#tag',
                      style: TextStyle(
                        color: Color(0xff48B6EF),
                        fontSize: 14,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: Container(
                height: 200,
                child: MediaCarouselWidget(
                    items: testLinks.map((url) {
                  return Image(
                    fit: BoxFit.cover,
                    image: NetworkImage(url),
                  );
                }).toList())),
          ),
        ],
      ),
    );
  }
}
