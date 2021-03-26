import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:fans/app.dart';
import 'package:fans/models/address.dart';
import 'package:fans/models/models.dart';
import 'package:fans/models/order_detail.dart';
import 'package:fans/models/order_sku.dart';
import 'package:fans/screen/components/address_form.dart';
import 'package:fans/screen/components/default_button.dart';
import 'package:fans/screen/components/order_status_image_view.dart';
import 'package:fans/screen/order/payment_screen.dart';
import 'package:fans/store/actions.dart';
import 'package:fans/theme.dart';
import 'package:fans/utils/list_extension.dart';
import 'package:fans/utils/validator.dart';

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
  String _couponCode = '';
  Coupon _coupon;

  final _emailController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    EasyLoading.dismiss();
  }

  _bindAddress(OrderDetail orderDetail) {
    if (_shippingAddress != null && _shippingAddress.id.isNotEmpty) return;

    _shippingAddress = orderDetail.addresses
        .firstWhere((e) => e.isDefault == 1, orElse: () => null);
    if (_shippingAddress == null) {
      _shippingAddress = orderDetail.addresses.firstOrNull() ?? Address();
    }
    _billingAddress = orderDetail.addresses
        .firstWhere((e) => e.isBillDefault == 1, orElse: () => null);
    if (_billingAddress == null) {
      _billingAddress = orderDetail.addresses.firstOrNull() ?? Address();
    }
    _useShippingAddress =
        _billingAddress.id.isEmpty || _billingAddress == _shippingAddress;
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      onInit: (store) {
        _bindAddress(store.state.preOrder.orderDetail);
      },
      onDidChange: (viewModel) {
        _bindAddress(viewModel.orderDetail);

        setState(() {});
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
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OrderDetailsExpansionTile(
                    currency: viewModel.currency,
                    context: context,
                    model: viewModel.orderDetail,
                    canAddCoupon: true,
                    coupon: _coupon,
                    couponCode: _couponCode ?? '',
                    onAddCouponCode: (code, coupon) {
                      setState(() {
                        _couponCode = code;
                        _coupon = coupon;
                      });
                    },
                  ),
                  if (viewModel.isAnonymous) _buildEmail(),
                  _buildAddressList(viewModel),
                  Container(
                    padding: EdgeInsets.only(
                        top: 20,
                        bottom: MediaQuery.of(context).padding.bottom + 20),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: FansButton(
                        onPressed: _shippingAddress.id.isNotEmpty &&
                                _billingAddress.id.isNotEmpty
                            ? () {
                                if (!viewModel.orderDetail.canOrder) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: const Text('Out of stock'),
                                    duration: const Duration(seconds: 2),
                                  ));
                                  return;
                                }
                                if (viewModel.isAnonymous &&
                                    !validateEmail(_emailController.text)) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: const Text('The email is invalid'),
                                    duration: const Duration(seconds: 2),
                                  ));
                                  return;
                                }

                                viewModel.onTapPay(
                                    _shippingAddress,
                                    _billingAddress,
                                    _emailController.text ?? '',
                                    _couponCode ?? '',
                                    _coupon);
                              }
                            : null,
                        title: 'Continue to payment',
                        isDisable: _shippingAddress.id.isEmpty ||
                            _billingAddress.id.isEmpty,
                      ),
                    ),
                  ),
                ],
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
                        _scrollToBottom();
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
                            _scrollToBottom();
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
            _shippingAddress.id == viewModel.shippingDefaultAddress.id &&
                viewModel.shippingDefaultAddress.id.isNotEmpty,
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
                      _scrollToBottom();
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
            _billingAddress.id == viewModel.billingDefaultAddress.id &&
                viewModel.billingDefaultAddress.id.isNotEmpty,
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

  _scrollToBottom() {
    Timer(
        Duration(milliseconds: 100),
        () => _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 300),
            ));
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 8,
        ),
        Text(
          isAddShipping ? 'Shipping Address' : 'Billing Address',
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.color0F1015,
            fontWeight: FontWeight.w600,
          ),
        ),
        AddressForm(
            isEditShipping: isAddShipping,
            countries: viewModel.config.country,
            onAdded: () {
              FocusScope.of(context).requestFocus(FocusNode());
              viewModel.refreshData().then((value) {
                setState(() {
                  _showShippingAddressForm = false;
                  _showBillingAddressForm = false;
                });
              });
            }),
      ],
    );
  }

  _buildEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),
        Text(
          'Email',
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.color0F1015,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            hintText: 'Enter your email*',
            hintStyle: TextStyle(fontSize: 14.0, color: AppTheme.colorC4C5CD),
            labelStyle: TextStyle(fontSize: 14.0, color: AppTheme.color555764),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: AppTheme.colorC4C5CD),
              borderRadius: BorderRadius.circular(0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppTheme.colorC4C5CD),
              borderRadius: BorderRadius.circular(0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppTheme.colorC4C5CD),
              borderRadius: BorderRadius.circular(0),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppTheme.colorC4C5CD),
              borderRadius: BorderRadius.circular(0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppTheme.colorED3544),
              borderRadius: BorderRadius.circular(0),
            ),
            contentPadding: const EdgeInsets.all(12.0),
            isDense: true,
          ),
          controller: _emailController,
          validator: (value) => validateEmail(value) ? null : 'Invalid email',
        ),
        // SizedBox(
        //   height: 10,
        // ),
        // GestureDetector(
        //   onTap: () {
        //     Keys.navigatorKey.currentState.pushNamed(Routes.signin);
        //   },
        //   child: RichText(
        //     text: TextSpan(
        //       children: [
        //         TextSpan(
        //           text: 'I ready have a account ',
        //           style: TextStyle(
        //             color: AppTheme.color555764,
        //             fontSize: 12,
        //           ),
        //         ),
        //         TextSpan(
        //           text: 'Login',
        //           style: TextStyle(
        //             decoration: TextDecoration.underline,
        //             color: Colors.blue,
        //             fontSize: 12,
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
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
  final BuildContext context;
  final String currency;
  final OrderDetail model;
  final bool canAddCoupon;
  final Coupon coupon;
  final String couponCode;
  final Function(String, Coupon) onAddCouponCode;

  const OrderDetailsExpansionTile({
    Key key,
    @required this.context,
    @required this.currency,
    @required this.model,
    this.canAddCoupon = false,
    this.coupon,
    this.couponCode = '',
    this.onAddCouponCode,
  }) : super(key: key);

  @override
  _OrderDetailsExpansionTileState createState() =>
      _OrderDetailsExpansionTileState();
}

