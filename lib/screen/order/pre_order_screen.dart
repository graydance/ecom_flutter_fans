import 'dart:async';

import 'package:fans/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:fans/models/address.dart';
import 'package:fans/models/models.dart';
import 'package:fans/models/order_detail.dart';
import 'package:fans/models/order_sku.dart';
import 'package:fans/r.g.dart';
import 'package:fans/screen/components/address_form.dart';
import 'package:fans/store/actions.dart';
import 'package:fans/theme.dart';

class PreOrderScreen extends StatefulWidget {
  PreOrderScreen({Key key}) : super(key: key);

  @override
  _PreOrderScreenState createState() => _PreOrderScreenState();
}

class _PreOrderScreenState extends State<PreOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: _ViewModel.fromStore,
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
                    context: context, model: viewModel.orderDetail),
                viewModel.orderDetail.addresses.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                        ),
                        child: AddressForm(
                          onAdded: viewModel.refreshData,
                        ),
                      )
                    : Column(
                        children: [
                          buildAddess(
                              'Shipping Address', viewModel.shippingAddress),
                          buildAddess(
                              'Billing Address', viewModel.billingAddress),
                          // buildAddess('OR.Choose Another Address',
                          //     viewModel.otherAddresses),
                        ],
                      ),
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
              onPressed:
                  viewModel.orderDetail.canOrder ? viewModel.onTapPay : null,
              child: Text(
                'Continue to payment',
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

  Widget buildAddess(String title, Address address) {
    if (address == null) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.color0F1015,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          AddressInfoTile(address: address),
        ],
      ),
    );
  }
}

class OrderDetailsExpansionTile extends StatefulWidget {
  const OrderDetailsExpansionTile({
    Key key,
    @required this.context,
    @required this.model,
  }) : super(key: key);

  final BuildContext context;
  final OrderDetail model;

  @override
  _OrderDetailsExpansionTileState createState() =>
      _OrderDetailsExpansionTileState();
}

