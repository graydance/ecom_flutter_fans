import 'package:fans/app.dart';
import 'package:fans/r.g.dart';
import 'package:fans/screen/order/payment_result_screen.dart';
import 'package:fans/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PayPalCancelScreen extends StatelessWidget {
  final PaymentResultArguments arguments;
  const PayPalCancelScreen({Key key, this.arguments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                'Payment cancelled'.toUpperCase(),
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.color0F1015,
                ),
              ),
              Image(
                image: R.image.payment_success(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
