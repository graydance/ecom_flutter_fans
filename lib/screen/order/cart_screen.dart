import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fans/app.dart';
import 'package:fans/screen/components/customize_textfield.dart';
import 'package:fans/screen/components/default_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:fans/models/models.dart';
import 'package:fans/r.g.dart';
import 'package:fans/screen/components/quantity_editing_button.dart';
import 'package:fans/screen/order/pre_order_screen.dart';
import 'package:fans/store/actions.dart';
import 'package:fans/theme.dart';
import 'package:throttling/throttling.dart';

class CartScreen extends StatefulWidget {
  CartScreen({Key key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _controller = MultiSelectController();

  Map<String, int> _itemQuantities = {};

  String _subtotal = '';
  String _total = '';

  final _debouncing = Debouncing();

  @override
  void dispose() {
    _debouncing.dispose();
    EasyLoading.dismiss();
    super.dispose();
  }

  _onQuantityChanged(BuildContext context, int quantity, OrderSku item,
      _ViewModel viewModel) async {
    _itemQuantities[item.id] = quantity * item.currentPrice;
    final sum =
        _itemQuantities.values.reduce((value, element) => value + element);
    setState(() {
      _subtotal = viewModel.currency + (sum / 100.0).toStringAsFixed(2);
      _total = viewModel.currency +
          ((sum + viewModel.cart.taxes) / 100.0).toStringAsFixed(2);
    });

    List<OrderSku> list = List.from(viewModel.cart.list);
    list[list.indexWhere((e) => e.id == item.id)] =
        item.copyWith(number: quantity);
    final updateAction =
        OnUpdateCartAction(viewModel.cart.copyWith(list: list));
    StoreProvider.of<AppState>(context).dispatch(updateAction);

    final completer = Completer();
    _debouncing.debounce(() {
      final action = UpdateCartAction(
          OrderParameter(
              idolGoodsId: item.idolGoodsId,
              skuSpecIds: item.skuSpecIds,
              number: quantity),
          completer);
      StoreProvider.of<AppState>(context).dispatch(action);
      // Future.delayed(Duration(seconds: 1))
      //     .then((value) => completer.complete());
    });
    await completer.future;
  }

  _onTapToolBarRemove() async {
    if (_controller.selectedIds.isEmpty) return;

    final params = _controller.list
        .where((e) => _controller.selectedIds.contains(e.id))
        .toList();

    await _deleteCarts(params);
  }

  _deleteCarts(List<OrderSku> list) async {
    EasyLoading.show();

    final params = list
        .map((item) => OrderParameter(
              idolGoodsId: item.idolGoodsId,
              skuSpecIds: item.skuSpecIds,
            ))
        .toList();
    final completer = Completer();
    final action = DeleteCartAction(params, completer);
    StoreProvider.of<AppState>(context).dispatch(action);

    try {
      await completer.future;
      EasyLoading.dismiss();
    } catch (error) {
      EasyLoading.dismiss();
      EasyLoading.showToast(error.toString());
    }
  }

  _updateData(_ViewModel viewModel) {
    _itemQuantities = Map.fromIterable(viewModel.cart.list,
        key: (e) => e.id, value: (e) => e.number * e.currentPrice);

    _controller.setList(viewModel.cart.list);
  }

  _editCustomiz(OrderSku model, String customiz) async {
    EasyLoading.show();

    final completer = Completer();
    final action = EditCustomizAction(
        model.cartItemId, model.isCustomiz, customiz, completer);
    StoreProvider.of<AppState>(context).dispatch(action);

    try {
      await completer.future;
      EasyLoading.dismiss();
    } catch (error) {
      EasyLoading.dismiss();
      EasyLoading.showToast(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      onDidChange: _updateData,
      builder: (ctx, viewModel) => Scaffold(
        appBar: AppBar(
          title: Text(viewModel.title),
          elevation: 0,
          actions: viewModel.cart.list.isEmpty
              ? []
              : [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _controller.isSelecting = !_controller.isSelecting;
                        });
                      },
                      child: Text(
                        _controller.isSelecting ? 'Done' : 'Manage',
                        style: TextStyle(
                          color: AppTheme.colorED8514,
                          fontSize: 12,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        side: BorderSide(color: AppTheme.colorED8514),
                      ),
                    ),
                  ),
                ],
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: EasyRefresh(
            onRefresh: () async {
              final completer = Completer();
              StoreProvider.of<AppState>(context)
                  .dispatch(FetchCartListAction(completer));

              final Cart cart = await completer.future;
              setState(() {
                _subtotal = viewModel.currency + cart.subtotalStr;
                _total = viewModel.currency + cart.totalStr;
              });
            },
            firstRefresh: true,
            firstRefreshWidget: Center(
              child: CircularProgressIndicator(),
            ),
            emptyWidget: viewModel.cart.list.isEmpty ? CartEmptyView() : null,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: 20,
                      );
                    },
                    shrinkWrap: true,
                    itemBuilder: (ctx, i) {
                      final item = viewModel.cart.list[i];
                      if (_controller.isSelecting) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleCheckBox(
                                value: _controller.isSelected(item.id),
                                onChanged: (value) {
                                  setState(() {
                                    _controller.toggle(item.id);
                                  });
                                }),
                            SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: CartItemTile(
                                currency: viewModel.currency,
                                item: item,
                                isShowMenu: !_controller.isSelecting,
                                textFieldController:
                                    TextEditingController(text: item.customiz),
                                onQuantityChanged: (quantity, item) async {
                                  await _onQuantityChanged(
                                      context, quantity, item, viewModel);
                                },
                                onTapRemove: (item) {
                                  _deleteCarts([item]);
                                },
                                onUpdateCustomiz: _editCustomiz,
                              ),
                            ),
                          ],
                        );
                      }
                      return CartItemTile(
                        currency: viewModel.currency,
                        item: item,
                        isShowMenu: !_controller.isSelecting,
                        textFieldController:
                            TextEditingController(text: item.customiz),
                        onQuantityChanged: (quantity, item) async {
                          await _onQuantityChanged(
                              context, quantity, item, viewModel);
                        },
                        onTapRemove: (item) {
                          _deleteCarts([item]);
                        },
                        onUpdateCustomiz: _editCustomiz,
                      );
                    },
                    itemCount: viewModel.cart.list.length,
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom + 20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (viewModel.cart.list.isNotEmpty && !_controller.isSelecting)
                  _buildSummary(_subtotal, viewModel.cart.shipping,
                      viewModel.currency + viewModel.cart.taxesStr, _total),
                if (_controller.isSelecting)
                  EditingToolBar(
                    isSelectAll: _controller.isSelectedAll,
                    onTapSelectAll: (value) {
                      setState(() {
                        if (value) {
                          _controller.selectAll();
                        } else {
                          _controller.deselectAll();
                        }
                      });
                    },
                    onTapRemove: () async {
                      await _onTapToolBarRemove();
                    },
                  ),
                if (viewModel.cart.list.isNotEmpty && !_controller.isSelecting)
                  FansButton(
                    onPressed: viewModel.cart.list.isNotEmpty
                        ? () {
                            viewModel.onCheckout(viewModel.cart.list);
                          }
                        : null,
                    isDisable: viewModel.cart.list.isEmpty,
                    title: 'Check out',
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildSummary(
      String subtotal, String shipping, String taxesStr, String totalStr) {
    return Column(
      children: [
        SizedBox(
          height: 12,
        ),
        OrderPriceTile(
          leading: 'Subtotal',
          trailing: subtotal,
        ),
        OrderPriceTile(
          leading: 'Shipping',
          trailing: shipping,
        ),
        OrderPriceTile(
          leading: 'Taxes',
          trailing: taxesStr,
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
            totalStr,
            style: TextStyle(
              color: AppTheme.color0F1015,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }
}

class CartItemTile extends StatelessWidget {
  final String currency;
  final OrderSku item;
  final bool isShowMenu;
  final TextEditingController textFieldController;
  final Function(int quantity, OrderSku item) onQuantityChanged;
  final Function(OrderSku item) onTapRemove;
  final Function(OrderSku item, String customiz) onUpdateCustomiz;

  CartItemTile({
    Key key,
    @required this.currency,
    @required this.item,
    @required this.isShowMenu,
    this.textFieldController,
    this.onQuantityChanged,
    this.onTapRemove,
    this.onUpdateCustomiz,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String error = item.isStockEnough ? '' : '* Out of stock';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
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
                    '$currency${item.currentPriceStr}',
                    style: TextStyle(
                      color: AppTheme.color0F1015,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  QuantityEditingButton(
                    style: QuantityEditingButtonStyle.small,
                    quantity: item.number,
                    max: item.stock,
                    onChanged: (value) {
                      if (onQuantityChanged != null)
                        onQuantityChanged(value, item);
                    },
                  ),
                  Text(
                    error,
                    style: TextStyle(
                      fontSize: 10,
                      color: AppTheme.colorED3544,
                    ),
                  ),
                ],
              ),
            ),
            if (isShowMenu)
              PopupMenuButton(
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                      value: item,
                      child: Text(
                        'Remove',
                        style: TextStyle(fontSize: 14),
                      )),
                ],
                onSelected: (value) {
                  if (onTapRemove != null) onTapRemove(value);
                },
                iconSize: 20,
                padding: EdgeInsets.zero,
              )
          ],
        ),
        if (item.isCustomiz == 1)
          SizedBox(
            height: 8,
          ),
        if (item.isCustomiz == 1)
          GestureDetector(
            onTap: () => _showCustomizInputDialog(context, item),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: AppTheme.colorEDEEF0,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Customiz:',
                            style: TextStyle(
                              color: AppTheme.color555764,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            item.customiz,
                            style: TextStyle(
                              color: AppTheme.color555764,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Edit',
                        style: TextStyle(
                          color: AppTheme.colorED8514,
                          fontSize: 12,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Future _showCustomizInputDialog(BuildContext context, OrderSku model) async {
    return showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            contentPadding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    alignment: Alignment.topRight,
                    padding: EdgeInsets.only(top: 12),
                    child: Icon(
                      Icons.clear,
                      color: Color(0xFFC4C5CD),
                      size: 16,
                    ),
                  ),
                ),
                Text(
                  'Customiz',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.color0F1015,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                CustomizeTextField(controller: textFieldController),
                SizedBox(
                  height: 16,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: FansButton(
                      title: "Update",
                      onPressed: () {
                        if (textFieldController.text.trim().isEmpty ||
                            textFieldController.text.length > 10) {
                          return;
                        }
                        if (onUpdateCustomiz != null) {
                          onUpdateCustomiz(
                            model,
                            textFieldController.text,
                          );
                        }
                        Navigator.pop(context);
                      }),
                ),
              ],
            ),
          );
        });
  }
}

