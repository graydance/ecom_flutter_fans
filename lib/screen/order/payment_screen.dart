import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:universal_html/html.dart' as html;
import 'package:url_launcher/url_launcher.dart';

import 'package:fans/event/app_event.dart';
import 'package:fans/models/address.dart';
import 'package:fans/models/models.dart';
import 'package:fans/r.g.dart';
import 'package:fans/screen/components/default_button.dart';
import 'package:fans/screen/components/order_status_image_view.dart';
import 'package:fans/screen/order/pre_order_screen.dart';
import 'package:fans/store/actions.dart';
import 'package:fans/theme.dart';

@immutable
class PaymentScreenParams {
  final Address shippAddress;
  final String orderId;
  final String number;
  final Coupon coupon;
  final String totalStr;

  PaymentScreenParams(
    this.shippAddress,
    this.orderId,
    this.number,
    this.coupon,
    this.totalStr,
  );
}

class PaymentScreen extends StatefulWidget {
  PaymentScreen({Key key}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _groupValue = 'Shipping';
  String _paymentGroupValue = '';

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: (store) => _ViewModel.fromStore(
          store, ModalRoute.of(context).settings.arguments),
      onInitialBuild: (viewModel) {
        _paymentGroupValue = viewModel.paymentMethods.first?.id ?? '';
        setState(() {});
      },
      builder: (ctx, viewModel) => Scaffold(
        appBar: AppBar(
          title: Text('My Order'),
          elevation: 0,
          centerTitle: true,
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
                  canAddCoupon: false,
                  coupon: viewModel.coupon,
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
                              'Satndard Express 2 - 6 days',
                              style: TextStyle(
                                color: AppTheme.color555764,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Text(
                            viewModel.orderDetail.shipping,
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
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (ctx, index) {
                    final paymentMethod = viewModel.paymentMethods[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _paymentGroupValue = paymentMethod.id;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border:
                              Border.all(color: AppTheme.color555764, width: 1),
                        ),
                        height: 46,
                        padding: const EdgeInsets.all(8),
                        child: Row(children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Radio(
                                value: paymentMethod.id,
                                groupValue: _paymentGroupValue,
                                activeColor: AppTheme.colorED8514,
                                onChanged: (value) {
                                  setState(() {
                                    _paymentGroupValue = value;
                                  });
                                }),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Expanded(
                            child: Text(
                              paymentMethod.name,
                              style: TextStyle(
                                color: AppTheme.color555764,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Image(
                            image: paymentMethod.id.toLowerCase() == 'paypal'
                                ? R.image.paypal()
                                : R.image.credit(),
                          ),
                        ]),
                      ),
                    );
                  },
                  separatorBuilder: (ctx, index) {
                    return SizedBox(
                      height: 8,
                    );
                  },
                  itemCount: viewModel.paymentMethods.length,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: FansButton(
                    onPressed: () {
                      AppEvent.shared.report(event: AnalyticsEvent.pay);

                      viewModel.onTapPay(context, _paymentGroupValue);
                    },
                    title: 'Pay ${viewModel.currency}${viewModel.totalStr}'
                        .toUpperCase(),
                  ),
                ),
              ],
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
  final Coupon coupon;
  final String totalStr;
  final List<PaymentMethod> paymentMethods;
  final Function(BuildContext, String) onTapPay;

  _ViewModel({
    this.currency,
    this.orderDetail,
    this.shippingAddress,
    this.orderId,
    this.coupon,
    this.totalStr,
    this.paymentMethods,
    this.onTapPay,
  });

  static _ViewModel fromStore(
      Store<AppState> store, PaymentScreenParams params) {
    _onTapPay(BuildContext context, String payment) {
      EasyLoading.show();
      final completer = Completer();
      completer.future.then((value) {
        EasyLoading.dismiss();

        final payInfo = value as PayInfo;
        if (kIsWeb) {
          html.window.location.href = payInfo.payLink;
        } else {
          launch(payInfo.payLink);
        }
      }).catchError((error) {
        EasyLoading.dismiss();
        EasyLoading.showToast(error.toString());
      });

      store.dispatch(PayAction(params.orderId, payment, completer));
    }

    final _shippAddress = params.shippAddress;
    final address =
        '${_shippAddress.firstName} ${_shippAddress.lastName}, ${_shippAddress.addressLine1} ${_shippAddress.addressLine2}, ${_shippAddress.city}, ${_shippAddress.province}, ${_shippAddress.country}, ${_shippAddress.zipCode}';

    var paymentMethods = store.state.config.payMethod;
    if (paymentMethods.isEmpty) {
      paymentMethods = [PaymentMethod(id: 'paypal', name: 'PayPal')];
    }

    return _ViewModel(
      currency: store.state.auth.user.monetaryUnit,
      orderDetail: store.state.preOrder.orderDetail,
      shippingAddress: address,
      orderId: params.orderId,
      totalStr: params.totalStr,
      coupon: params.coupon,
      paymentMethods: paymentMethods,
      onTapPay: _onTapPay,
    );
  }
}
