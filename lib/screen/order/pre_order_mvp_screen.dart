import 'dart:async';

import 'package:fans/screen/components/order_status_image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:redux/redux.dart';

import 'package:fans/app.dart';
import 'package:fans/models/models.dart';
import 'package:fans/screen/components/address_form.dart';
import 'package:fans/screen/components/default_button.dart';
import 'package:fans/screen/order/payment_screen.dart';
import 'package:fans/screen/screens.dart';
import 'package:fans/store/actions.dart';
import 'package:fans/theme.dart';
import 'package:fans/utils/validator.dart';

class PreOrderMVPScreen extends StatefulWidget {
  PreOrderMVPScreen({Key key}) : super(key: key);

  @override
  _PreOrderMVPScreenState createState() => _PreOrderMVPScreenState();
}

class _PreOrderMVPScreenState extends State<PreOrderMVPScreen> {
  bool _useShippingAddress = true;
  String _couponCode = '';
  Coupon _coupon;

  final _emailController = TextEditingController();
  final _scrollController = ScrollController();

  final _shippingAddressController = AddressFormController();
  final _billingAddressController = AddressFormController();
  final _editingAddressController = AddressFormController();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (ctx, viewModel) => Scaffold(
        appBar: AppBar(
          title: Text('My Order'),
          elevation: 0,
          centerTitle: true,
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
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: OrderStatusImageView(
                      status: OrderStatus.shipping,
                    ),
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
                        onPressed: () {
                          if (!viewModel.orderDetail.canOrder) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text('Out of stock'),
                              duration: const Duration(seconds: 2),
                            ));
                            return;
                          }
                          if (viewModel.isAnonymous &&
                              !validateEmail(_emailController.text)) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text('The email is invalid'),
                              duration: const Duration(seconds: 2),
                            ));
                            return;
                          }

                          if (viewModel.isPreOrder) {
                            final shippingAddress =
                                _shippingAddressController.getAddress();
                            if (shippingAddress == null) {
                              return;
                            }
                            Address billingAddress = _useShippingAddress
                                ? shippingAddress
                                : _billingAddressController.getAddress();
                            if (billingAddress == null) {
                              return;
                            }
                            viewModel.onCheckout(
                                shippingAddress,
                                billingAddress,
                                _emailController.text ?? '',
                                _useShippingAddress,
                                _couponCode ?? '',
                                _coupon);
                          } else {
                            viewModel.onTapPay(_emailController.text ?? '',
                                _couponCode ?? '', _coupon);
                          }
                        },
                        title: viewModel.isPreOrder
                            ? 'Check out'
                            : 'Continue to payment',
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
        Text(
          'Please enter your email address to reveive order information.',
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.color0F1015,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            hintText: 'Enter your email',
            hintStyle: TextStyle(fontSize: 14.0, color: AppTheme.color979AA9),
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
      ],
    );
  }

  _buildAddressList(_ViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
      ),
      child: Column(
        children: [
          _buildAddressForm(viewModel, true, true),
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
                        if (!_useShippingAddress) {
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
          if (!_useShippingAddress) _buildAddressForm(viewModel, false, true),
        ],
      ),
    );
  }

  _buildAddressForm(_ViewModel viewModel, bool isAddShipping, bool showTitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 8,
        ),
        if (showTitle)
          Text(
            isAddShipping ? 'Shipping Address' : 'Billing Address',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.color0F1015,
              fontWeight: FontWeight.w600,
            ),
          ),
        AddressFormView(
          controller: isAddShipping
              ? _shippingAddressController
              : _billingAddressController,
          isShippingAddress: isAddShipping,
          countries: viewModel.config.country,
          address: isAddShipping
              ? viewModel.orderDetail.address
              : viewModel.orderDetail.billAddress,
          editingAddressController: _editingAddressController,
          onUpdateAddress: (isEditShipping, value) {
            viewModel.onUpdateAddress(isEditShipping, value);
          },
        ),
      ],
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
}

class AddressFormView extends StatelessWidget {
  final List<Country> countries;
  final bool isShippingAddress;
  final Address address;
  final AddressFormController controller;
  final AddressFormController editingAddressController;
  final Function(bool, Address) onUpdateAddress;