class _OrderDetailsExpansionTileState extends State<OrderDetailsExpansionTile> {
  bool _isExpanded = true;

  String _total;

  @override
  void initState() {
    super.initState();
    if (widget.coupon != null) {
      var price =
          ((widget.model.subtotal + widget.model.taxes - widget.coupon.amount) /
                  100.0)
              .toStringAsFixed(2);
      _total = '${widget.currency}$price';
    } else {
      _total = '${widget.currency}${widget.model.totalStr}';
    }
  }

  _updatePrice(Coupon coupon) {
    if (coupon == null) {
      setState(() {
        _total = '${widget.currency}${widget.model.totalStr}';
      });
      return;
    }

    var price =
        ((widget.model.subtotal + widget.model.taxes - coupon.amount) / 100.0)
            .toStringAsFixed(2);
    setState(() {
      _total = '${widget.currency}$price';
    });
  }

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
        trailing: Text('${widget.currency}${widget.model.totalStr}'),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 110,
                    width: 110,
                    child: CachedNetworkImage(
                      placeholder: (context, _) => Container(
                        color: AppTheme.colorEDEEF0,
                      ),
                      imageUrl: item.skuImage,
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
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          item.goodsName,
                          maxLines: 3,
                          style: TextStyle(
                            color: AppTheme.color0F1015,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          '${widget.currency}${item.currentPriceStr}',
                          style: TextStyle(
                            color: AppTheme.color0F1015,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          height: 6,
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
            trailing: '${widget.currency}${widget.model.subtotalStr}',
          ),
          OrderPriceTile(
            leading: 'Shipping',
            trailing: widget.model.shipping,
          ),
          OrderPriceTile(
            leading: 'Taxes',
            trailing: '${widget.currency}${widget.model.taxesStr}',
          ),
          if (widget.canAddCoupon ||
              (widget.canAddCoupon == false && widget.coupon != null))
            OrderCouponTile(
              model: widget.model,
              hasCoupon: widget.coupon != null,
              couponCode: widget.couponCode,
              couponValue:
                  '-${widget.currency}${widget.coupon?.amountStr ?? ''}',
              onAddCoupon: widget.canAddCoupon
                  ? (code, coupon) {
                      _updatePrice(coupon);
                      if (widget.onAddCouponCode != null) {
                        widget.onAddCouponCode(code, coupon);
                      }
                    }
                  : null,
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
              '$_total',
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

class OrderCouponTile extends StatefulWidget {
  final OrderDetail model;
  final bool hasCoupon;
  final String couponCode;
  final String couponValue;
  final Function(String, Coupon) onAddCoupon;

  const OrderCouponTile(
      {Key key,
      @required this.model,
      @required this.hasCoupon,
      this.couponCode,
      this.couponValue,
      this.onAddCoupon})
      : super(key: key);

  @override
  _OrderCouponTileState createState() => _OrderCouponTileState();
}

class _OrderCouponTileState extends State<OrderCouponTile> {
  TextEditingController _textFieldController = TextEditingController();

  @override
  void dispose() {
    _textFieldController.dispose();
    EasyLoading.dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle _titleStyle = TextStyle(
      color: AppTheme.color555764,
      fontSize: 14,
    );

    final leading = widget.hasCoupon ? 'Coupon code' : 'I have a coupon code';
    final trailingWidget = InkWell(
      onTap: widget.onAddCoupon != null
          ? () {
              _showCouponInputDialog(context, widget.model);
            }
          : null,
      child: Text(
        widget.hasCoupon ? widget.couponValue : '+ Add',
        style: TextStyle(
          color: AppTheme.color48B6EF,
          fontSize: 14,
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        Text(
          leading,
          style: _titleStyle,
        ),
        Spacer(),
        trailingWidget,
      ]),
    );
  }

  Future _showCouponInputDialog(BuildContext context, OrderDetail model) async {
    return showCupertinoDialog(
        context: context,
        builder: (ctx) {
          return CupertinoAlertDialog(
            title: Text('Coupon Code'),
            content: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(
                hintText: "Enter your coupon code",
                hintStyle:
                    TextStyle(fontSize: 14.0, color: AppTheme.colorC4C5CD),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.colorC4C5CD),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.colorC4C5CD),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.color0F1015),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  minimumSize: Size(44, 44),
                ),
                child: Text(
                  'Cancel',
                ),
              ),
              TextButton(
                onPressed: () {
                  _checkCoupon(model.subtotal + model.taxes);
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  minimumSize: Size(44, 44),
                ),
                child: Text(
                  'Apply',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          );
        });
  }

  _checkCoupon(int total) {
    final code = _textFieldController.text;
    EasyLoading.show();
    final completer = Completer();
    completer.future.then((value) {
      EasyLoading.dismiss();
      if (widget.onAddCoupon != null) {
        widget.onAddCoupon(code, value);
      }
    }).catchError((error) {
      EasyLoading.dismiss();
      EasyLoading.showToast(error.toString());
    });
    StoreProvider.of<AppState>(context)
        .dispatch(CheckCouponAction(code, total, completer));
  }
}

class _ViewModel {
  final bool isAnonymous;
  final String currency;
  final OrderDetail orderDetail;
  final Address shippingDefaultAddress;
  final Address billingDefaultAddress;
  final Config config;
  final Future<dynamic> Function() refreshData;
  final Function(Address, Address, String, String, Coupon) onTapPay;

  _ViewModel({
    this.isAnonymous,
    this.currency,
    this.orderDetail,
    this.shippingDefaultAddress,
    this.billingDefaultAddress,
    this.config,
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
          .map((sku) => OrderParameter(
              idolGoodsId: sku.idolGoodsId,
              skuSpecIds: sku.skuSpecIds,
              number: sku.number))
          .toList();
      final completer = Completer();
      store.dispatch(PreOrderAction(buyGoods: buyGoods, completer: completer));
      return completer.future;
    }

    _onTapPay(Address shippingAddress, Address billingAddress, String email,
        String code, Coupon coupon) {
      EasyLoading.show();
      final completer = Completer();
      completer.future.then((value) {
        EasyLoading.dismiss();
        Keys.navigatorKey.currentState.pushNamed(Routes.payment,
            arguments: PaymentScreenParams(
              shippingAddress,
              value['id'],
              value['number'],
              coupon,
              value['totalStr'],
            ));
      }).catchError((error) {
        EasyLoading.dismiss();
        EasyLoading.showToast(error.toString());
      });

      final buyGoods = orderDetail.list
          .map((sku) => OrderParameter(
                idolGoodsId: sku.idolGoodsId,
                skuSpecIds: sku.skuSpecIds,
                number: sku.number,
              ))
          .toList();
      store.dispatch(OrderAction(buyGoods, shippingAddress.id,
          billingAddress.id, email, code, completer));
    }

    if (store.state.config.country.isEmpty) {
      store.dispatch(FetchConfigAction());
    }

    return _ViewModel(
      isAnonymous: store.state.auth.user.isAnonymous == 1,
      currency: store.state.auth.user.monetaryUnit,
      orderDetail: orderDetail,
      shippingDefaultAddress: shippingAddress,
      billingDefaultAddress: billingAddress,
      config: store.state.config,
      refreshData: _refreshData,
      onTapPay: _onTapPay,
    );
  }
}