class CircleCheckBox extends StatelessWidget {
  final bool value;
  final Function(bool) onChanged;

  const CircleCheckBox({Key key, this.value, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onChanged != null) onChanged(!value);
      },
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: value ? AppTheme.colorFEAC1B : AppTheme.colorE7E8EC),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Icon(
            Icons.check,
            size: 12.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class EditingToolBar extends StatefulWidget {
  final bool isSelectAll;
  final Function(bool) onTapSelectAll;
  final VoidCallback onTapRemove;

  EditingToolBar(
      {Key key,
      this.isSelectAll = false,
      this.onTapSelectAll,
      this.onTapRemove})
      : super(key: key);

  @override
  _EditingToolBarState createState() => _EditingToolBarState();
}

class _EditingToolBarState extends State<EditingToolBar> {
  final _textStyle = TextStyle(
    fontSize: 12,
    color: AppTheme.color555764,
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleCheckBox(
                value: widget.isSelectAll,
                onChanged: widget.onTapSelectAll,
              ),
              SizedBox(
                width: 4,
              ),
              Text('Select All', style: _textStyle),
            ],
          ),
          // TextButton.icon(
          //   onPressed: () {},
          //   icon: Icon(
          //     Icons.favorite,
          //     color: AppTheme.colorED3544,
          //     size: 20,
          //   ),
          //   label: Text(
          //     'Save for later',
          //     style: _textStyle,
          //   ),
          // ),
          TextButton(
            onPressed: () {
              if (widget.onTapRemove != null) widget.onTapRemove();
            },
            child: Text('Remove', style: _textStyle),
          ),
        ],
      ),
    );
  }
}

