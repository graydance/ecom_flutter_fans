import 'dart:async';

import 'package:fans/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:fans/app.dart';
import 'package:fans/models/models.dart';
import 'package:fans/store/actions.dart';

class PaymentResultArguments {
  final String token;

  PaymentResultArguments(this.token);

  Map<String, dynamic> toMap() {
    return {
      'token': token,
    };
  }

  factory PaymentResultArguments.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return PaymentResultArguments(
      map['token'] ?? '',
    );
  }
}

class PaymentResultScreen extends StatefulWidget {
  final PaymentResultArguments arguments;
  PaymentResultScreen({Key key, this.arguments}) : super(key: key);

  @override
  _PaymentResultScreenState createState() => _PaymentResultScreenState();
}

class _PaymentResultScreenState extends State<PaymentResultScreen> {
  bool _isLoading = true;
  String _message = '';

  @override
  Widget build(BuildContext context) {
    _confirmPayStatus(widget.arguments.token);
    return Scaffold(
      body: Container(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Text(
                _message,
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.color979AA9,
                ),
                textAlign: TextAlign.center,
              ),
      ),
    );
  }

  _confirmPayStatus(String token) {
    final completer = Completer();
    completer.future.then((data) {
      setState(() {
        _isLoading = false;
      });

      int payStatus = data['payStatus'];
      if (payStatus == 1) {
        Keys.navigatorKey.currentState.pushNamedAndRemoveUntil(
            Routes.paymentSuccess, (route) => route.isFirst,
            arguments: data);
      } else if (payStatus == -1) {
        setState(() {
          _message = 'Payment cancelled';
        });
      } else {
        setState(() {
          _message = 'Payment failed';
        });
      }
    }).catchError((error) {
      setState(() {
        _isLoading = false;
        _message = error.toString();
      });
    });

    StoreProvider.of<AppState>(context)
        .dispatch(PayCaptureAction(token, completer));
  }
}
