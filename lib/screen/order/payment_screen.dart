import 'dart:async';

import 'package:fans/screen/order/pre_order_screen.dart';
import 'package:fans/store/actions.dart';
import 'package:fans/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:fans/models/models.dart';

class PaymentScreen extends StatefulWidget {
  PaymentScreen({Key key}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _groupValue = 'PayPal';

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
                  context: context,
                  model: viewModel.orderDetail,
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
                    border: Border.all(color: AppTheme.colorED8514, width: 1),
                  ),
                  child: RadioListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('PayPal'),
                      value: 'PayPal',
                      groupValue: _groupValue,
                      activeColor: AppTheme.colorED8514,
                      onChanged: (value) {
                        setState(() {
                          _groupValue = value;
                        });
                      }),
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
                'Pay \$${viewModel.orderDetail.totalStr}'.toUpperCase(),
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
  final OrderDetail orderDetail;
  final String orderId;
  final VoidCallback onTapPay;

  _ViewModel({this.orderDetail, this.orderId, this.onTapPay});

  static _ViewModel fromStore(Store<AppState> store, String orderId) {
    _onTapPay() {
      EasyLoading.show();
      final completer = Completer();
      completer.future.then((value) {
        EasyLoading.dismiss();
        debugPrint('push to payment with $value');
        EasyLoading.showToast('Payment successful');
      }).catchError((error) {
        EasyLoading.dismiss();
        EasyLoading.showToast(error.toString());
      });

      store.dispatch(PayAction(orderId, 'payName', completer));
    }

    return _ViewModel(
      orderDetail: store.state.preOrder.orderDetail,
      orderId: orderId,
      onTapPay: _onTapPay,
    );
  }
}
