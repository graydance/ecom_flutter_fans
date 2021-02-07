import 'dart:async';

import 'package:fans/app.dart';
import 'package:fans/models/address.dart';
import 'package:fans/screen/components/order_status_image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:fans/models/models.dart';
import 'package:fans/screen/order/pre_order_screen.dart';
import 'package:fans/store/actions.dart';
import 'package:fans/theme.dart';

@immutable
class PaymentScreenParams {
  final Address shippAddress;
  final String orderId;
  final String number;

  PaymentScreenParams(this.shippAddress, this.orderId, this.number);
}

class PaymentScreen extends StatefulWidget {
  PaymentScreen({Key key}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _groupValue = 'Shipping';

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: (store) => _ViewModel.fromStore(
          store, ModalRoute.of(context).settings.arguments),
      builder: (ctx, viewModel) => Scaffold(
        appBar: AppBar(
          title: Text('My Order'),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                OrderDetailsExpansionTile(
                  currency: viewModel.currency,
                  context: context,
                  model: viewModel.orderDetail,
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: OrderStatusImageView(
                    status: OrderStatus.payment,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'Shipping Method',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.color0F1015,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppTheme.color555764, width: 1),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                viewModel.shippingAddress,
                                maxLines: 2,
                                style: TextStyle(
                                  color: AppTheme.color0F1015,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: TextButton.styleFrom(
                                side: BorderSide(color: AppTheme.color0F1015),
                                padding: EdgeInsets.all(4),
                                minimumSize: Size(20, 20),
                              ),
                              child: Text(
                                'Change',
                                style: TextStyle(
                                  color: AppTheme.color0F1015,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8, bottom: 8.0, right: 8.0),
                        child: Row(children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Radio(
                                value: 'Shipping',
                                groupValue: _groupValue,
                                activeColor: AppTheme.colorED8514,
                                onChanged: (value) {
                                  setState(() {
                                    _groupValue = value;
                                  });
                                }),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Expanded(
                            child: Text(
                              'FedEx Group',
                              style: TextStyle(
                                color: AppTheme.color555764,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Text(
                            'Free',
                            style: TextStyle(
                              color: AppTheme.color555764,
                              fontSize: 12,
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'Payment Method',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.color0F1015,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppTheme.color555764, width: 1),
                  ),
                  height: 46,
                  padding: const EdgeInsets.all(8),
                  child: Row(children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Radio(
                          value: 'PayPal',
                          groupValue: 'PayPal',
                          activeColor: AppTheme.colorED8514,
                          onChanged: (value) {
                            setState(() {
                              _groupValue = value;
                            });
                          }),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Expanded(
                      child: Text(
                        'PayPal',
                        style: TextStyle(
                          color: AppTheme.color555764,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Text(
                      '',
                      style: TextStyle(
                        color: AppTheme.color555764,
                        fontSize: 12,
                      ),
                    ),
                  ]),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextButton(
              onPressed: viewModel.onTapPay,
              child: Text(
                'Pay ${viewModel.currency}${viewModel.orderDetail.totalStr}'
                    .toUpperCase(),
                style: TextStyle(color: Colors.white),
              ),
              style: TextButton.styleFrom(
                minimumSize: Size(44, 44),
                backgroundColor: viewModel.orderDetail.canOrder
                    ? AppTheme.colorED8514
                    : AppTheme.colorED8514.withAlpha(80),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ViewModel {
  final String currency;
  final OrderDetail orderDetail;
  final String shippingAddress;
  final String orderId;
  final VoidCallback onTapPay;

  _ViewModel(
      {this.currency,
      this.orderDetail,
      this.shippingAddress,
      this.orderId,
      this.onTapPay});

  static _ViewModel fromStore(
      Store<AppState> store, PaymentScreenParams params) {
    _onTapPay() {
      EasyLoading.show();
      final completer = Completer();
      completer.future.then((value) {
        EasyLoading.dismiss();
        debugPrint('push to payment with $value');
        Keys.navigatorKey.currentState.pushNamedAndRemoveUntil(
            Routes.paymentSuccess, ModalRoute.withName(Routes.home),
            arguments: params.number);
      }).catchError((error) {
        EasyLoading.dismiss();
        EasyLoading.showToast(error.toString());
      });

      store.dispatch(PayAction(params.orderId, 'payName', completer));
    }

    final _shippAddress = params.shippAddress;
    final address =
        '${_shippAddress.firstName} ${_shippAddress.lastName}, ${_shippAddress.addressLine1} ${_shippAddress.addressLine2}, ${_shippAddress.city}, ${_shippAddress.province}, ${_shippAddress.country}, ${_shippAddress.zipCode}';
    return _ViewModel(
      currency: store.state.auth.user.monetaryUnit,
      orderDetail: store.state.preOrder.orderDetail,
      shippingAddress: address,
      orderId: params.orderId,
      onTapPay: _onTapPay,
    );
  }
}
