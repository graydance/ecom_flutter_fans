import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:fans/app.dart';
import 'package:fans/r.g.dart';
import 'package:fans/theme.dart';

class PaymentSuccessScreen extends StatefulWidget {
  PaymentSuccessScreen({Key key}) : super(key: key);

  @override
  _PaymentSuccessScreenState createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    final String orderId = ModalRoute.of(context).settings.arguments ?? '';
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Text(
                'CONGRATULATIONS!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.color0F1015,
                ),
              ),
              Image(
                image: R.image.payment_success(),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                '#$orderId',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.color0F1015,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'Your order will be on its way soon! Check back later for more information.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.color979AA9,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    if (kIsWeb) {
                      Keys.navigatorKey.currentState.pop();
                    } else {
                      Keys.navigatorKey.currentState
                          .popUntil((route) => route.isFirst);
                    }
                  },
                  style: TextButton.styleFrom(
                      minimumSize: Size(44, 44),
                      backgroundColor: AppTheme.colorED8514),
                  child: Text(
                    'Continue shopping',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
