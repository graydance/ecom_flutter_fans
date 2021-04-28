import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:fans/app.dart';
import 'package:fans/event/app_event.dart';
import 'package:fans/r.g.dart';
import 'package:fans/screen/components/default_button.dart';
import 'package:fans/theme.dart';

class PaymentSuccessScreen extends StatefulWidget {
  PaymentSuccessScreen({Key key}) : super(key: key);

  @override
  _PaymentSuccessScreenState createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  bool _isReported = false;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments =
        ModalRoute.of(context).settings.arguments;

    final orderId = arguments['number'];
    final username = arguments['userName'];

    if (!_isReported) {
      _isReported = true;
      AppEvent.shared.report(
          event: AnalyticsEvent.pay_success,
          parameters: {AnalyticsEventParameter.id: orderId});
    }

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
                child: FansButton(
                  onPressed: () {
                    if (kIsWeb) {
                      Keys.navigatorKey.currentState
                          .pushReplacementNamed('${Routes.shop}/$username');
                    } else {
                      Keys.navigatorKey.currentState
                          .popUntil((route) => route.isFirst);
                    }
                  },
                  title: 'Continue shopping',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
