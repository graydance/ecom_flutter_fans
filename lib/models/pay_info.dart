import 'dart:convert';

import 'package:flutter/material.dart';

@immutable
class PayInfo {
  final String payLink;
  final String returnUrl;
  final String cancelUrl;

  const PayInfo({
    this.payLink = '',
    this.returnUrl = '',
    this.cancelUrl = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'payLink': payLink,
      'return_url': returnUrl,
      'cancel_url': cancelUrl,
    };
  }

  factory PayInfo.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return PayInfo(
      payLink: map['payLink'],
      returnUrl: map['return_url'],
      cancelUrl: map['cancel_url'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PayInfo.fromJson(String source) =>
      PayInfo.fromMap(json.decode(source));

  PayInfo copyWith({
    String payLink,
    String returnUrl,
    String cancelUrl,
  }) {
    return PayInfo(
      payLink: payLink ?? this.payLink,
      returnUrl: returnUrl ?? this.returnUrl,
      cancelUrl: cancelUrl ?? this.cancelUrl,
    );
  }

  @override
  String toString() =>
      'PayInfo(payLink: $payLink, returnUrl: $returnUrl, cancelUrl: $cancelUrl)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is PayInfo &&
        o.payLink == payLink &&
        o.returnUrl == returnUrl &&
        o.cancelUrl == cancelUrl;
  }

  @override
  int get hashCode =>
      payLink.hashCode ^ returnUrl.hashCode ^ cancelUrl.hashCode;
}
