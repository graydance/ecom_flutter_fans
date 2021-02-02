import 'dart:async';

import 'package:fans/app.dart';
import 'package:fans/screen/components/order_status_image_view.dart';
import 'package:fans/screen/order/payment_screen.dart';
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
  bool _showShippingAddressForm = false;
  bool _showBillingAddressForm = false;
  Address _shippingAddress = Address();
  Address _billingAddress = Address();
  bool _useShippingAddress = false;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      onInit: (store) {
        final orderDetail = store.state.preOrder.orderDetail;
        _shippingAddress = orderDetail.addresses
            .firstWhere((e) => e.isDefault == 1, orElse: () => Address());
        _billingAddress = orderDetail.addresses
            .firstWhere((e) => e.isBillDefault == 1, orElse: () => Address());
        _useShippingAddress =
            _billingAddress.id.isEmpty || _billingAddress == _shippingAddress;
      },
      builder: (ctx, viewModel) => Scaffold(
        appBar: AppBar(
          title: Text('My Order'),
          elevation: 0,
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            // 触摸收起键盘
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OrderDetailsExpansionTile(
                      context: context, model: viewModel.orderDetail),
                  _buildAddressList(viewModel),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextButton(
              onPressed: viewModel.orderDetail.canOrder &&
                      _shippingAddress.id.isNotEmpty &&
                      _billingAddress.id.isNotEmpty
                  ? () {
                      viewModel.onTapPay(_shippingAddress, _billingAddress);
                    }
                  : null,
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

  _buildAddressList(_ViewModel viewModel) {
    final addresses = viewModel.orderDetail.addresses;
    if (addresses.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
        ),
        child: _buildAddressForm(viewModel, true),
      );
    }

    return Column(
      children: [
        _buildShippingAddessView(
          viewModel,
          addresses,
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                  activeColor: AppTheme.colorED8514,
                  value: _useShippingAddress,
                  onChanged: (newValue) {
                    setState(() {
                      _useShippingAddress = !_useShippingAddress;
                      if (_useShippingAddress) {
                        _billingAddress = _shippingAddress;
                      } else {
                        _billingAddress = viewModel.billingDefaultAddress;
                      }
                    });
                  }),
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              'Set as billing address',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.color555764,
              ),
            )
          ],
        ),
        _useShippingAddress
            ? Container()
            : _buildBillingAddessView(viewModel, addresses)
      ],
    );
  }

  _buildShippingAddessView(_ViewModel viewModel, List<Address> addresses) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: OrderStatusImageView(
              status: OrderStatus.shipping,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Text(
                'Shipping Address',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.color0F1015,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              addresses.isNotEmpty
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          _showShippingAddressForm = !_showShippingAddressForm;
                          if (_showShippingAddressForm) {
                            _showBillingAddressForm = false;
                          }
                        });
                      },
                      child: Container(
                        child: Icon(
                          _showShippingAddressForm ? Icons.remove : Icons.add,
                          size: 20,
                          color: AppTheme.colorFEAC1B,
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          _buildAddressTile(
            _shippingAddress,
            _shippingAddress.id == viewModel.shippingDefaultAddress.id,
            viewModel,
            (value) {
              setState(() {
                _shippingAddress = value;
              });
            },
          ),
          if (_showShippingAddressForm) _buildAddressForm(viewModel, true),
        ],
      ),
    );
  }

  _buildBillingAddessView(_ViewModel viewModel, List<Address> addresses) {
    final _titleView = Row(
      children: [
        Text(
          'Billing Address',
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.color0F1015,
            fontWeight: FontWeight.w600,
          ),
        ),
        Spacer(),
        _billingAddress.id.isNotEmpty
            ? InkWell(
                onTap: () {
                  setState(() {
                    _showBillingAddressForm = !_showBillingAddressForm;
                    if (_showBillingAddressForm) {
                      _showShippingAddressForm = false;
                    }
                  });
                },
                child: Container(
                  child: Icon(
                    _showBillingAddressForm ? Icons.remove : Icons.add,
                    size: 20,
                    color: AppTheme.colorFEAC1B,
                  ),
                ),
              )
            : Container(),
      ],
    );

    if (_billingAddress.id.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_titleView, _buildAddressForm(viewModel, false)],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleView,
          SizedBox(
            height: 10,
          ),
          _buildAddressTile(
            _billingAddress,
            _billingAddress.id == viewModel.billingDefaultAddress.id,
            viewModel,
            (value) {
              setState(() {
                _billingAddress = value;
              });
            },
          ),
          if (_showBillingAddressForm) _buildAddressForm(viewModel, false),
        ],
      ),
    );
  }

  _buildAddressTile(Address address, isDefault, _ViewModel viewModel,
      Function(Address) onChanged) {
    final activeColor = AppTheme.colorED8514;

    final textStyle = TextStyle(color: activeColor, fontSize: 12);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: activeColor, width: 1),
      ),
      child: Stack(
        children: [
          isDefault
              ? Positioned(
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(4),
                      ),
                      color: AppTheme.colorFEAC1B,
                    ),
                    padding: const EdgeInsets.all(4.0),
                    child: Text('Default',
                        style: textStyle.copyWith(color: Colors.white)),
                  ),
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${address.firstName} ${address.lastName}',
                        style: textStyle,
                      ),
                      Text(
                        address.addressLine1,
                        style: textStyle,
                      ),
                      Text(
                        address.addressLine1,
                        style: textStyle,
                      ),
                      Text(
                        '${address.city} ${address.province} ${address.country}  ${address.zipCode}',
                        style: textStyle,
                      ),
                    ],
                  ),
                ),
                TextButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (ctx) {
                            return AddressRadioList(
                              defaultAddress: address,
                              addresses: viewModel.orderDetail.addresses,
                              onChanged: onChanged,
                            );
                          });
                    },
                    child: Text(
                      'Change',
                      style: TextStyle(
                        // color: AppTheme.color0F1015,
                        fontSize: 12,
                      ),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildAddressForm(_ViewModel viewModel, bool isAddShipping) {
    return AddressForm(
        isEditShipping: isAddShipping,
        onAdded: () {
          FocusScope.of(context).requestFocus(FocusNode());
          viewModel.refreshData().then((value) {
            setState(() {
              _showShippingAddressForm = false;
              _showBillingAddressForm = false;
            });
          });
        });
  }
}

