import 'package:fans/models/feed.dart';
import 'package:fans/r.g.dart';
import 'package:fans/screen/components/product_feed_item.dart';
import 'package:fans/screen/components/tag_button.dart';
import 'package:fans/screen/components/verified_username_view.dart';
import 'package:flutter/material.dart';

class ProductDetailScreen extends StatefulWidget {
  ProductDetailScreen({Key key}) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: VerifiedUserNameView(
          name: 'User.name',
          isLarge: true,
          verified: true,
        ),
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            ProductFeedItem(
              model: Feed(
                  productName: 'Product name',
                  currentPriceStr: '69',
                  originalPriceStr: '99',
                  tagNormal: ['FREE SHIPPING'],
                  goodsDescription:
                      ' KOL Product Description KOL Description KOL Product Description KOL Description KOL Product Description KOL Description KOL Product Description  KOL Product Description KOL Description KOL Product Description KOL Description KOL Product Description KOL Description KOL Product Description'),
            ),
            Container(
              height: 20,
              padding: const EdgeInsets.only(top: 4.0),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                itemBuilder: (ctx, i) {
                  return TagButton(
                    onPressed: () {},
                    text: '#tag$i',
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: Text(
                'Similar items from Desiperkins',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffFF0F1015),
                ),
              ),
            ),
            Container(
              height: 110,
              padding: const EdgeInsets.only(top: 4.0),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (ctx, i) {
                  return Image(
                    image: R.image.kol_album_bg(),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    width: 8,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.black26,
                width: 0.5,
              ),
            ),
          ),
          padding: EdgeInsets.fromLTRB(
              20, 10, 20, 10 + MediaQuery.of(context).padding.bottom),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: FlatButton(
                  height: 40,
                  onPressed: () {},
                  color: Color(0xffEC3644),
                  child: Icon(
                    Icons.favorite,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 2,
                child: FlatButton(
                  height: 40,
                  onPressed: () {},
                  color: Color(0xffEC3644),
                  child: Text(
                    'Add to cart'.toUpperCase(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 2,
                child: FlatButton(
                  height: 40,
                  onPressed: () {},
                  color: Color(0xFFED8514),
                  child: Text(
                    'Buy now'.toUpperCase(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
