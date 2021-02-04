import 'package:flutter/foundation.dart';

import 'package:fans/models/models.dart';

@immutable
class PreOrderState {
  final OrderDetail orderDetail;

  const PreOrderState({this.orderDetail = const OrderDetail()});

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is PreOrderState && o.orderDetail == orderDetail;
  }

  @override
  int get hashCode => orderDetail.hashCode;

  PreOrderState copyWith({
    OrderDetail orderDetail,
  }) {
    return PreOrderState(
      orderDetail: orderDetail ?? this.orderDetail,
    );
  }

  @override
  String toString() => 'PreOrderState(orderDetail: $orderDetail)';
}