class AddressRadioList extends StatefulWidget {
  final Address defaultAddress;
  final List<Address> addresses;
  final Function(Address) onChanged;
  AddressRadioList(
      {Key key,
      @required this.defaultAddress,
      this.addresses = const [],
      this.onChanged})
      : super(key: key);

  @override
  _AddressRadioListState createState() => _AddressRadioListState();
}

class _AddressRadioListState extends State<AddressRadioList> {
  String _groupValue;

  @override
  void initState() {
    _groupValue = widget.defaultAddress?.id;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (ctx, i) {
                  final address = widget.addresses[i];
                  final activeColor = _groupValue == address.id
                      ? AppTheme.colorED8514
                      : AppTheme.color555764;

                  final textStyle = TextStyle(color: activeColor, fontSize: 12);
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: activeColor, width: 1),
                    ),
                    child: RadioListTile(
                        contentPadding: EdgeInsets.zero,
                        activeColor: AppTheme.colorED8514,
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${address.firstName} ${address.lastName}',
                              style: textStyle,
                            ),
                            Text(
                              address.addressLine1,
                              style: textStyle,
                            ),
                            Text(
                              address.addressLine1,
                              style: textStyle,
                            ),
                            Text(
                              '${address.city} ${address.province} ${address.country}  ${address.zipCode}',
                              style: textStyle,
                            ),
                          ],
                        ),
                        value: address.id,
                        groupValue: _groupValue,
                        onChanged: (value) {
                          setState(() {
                            _groupValue = value;
                          });
                        }),
                  );
                },
                separatorBuilder: (ctx, i) {
                  return SizedBox(
                    height: 10,
                  );
                },
                itemCount: widget.addresses.length),
          ),
          Container(
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
            child: TextButton(
              onPressed: () {
                final newValue = widget.addresses
                    .firstWhere((e) => e.id == _groupValue, orElse: null);
                if (newValue != null && widget.onChanged != null) {
                  widget.onChanged(newValue);
                }
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                  minimumSize: Size(44, 44),
                  backgroundColor: AppTheme.colorED8514),
              child: Text(
                'Done',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
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
      padding: const EdgeInsets.symmetric(vertical: 8),
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

class _ViewModel {
  final OrderDetail orderDetail;
  final Address shippingDefaultAddress;
  final Address billingDefaultAddress;
  final Future<dynamic> Function() refreshData;
  final Function(Address, Address) onTapPay;

  _ViewModel({
    this.orderDetail,
    this.shippingDefaultAddress,
    this.billingDefaultAddress,
    this.refreshData,
    this.onTapPay,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    final orderDetail = store.state.preOrder.orderDetail;
    final shippingAddress = orderDetail.addresses
        .firstWhere((e) => e.isDefault == 1, orElse: () => Address());
    final billingAddress = orderDetail.addresses
        .firstWhere((e) => e.isBillDefault == 1, orElse: () => Address());

    Future _refreshData() {
      final buyGoods = orderDetail.list
          .map((sku) => OrderParameters(
              idolGoodsId: sku.idolGoodsId,
              skuSpecIds: sku.skuSpecIds,
              number: sku.number))
          .toList();
      final completer = Completer();
      store.dispatch(PreOrderAction(buyGoods: buyGoods, completer: completer));
      return completer.future;
    }

    _onTapPay(Address shippingAddress, Address billingAddress) {
      EasyLoading.show();
      final completer = Completer();
      completer.future.then((value) {
        EasyLoading.dismiss();
        Keys.navigatorKey.currentState.pushNamed(Routes.payment,
            arguments: PaymentScreenParams(shippingAddress, value['id']));
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
      store.dispatch(OrderAction(
          buyGoods, shippingAddress.id, billingAddress.id, completer));
    }

    return _ViewModel(
      orderDetail: orderDetail,
      shippingDefaultAddress: shippingAddress,
      billingDefaultAddress: billingAddress,
      refreshData: _refreshData,
      onTapPay: _onTapPay,
    );
  }
}
