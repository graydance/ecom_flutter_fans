import 'package:fans/r.g.dart';
import 'package:fans/screen/components/avatar_widget.dart';
import 'package:flutter/cupertino.dart';

class FollowingFeedScreen extends StatefulWidget {
  FollowingFeedScreen({Key key}) : super(key: key);

  @override
  _FollowingFeedScreenState createState() => _FollowingFeedScreenState();
}

class _FollowingFeedScreenState extends State<FollowingFeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xfff8f8f8),
      child: ListView.builder(
        itemBuilder: (ctx, i) {
          if (i == 0) {
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: RecommendListBar(),
            );
          }
          if (i == 1) {
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
          return Padding(
            padding: const EdgeInsets.only(top: 10),
            child: PostWidget(),
          );
        },
        itemCount: 6,
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
      color: CupertinoColors.white,
      padding: const EdgeInsets.only(top: 20),
      height: 210.0,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemBuilder: (ctx, i) {
          return RecommendItem(
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
          AvatarWidget(),
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
            child: CupertinoButton(
              color: Color(0xffED8514),
              onPressed: () {},
              child: Text(
                'Follow',
                style: TextStyle(
                  // fontSize: 9,
                  color: CupertinoColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PostWidget extends StatefulWidget {
  PostWidget({Key key}) : super(key: key);

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoColors.white,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Column(
        children: [
          // User Details
          Row(
            children: [
              AvatarWidget(),
              Row(
                children: [
                  Text('user.name',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 12,
                    child: Image(
                      image: R.image.interest_selected(),
                    ),
                  ),
                ],
              ),
              Spacer(),
              Text('More'),
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
            height: 200,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: PageView(
                children: [
                  Image(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        'https://www.nio.cn/ecs/prod/s3fs-public/ec6/hero-background-mobile.jpg'),
                  ),
                  Image(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        'https://tesla-cdn.thron.cn/delivery/public/image/tesla/3304be3b-dd0a-4128-9c26-eb61c0b98d61/bvlatuR/std/800x2100/Mobile-ModelY'),
                  ),
                  Image(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        'https://tesla-cdn.thron.cn/delivery/public/image/tesla/011f6961-d539-48e9-b714-c154bfbaaf8b/bvlatuR/std/800x2100/homepage-model-3-hero-mobile-cn'),
                  ),
                ],
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
      ),
    );
  }
}