class _OrderDetailsExpansionTileState extends State<OrderDetailsExpansionTile> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        accentColor: AppTheme.color0F1015,
        textTheme: Theme.of(context).textTheme.copyWith(
              subtitle1: TextStyle(
                  color: AppTheme.color0F1015, fontWeight: FontWeight.w600),
            ),
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        title: Row(children: [
          Text(
            'Order Details',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.color0F1015,
            ),
          ),
          _isExpanded
              ? Icon(
                  Icons.keyboard_arrow_up,
                  size: 20,
                )
              : Icon(
                  Icons.keyboard_arrow_down,
                  size: 20,
                ),
        ]),
        trailing: Text('${widget.model.totalStr}'),
        backgroundColor: Colors.white,
        initiallyExpanded: _isExpanded,
        onExpansionChanged: (isExpanded) {
          setState(() {
            _isExpanded = isExpanded;
          });
        },
        children: [
          ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 10,
              );
            },
            shrinkWrap: true,
            itemCount: widget.model.list.length,
            itemBuilder: (ctx, i) {
              final item = widget.model.list[i];
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 110,
                    width: 110,
                    child: FadeInImage(
                      placeholder: R.image.kol_album_bg(),
                      image: NetworkImage(item.skuImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.goodsName,
                          maxLines: 3,
                          style: TextStyle(
                            color: AppTheme.color0F1015,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          item.currentPriceStr,
                          style: TextStyle(
                            color: AppTheme.color0F1015,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Quantity:${item.number}',
                          style: TextStyle(
                            color: AppTheme.color555764,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(
            height: 12,
          ),
          OrderPriceTile(
            leading: 'Subtotal',
            trailing: widget.model.subtotalStr,
          ),
          OrderPriceTile(
            leading: 'Shipping',
            trailing: widget.model.shipping,
          ),
          OrderPriceTile(
            leading: 'Taxes',
            trailing: widget.model.taxesStr,
          ),
          Divider(),
          ListTile(
            title: Text(
              'Total:',
              style: TextStyle(
                color: AppTheme.color0F1015,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            trailing: Text(
              widget.model.totalStr,
              style: TextStyle(
                color: AppTheme.color0F1015,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderPriceTile extends StatelessWidget {
  final String leading;
  final String trailing;

  const OrderPriceTile(
      {Key key, @required this.leading, @required this.trailing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle _titleStyle = TextStyle(
      color: AppTheme.color555764,
      fontSize: 14,
    );
    TextStyle _textStyle = TextStyle(
      color: AppTheme.color0F1015,
      fontSize: 14,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(children: [
        Text(
          leading,
          style: _titleStyle,
        ),
        Spacer(),
        Text(
          trailing,
          style: _textStyle,
        ),
      ]),
    );
  }
}

class AddressInfoTile extends StatelessWidget {
  final Address address;
  const AddressInfoTile({
    Key key,
    @required this.address,
  }) : super(key: key);

  TextStyle get _textStyle {
    if (address.isDefault == 1)
      return TextStyle(color: AppTheme.colorFEAC1B, fontSize: 12);
    return TextStyle(color: AppTheme.color555764, fontSize: 12);
  }

  BoxDecoration get _boxDecoration {
    if (address.isDefault == 1)
      return BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: AppTheme.colorFEAC1B.withAlpha(54),
      );
    return BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      border: Border.all(color: AppTheme.color555764),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Container(
        decoration: _boxDecoration,
        child: Stack(
          children: [
            address.isDefault == 1
                ? Positioned(
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: AppTheme.colorFEAC1B.withAlpha(70),
                      ),
                      padding: const EdgeInsets.all(4.0),
                      child: Text('Default', style: _textStyle),
                    ),
                  )
                : Container(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${address.firstName} ${address.lastName}',
                    style: _textStyle,
                  ),
                  Text(
                    address.addressLine1,
                    style: _textStyle,
                  ),
                  Text(
                    address.addressLine1,
                    style: _textStyle,
                  ),
                  Text(
                    '${address.city} ${address.province} ${address.country}  ${address.zipCode}',
                    style: _textStyle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      Row(
        children: [
          Checkbox(
            value: address.isDefault == 1,
            onChanged: (value) {},
            activeColor: AppTheme.colorFEAC1B,
          ),
          Text(
            'Set as billing address',
            style: TextStyle(
              color: AppTheme.color979AA9,
              fontSize: 12,
            ),
          ),
        ],
      ),
    ]);
  }
}

class _ViewModel {
  final OrderDetail orderDetail;
  final Address shippingAddress;
  final Address billingAddress;
  final VoidCallback refreshData;
  final VoidCallback onTapPay;

  _ViewModel({
    this.orderDetail,
    this.shippingAddress,
    this.billingAddress,
    this.refreshData,
    this.onTapPay,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    final orderDetail = store.state.preOrder.orderDetail;
    final shippingAddress = orderDetail.addresses
        ?.firstWhere((e) => e.isDefault == 1, orElse: () => null);
    final billingAddress = orderDetail.addresses
        ?.firstWhere((e) => e.isBillDefault == 1, orElse: () => null);

    _refreshData() {
      final buyGoods = orderDetail.list
          .map((sku) => OrderParameters(
              idolGoodsId: sku.idolGoodsId,
              skuSpecIds: sku.skuSpecIds,
              number: sku.number))
          .toList();
      store.dispatch(PreOrderAction(buyGoods: buyGoods));
    }

    _onTapPay() {
      EasyLoading.show();
      final completer = Completer();
      completer.future.then((value) {
        EasyLoading.dismiss();
        Keys.navigatorKey.currentState
            .pushReplacementNamed(Routes.payment, arguments: value['id']);
      }).catchError((error) {
        EasyLoading.dismiss();
        EasyLoading.showToast(error.toString());
      });

      final buyGoods = orderDetail.list
          .map((sku) => OrderParameters(
              idolGoodsId: sku.idolGoodsId,
              skuSpecIds: sku.skuSpecIds,
              number: sku.number))
          .toList();
      store.dispatch(OrderAction(buyGoods, shippingAddress.id,
          billingAddress?.id ?? shippingAddress.id, completer));
    }

    return _ViewModel(
      orderDetail: orderDetail,
      shippingAddress: shippingAddress,
      billingAddress: billingAddress,
      refreshData: _refreshData,
      onTapPay: _onTapPay,
    );
  }
}
