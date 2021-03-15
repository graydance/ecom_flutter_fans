import 'package:fans/screen/components/default_button.dart';
import 'package:fans/theme.dart';
import 'package:flutter/material.dart';

class AlertView extends StatelessWidget {
  final String buttonText;
  final Widget content;
  final Function onClose;
  final Function onTap;

  const AlertView(
      {Key key,
      @required this.content,
      this.buttonText = 'OK',
      this.onClose,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      this.content,
                      SizedBox(
                        height: 30,
                      ),
                      FansButton(
                        title: buttonText,
                        onPressed: () {
                          if (onTap != null) onTap();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      if (onClose != null) onClose();
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(12),
                      child: Icon(
                        Icons.clear,
                        color: AppTheme.colorC4C5CD,
                        size: 24,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
