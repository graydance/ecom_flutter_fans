import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:fans/app.dart';
import 'package:fans/models/models.dart';
import 'package:fans/store/actions.dart';
import 'package:fans/theme.dart';

class AllinPayResultArguments {
  final String accessOrderId;

  AllinPayResultArguments(this.accessOrderId);

  Map<String, dynamic> toMap() {
    return {
      'accessOrderId': accessOrderId,
    };
  }

  factory AllinPayResultArguments.fromMap(Map<String, dynamic> map) {
    return AllinPayResultArguments(
      map['accessOrderId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AllinPayResultArguments.fromJson(String source) =>
      AllinPayResultArguments.fromMap(json.decode(source));
}

class AllinPayResultScreen extends StatefulWidget {
  final Map<String, dynamic> arguments;
  AllinPayResultScreen({Key key, this.arguments}) : super(key: key);

  @override
  _AllinPayResultScreenState createState() => _AllinPayResultScreenState();
}

class _AllinPayResultScreenState extends State<AllinPayResultScreen> {
  bool _isLoading = true;
  String _message = '';

  @override
  Widget build(BuildContext context) {
    final AllinPayResultArguments args =
        AllinPayResultArguments.fromMap(widget.arguments);
    _confirmPayStatus(args.accessOrderId);
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

  _confirmPayStatus(String accessOrderId) {
    final completer = Completer();
    completer.future.then((data) {
      setState(() {
        _isLoading = false;
      });

      bool isSuccess = data['isPaySuccess'];
      if (isSuccess) {
        Keys.navigatorKey.currentState.pushNamedAndRemoveUntil(
            Routes.paymentSuccess, (route) => route.isFirst,
            arguments: data);
      } else {
        setState(() {
          _message = data['payDesc'] ?? 'Payment failed';
        });
      }
    }).catchError((error) {
      setState(() {
        _isLoading = false;
        _message = error.toString();
      });
    });

    StoreProvider.of<AppState>(context)
        .dispatch(PayQueryAction(accessOrderId, 'allinpay', completer));
  }
}
