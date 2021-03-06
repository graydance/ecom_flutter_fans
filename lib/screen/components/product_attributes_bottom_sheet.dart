import 'package:cached_network_image/cached_network_image.dart';
import 'package:fans/screen/components/customize_textfield.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:photo_view/photo_view.dart';

import 'package:fans/models/goods_skus.dart';
import 'package:fans/models/models.dart';
import 'package:fans/models/spec_values.dart';
import 'package:fans/r.g.dart';
import 'package:fans/screen/components/default_button.dart';
import 'package:fans/screen/components/quantity_editing_button.dart';
import 'package:fans/screen/components/radio_grouped_buttons.dart/radio_grouped_buttons.dart';
import 'package:fans/theme.dart';

class ProductAttributesBottomSheet extends StatefulWidget {
  final ProductAttributesViewModel viewModel;
  ProductAttributesBottomSheet({Key key, @required this.viewModel})
      : super(key: key);

  @override
  _ProductAttributesBottomSheetState createState() =>
      _ProductAttributesBottomSheetState();
}

class _ProductAttributesBottomSheetState
    extends State<ProductAttributesBottomSheet> {
  GoodsSkus _currentSku;
  List<GoodsSkus> _stockNotEnoughSkuList;
  List<int> _selectionSpecIds;
  List<List<int>> _disableSpecIds;
  List<int> _selectionSpecIndexs = [];

  bool _isCustomiz = true;
  final _customizController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.viewModel.selectedSku != null) {
      _selectionSpecIds = widget.viewModel.selectedSku.skuSpecIds
          .split('_')
          .map((e) => int.tryParse(e) ?? 0)
          .toList();

      _currentSku = widget.viewModel.selectedSku;

      final specList = widget.viewModel.model.specList;
      _selectionSpecIndexs = List.generate(specList.length, (index) => 0);
      for (int i = 0; i < specList.length; i++) {
        debugPrint(
            '_selectionSpecIndexs >>> ${_selectionSpecIds[i]} index >>> $i');

        _selectionSpecIndexs[i] = specList[i]
            .specValues
            .indexWhere((e) => e.id == _selectionSpecIds[i]);
      }
    } else {
      _selectionSpecIds = List.generate(
          widget.viewModel.model.specList.length,
          (index) =>
              widget.viewModel.model.specList[index].specValues.first.id ?? 0);

      final skus = widget.viewModel.model.goodsSkus;
      _currentSku = skus.firstWhere(
          (element) => element.skuSpecIds == _selectionSpecIds.join('_'),
          orElse: () => skus.first);

      _selectionSpecIndexs =
          List.generate(widget.viewModel.model.specList.length, (index) => 0);
    }

    _disableSpecIds =
        List.generate(widget.viewModel.model.specList.length, (index) => []);

    _stockNotEnoughSkuList = widget.viewModel.model.goodsSkus
        .where((element) => element.stock == 0)
        .toList();

    super.initState();
  }

  List<List<int>> _getDisableSpecIds(int index, SpecValues selectedItem) {
    var specList = widget.viewModel.model.specList;

    List<List<int>> stockNotEnoughSpecIds =
        List.generate(specList.length, (index) => []);
    _stockNotEnoughSkuList.forEach((e) {
      List<String> skuSpecIds = e.skuSpecIds.split('_');
      if (skuSpecIds[index] == selectedItem.id.toString()) {
        for (int i = 0; i < skuSpecIds.length; i++) {
          if (i != index) {
            stockNotEnoughSpecIds[i].add(int.parse(skuSpecIds[i]));
          }
        }
      }
    });
    return stockNotEnoughSpecIds;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: Duration(milliseconds: 250),
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 触摸收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              shrinkWrap: true,
              children: [
                _titleBar(context, widget.viewModel.model,
                    widget.viewModel.currency, _currentSku),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Choose your specifications:',
                  style: TextStyle(
                    color: AppTheme.color979AA9,
                    fontSize: 12,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.5,
                  ),
                  child: ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (ctx, i) {
                        final model = widget.viewModel.model.specList[i];
                        final initialSelection = _selectionSpecIndexs[i];
                        debugPrint('initialSelection >>> $initialSelection');

                        return SpecItem(
                          model: model,
                          disableIds: _disableSpecIds[i],
                          initialSelection:
                              initialSelection < 0 ? 0 : initialSelection,
                          valueChanged: (selectedItem, index) {
                            debugPrint(
                                'onSpecChanged >>> ${selectedItem.toString()} index >>> $index');
                            _selectionSpecIds[i] = selectedItem.id;
                            _selectionSpecIndexs[i] = index;

                            final sku = widget.viewModel.model.goodsSkus
                                .firstWhere(
                                    (element) =>
                                        element.skuSpecIds ==
                                        _selectionSpecIds.join('_'),
                                    orElse: () => GoodsSkus());

                            final disableSpecIds =
                                _getDisableSpecIds(i, selectedItem);

                            setState(() {
                              _currentSku = sku;
                              _disableSpecIds = disableSpecIds;
                            });

                            if (widget.viewModel.onSkuChanged != null) {
                              widget.viewModel.onSkuChanged(_currentSku);
                            }
                          },
                        );
                      },
                      separatorBuilder: (ctx, index) {
                        return SizedBox(
                          height: 20,
                        );
                      },
                      itemCount: widget.viewModel.model.specList.length),
                ),
                SizedBox(
                  height: 20,
                ),
                QuantityEditingButton(
                  min: 1,
                  max: _currentSku.stock,
                  quantity: widget.viewModel.quantity,
                  onChanged: widget.viewModel.onQuantityChange,
                ),
                if (widget.viewModel.model.isCustomiz == 1) _customizView(),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: FansButton(
                    onPressed: () {
                      if (_currentSku.stock == 0) {
                        return;
                      }

                      if (widget.viewModel.model.isCustomiz == 1 &&
                          _isCustomiz) {
                        if (!_formKey.currentState.validate()) {
                          return;
                        }
                      }

                      Navigator.of(context).pop();
                      widget.viewModel.onTapAction(
                        _currentSku.skuSpecIds,
                        _isCustomiz,
                        _customizController.text ?? '',
                      );
                    },
                    title: _currentSku.stock == 0
                        ? 'Out of stock'
                        : widget.viewModel.actionType.displayTitle,
                    isDisable: _currentSku.stock == 0,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _customizView() {
    return Column(
      children: [
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
                  value: _isCustomiz,
                  onChanged: (newValue) {
                    setState(() {
                      _isCustomiz = !_isCustomiz;
                    });
                  }),
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              'Customiz',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.color0F1015,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
        if (_isCustomiz)
          SizedBox(
            height: 8,
          ),
        if (_isCustomiz)
          Form(
            child: CustomizeTextField(
              formKey: _formKey,
              controller: _customizController,
            ),
          ),
      ],
    );
  }

  Widget _titleBar(
      BuildContext context, Product model, String currency, GoodsSkus sku) {
    return Container(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 8,
            right: -14,
            child: SizedBox(
              height: 30,
              width: 30,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  primary: AppTheme.colorC4C5CD,
                  padding: EdgeInsets.all(1),
                ),
                child: Image(
                  image: R.image.icon_close(),
                  width: 20,
                ),
              ),
            ),
          ),
          Positioned(
            top: -30,
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      child: Container(
                        child: PhotoView(
                          tightMode: true,
                          imageProvider: NetworkImage(sku.skuImage),
                          heroAttributes: PhotoViewHeroAttributes(tag: sku.id),
                        ),
                      ),
                    );
                  },
                );
              },
              child: SizedBox(
                height: 110,
                width: 110,
                child: Stack(
                  children: [
                    Hero(tag: sku.id, child: FansImageView(url: sku.skuImage)),
                    Positioned(
                      right: 4,
                      bottom: 4,
                      child: Image(
                        image: R.image.product_search(),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 120,
              right: 20,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          model.productName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff0F1015),
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '$currency${sku.currentPriceStr}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff0F1015),
                              ),
                            ),
                            SizedBox(width: 2),
                            Text(
                              '$currency${sku.originalPriceStr}',
                              style: TextStyle(
                                color: Color(0xff979AA9),
                                fontSize: 12,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                      ],
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
}

class SpecItem extends StatelessWidget {
  final GoodsSpec model;
  final List<int> disableIds;
  final int initialSelection;
  final Function(SpecValues, int) valueChanged;

  const SpecItem(
      {Key key,
      this.model,
      this.disableIds = const [],
      this.initialSelection = 0,
      this.valueChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          model.specName,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.color0F1015,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        CustomRadioButton(
          initialSelection: initialSelection,
          buttonLables: model.specValues.map((e) => e.specValue).toList(),
          buttonValues: model.specValues.map((e) => e.id).toList(),
          disableButtonValues: disableIds,
          radioButtonValue: (value, index) {
            if (valueChanged != null) {
              valueChanged(model.specValues[index], index);
            }
          },
          horizontal: true,
          enableShape: true,
          buttonSpace: 8,
          lineSpace: 8,
          buttonColor: Colors.white,
          selectedColor: AppTheme.colorFEAC1B,
          buttonBorderColor: AppTheme.colorFEAC1B,
          unselectedButtonBorderColor: AppTheme.color979AA9,
          buttonHeight: 40,
          fontSize: 12,
          elevation: 0,
        ),
      ],
    );
  }
}

class FansImageView extends StatelessWidget {
  const FansImageView({
    Key key,
    @required this.url,
  }) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4.0),
      child: Container(
        color: AppTheme.colorF4F4F4,
        child: CachedNetworkImage(
          placeholder: (context, _) => Image(
            image: R.image.goods_placeholder(),
            fit: BoxFit.cover,
          ),
          imageUrl: url,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class FloatingModal extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;

  const FloatingModal({Key key, @required this.child, this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Material(
        color: backgroundColor,
        clipBehavior: Clip.none,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        child: child,
      ),
    );
  }
}

Future showProductAttributesBottomSheet(
    BuildContext context, ProductAttributesViewModel viewModel) {
  return showCustomModalBottomSheet(
      context: context,
      builder: (context) => ProductAttributesBottomSheet(viewModel: viewModel),
      containerWidget: (_, animation, child) => FloatingModal(
            child: child,
          ),
      expand: false,
      isDismissible: true);
}

enum ProductAttributesActionType { addToCart, buyNow }

extension ProductAttributesActionTypeExt on ProductAttributesActionType {
  // ignore: missing_return
  String get displayTitle {
    switch (this) {
      case ProductAttributesActionType.addToCart:
        return 'Add to cart';
      case ProductAttributesActionType.buyNow:
        return 'Buy now';
    }
  }
}

class ProductAttributesViewModel {
  final String currency;
  final Product model;
  final int quantity;
  final GoodsSkus selectedSku;
  final ProductAttributesActionType actionType;
  final Function(int) onQuantityChange;
  final Function(GoodsSkus) onSkuChanged;
  final Function(String, bool, String) onTapAction;

  ProductAttributesViewModel({
    @required this.currency,
    @required this.model,
    @required this.quantity,
    @required this.selectedSku,
    @required this.actionType,
    @required this.onQuantityChange,
    @required this.onSkuChanged,
    @required this.onTapAction,
  });
}
