import 'package:fans/networking/api.dart';
import 'package:fans/networking/networking.dart';
import 'package:fans/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class FollowButton extends StatefulWidget {
  final String userId;
  final bool isFollowed;

  const FollowButton({Key key, @required this.userId, this.isFollowed = false})
      : super(key: key);

  @override
  _FollowButtonState createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton>
    with AutomaticKeepAliveClientMixin {
  bool _isFollowed = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isFollowed = widget.isFollowed;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: FlatButton(
        color: _isFollowed ? Color(0xffC4C5CD) : AppTheme.colorED8514,
        disabledColor: AppTheme.colorED8514.withAlpha(87),
        onPressed: _isLoading ? null : _onPressed,
        child: _isLoading
            ? SizedBox(
                height: 15,
                width: 15,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                  strokeWidth: 1,
                ),
              )
            : Text(
                _isFollowed ? 'Following' : 'Follow',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
      ),
    );
  }

  _onPressed() {
    if (_isLoading) {
      return;
    }
    _setLoading(true);
    Networking.request(FollowAPI(widget.userId))
        .then((value) => setState(() {
              _isLoading = false;
              _isFollowed = value['data']['isFollow'] == 1;
            }))
        .catchError((error) {
      _setLoading(false);
      EasyLoading.showToast(error.toString());
    });
  }

  _setLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  @override
  bool get wantKeepAlive => true;
}