  AddressFormView({
    Key key,
    @required this.countries,
    @required this.isShippingAddress,
    @required this.controller,
    @required this.editingAddressController,
    this.onUpdateAddress,
    this.address,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return address == null
        ? AddressForm(
            countries: countries,
            controller: controller,
          )
        : Padding(
            padding: EdgeInsets.only(top: 8),
            child: _buildAddressTile(address, false, () {
              // show dialog
              showEditAddressBottomSheet(context);
            }),
          );
  }

  _buildAddressTile(Address address, isDefault, VoidCallback onTapChange) {
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
                  onPressed: onTapChange,
                  child: Text(
                    'Change',
                    style: TextStyle(
                      // color: AppTheme.color0F1015,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future showEditAddressBottomSheet(BuildContext buildContext) {
    return showBarModalBottomSheet(
        context: buildContext,
        builder: (context) {
          return AnimatedPadding(
            duration: Duration(milliseconds: 250),
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                // 触摸收起键盘
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      child: Text(
                        isShippingAddress
                            ? 'Shipping Address'
                            : 'Billing Address',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.color0F1015,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    AddressForm(
                      countries: countries,
                      address: address,
                      controller: editingAddressController,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 20,
                      ),
                      child: TextButton(
                        onPressed: () {
                          final newAddress =
                              editingAddressController.getAddress();
                          if (newAddress == null) return;

                          Navigator.of(context).pop();
                          if (onUpdateAddress != null) {
                            onUpdateAddress(isShippingAddress, newAddress);
                          }
                        },
                        child: Text(
                          // 'Set As Default',
                          'Confirm',
                          style: TextStyle(
                            color: AppTheme.colorED8514,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          side: BorderSide(color: AppTheme.colorED8514),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        expand: false,
        isDismissible: true);
  }
}

class _ViewModel {
  final bool isPreOrder;
  final bool isAnonymous;
  final String currency;
  final OrderDetail orderDetail;
  final Config config;
  final Function(Address, Address, String, bool, String, Coupon) onCheckout;
  final Function(String, String, Coupon) onTapPay;
  final Function(bool, Address) onUpdateAddress;

  _ViewModel({
    this.isPreOrder,
    this.isAnonymous,
    this.currency,
    this.orderDetail,
    this.config,
    this.onCheckout,
    this.onTapPay,
    this.onUpdateAddress,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    final orderDetail = store.state.preOrder.orderDetail;

    _onCheckout(Address shippingAddress, Address billingAddress, String email,
        bool isSame, String code, Coupon coupon) {
      EasyLoading.show();
      final buyGoods = orderDetail.list
          .map((sku) => OrderParameter(
              idolGoodsId: sku.idolGoodsId,
              skuSpecIds: sku.skuSpecIds,
              number: sku.number))
          .toList();
      final completer = Completer();
      completer.future.then((value) {
        EasyLoading.dismiss();
      }).catchError((error) {
        EasyLoading.dismiss();
        EasyLoading.showToast(error.toString());
      });
      store.dispatch(PreOrderNewAction(buyGoods, shippingAddress,
          billingAddress, email, isSame, code, completer));
    }

    _onTapPay(String email, String code, Coupon coupon) {
      Address shippingAddress = orderDetail.address;
      Address billingAddress = orderDetail.billAddress;

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

    _onUpdateAddress(bool isEditShippingAddress, Address address) {
      EasyLoading.show();
      final completer = Completer();
      completer.future.then((value) {
        EasyLoading.dismiss();
      }).catchError((error) {
        EasyLoading.dismiss();
        EasyLoading.showToast(error.toString());
      });

      store.dispatch(
          EditAddressAction(isEditShippingAddress, address, completer));
    }

    if (store.state.config.country.isEmpty) {
      store.dispatch(FetchConfigAction());
    }
    return _ViewModel(
      isPreOrder: orderDetail.address == null ||
          orderDetail.billAddress == null ||
          orderDetail.address.id.isEmpty ||
          orderDetail.billAddress.id.isEmpty,
      isAnonymous: store.state.auth.user.isAnonymous == 1,
      currency: store.state.auth.user.monetaryUnit,
      orderDetail: orderDetail,
      config: store.state.config,
      onCheckout: _onCheckout,
      onTapPay: _onTapPay,
      onUpdateAddress: _onUpdateAddress,
    );
  }
}