class CartEmptyView extends StatelessWidget {
  const CartEmptyView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Image(
              image: R.image.cart_empty(),
            ),
            Text(
              'Your cart is currently empty',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.color0F1015,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 40,
            ),
            if (Keys.navigatorKey.currentState.canPop())
              TextButton(
                onPressed: () {
                  Keys.navigatorKey.currentState.pop();
                },
                child: Text(
                  'Shop now',
                  style: TextStyle(color: Colors.white),
                ),
                style: TextButton.styleFrom(
                  minimumSize: Size(44, 44),
                  backgroundColor: AppTheme.colorED8514,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ViewModel {
  final String currency;
  final Cart cart;
  final String title;
  final Function(List<OrderSku>) onCheckout;

  _ViewModel({this.currency, this.cart, this.title, this.onCheckout});

  static _ViewModel fromStore(Store<AppState> store) {
    final currency = store.state.auth.user.monetaryUnit;
    final cart = store.state.cart;
    final title =
        'My Cart' + (cart.list.isEmpty ? '' : '(${cart.list.length})');

    _onCheckout(List<OrderSku> list) {
      EasyLoading.show();
      final completer = Completer();
      completer.future.then((value) {
        EasyLoading.dismiss();
        Keys.navigatorKey.currentState
            .pushNamed(Routes.preOrderMVP, arguments: value);
      }).catchError((error) {
        EasyLoading.dismiss();
        EasyLoading.showToast(error.toString());
      });

      final action = PreOrderAction(
        buyGoods: list
            .map((e) => OrderParameter(
                  idolGoodsId: e.idolGoodsId,
                  skuSpecIds: e.skuSpecIds,
                  number: e.number,
                  isCustomiz: e.isCustomiz,
                  customiz: e.customiz,
                ))
            .toList(),
        completer: completer,
      );

      store.dispatch(action);
    }

    return _ViewModel(
        currency: currency, cart: cart, title: title, onCheckout: _onCheckout);
  }
}

class MultiSelectController {
  Set<String> selectedIds = {};
  bool isSelecting = false;
  bool isSelectedAll = false;
  List<OrderSku> list = [];

  setList(List<OrderSku> items) {
    list = items;
    selectedIds =
        items.where((e) => selectedIds.contains(e.id)).map((e) => e.id).toSet();
  }

  /// Returns true if the id is selected
  bool isSelected(String id) {
    return selectedIds.contains(id);
  }

  void checkSelectAll() {
    isSelectedAll = selectedIds.length == list.length;
  }

  /// Toggle all select.
  /// If there are some that not selected, it will select all.
  /// If not, it will deselect all.
  void toggleAll() {
    if (selectedIds.length == list.length) {
      deselectAll();
    } else {
      selectAll();
    }

    checkSelectAll();
  }

  /// Select all
  void selectAll() {
    selectedIds = list.map((e) => e.id).toSet();
    checkSelectAll();
  }

  /// Deselect all
  void deselectAll() {
    selectedIds.clear();
    checkSelectAll();
  }

  /// Toggle at index
  void toggle(String id) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
    checkSelectAll();
  }

  /// Select at index
  void select(String id) {
    if (!selectedIds.contains(id)) {
      selectedIds.add(id);
      checkSelectAll();
    }
  }

  /// Deselect at index
  void deselect(String id) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
      checkSelectAll();
    }
  }
}
