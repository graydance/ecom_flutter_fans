import 'package:fans/models/models.dart';
import 'package:fans/networking/api.dart';
import 'package:fans/networking/networking.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fans/theme.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_picker/flutter_picker.dart';

class AddressForm extends StatefulWidget {
  final bool isEditShipping;
  final List<Country> countries;
  final VoidCallback onAdded;
  AddressForm({
    Key key,
    @required this.isEditShipping,
    @required this.countries,
    this.onAdded,
  }) : super(key: key);

  @override
  _AddressFormState createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _cityController = TextEditingController();
  final _provinceController = TextEditingController();
  final _countryController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  bool _loading = false;
  Country _selectedCountry = Country();
  String _selectedState = '';
  List<String> _states = [];

  @override
  Widget build(BuildContext context) {
    InputDecoration _commonInputDecoration(String hintText) {
      return InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 14.0, color: AppTheme.colorC4C5CD),
        labelText: hintText,
        labelStyle: TextStyle(fontSize: 14.0, color: AppTheme.color555764),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: AppTheme.colorC4C5CD),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppTheme.color0F1015),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppTheme.color0F1015),
        ),
        disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppTheme.color0F1015),
        ),
      );
    }

    final _textStyle = TextStyle(
      fontSize: 14,
    );

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: TextFormField(
                  decoration: _commonInputDecoration('First Name*'),
                  controller: _firstNameController,
                  validator: (value) => value.isEmpty ? '' : null,
                  style: _textStyle,
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: TextFormField(
                  decoration: _commonInputDecoration('Last Name'),
                  controller: _lastNameController,
                  validator: null,
                  style: _textStyle,
                ),
              )
            ],
          ),
          TextFormField(
            decoration: _commonInputDecoration('Address Line 1*'),
            controller: _addressLine1Controller,
            validator: (value) => value.isEmpty ? '' : null,
            style: _textStyle,
          ),
          TextFormField(
            decoration: _commonInputDecoration('Address Line 2'),
            controller: _addressLine2Controller,
            validator: null,
            style: _textStyle,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: TextFormField(
                  decoration: _commonInputDecoration('Zip Code*'),
                  controller: _zipCodeController,
                  validator: (value) => value.isEmpty ? '' : null,
                  style: _textStyle,
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: TextFormField(
                  decoration: _commonInputDecoration('City*'),
                  controller: _cityController,
                  validator: (value) => value.isEmpty ? '' : null,
                  style: _textStyle,
                ),
              )
            ],
          ),
          GestureDetector(
            onTap: () {
              _showPickerModal(context);
            },
            child: TextField(
              controller: _countryController,
              decoration: _commonInputDecoration('Country*').copyWith(
                suffixIcon: Icon(
                  Icons.arrow_drop_down_sharp,
                  color: AppTheme.color0F1015,
                ),
              ),
              enabled: false,
              style: _textStyle,
            ),
          ),
          if (_states.isNotEmpty)
            GestureDetector(
              onTap: () {
                _showStatesPickerModal(context);
              },
              child: TextField(
                controller: _provinceController,
                decoration: _commonInputDecoration('State*').copyWith(
                  suffixIcon: Icon(
                    Icons.arrow_drop_down_sharp,
                    color: AppTheme.color0F1015,
                  ),
                ),
                enabled: false,
                style: _textStyle,
              ),
            ),
          TextFormField(
            decoration: _commonInputDecoration('Phone Number*').copyWith(
              prefix: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                child: Text(
                  _selectedCountry.phoneCode ?? '',
                  style: _textStyle.copyWith(color: AppTheme.color555764),
                ),
              ),
            ),
            controller: _phoneNumberController,
            validator: (value) => value.isEmpty ? '' : null,
            keyboardType: TextInputType.phone,
            style: _textStyle,
          ),
          SizedBox(
            height: 20,
          ),
          _loading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => _uploadAddress(true),
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
                    // SizedBox(
                    //   width: 16,
                    // ),
                    // TextButton(
                    //   onPressed: _loading ? null : () => _uploadAddress(false),
                    //   child: Text(
                    //     'Confirm & Save',
                    //     style: TextStyle(
                    //       color: AppTheme.color48B6EF,
                    //     ),
                    //   ),
                    //   style: TextButton.styleFrom(
                    //     side: BorderSide(color: AppTheme.color48B6EF),
                    //   ),
                    // ),
                  ],
                ),
        ],
      ),
    );
  }

  _uploadAddress(bool isDefault) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    setState(() {
      _loading = true;
    });
    Networking.request(
      AddAddressAPI(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text ?? '',
        addressLine1: _addressLine1Controller.text,
        addressLine2: _addressLine2Controller.text ?? '',
        zipCode: _zipCodeController.text,
        city: _cityController.text,
        province: _provinceController.text,
        country: _countryController.text,
        phoneNumber: _phoneNumberController.text,
        isDefault: widget.isEditShipping ? isDefault : false,
        isBillDefault: widget.isEditShipping ? false : isDefault,
      ),
    ).then((value) {
      setState(() {
        _loading = false;
      });
      if (widget.onAdded != null) widget.onAdded();
    }).catchError((error) {
      setState(() {
        _loading = false;
      });
      EasyLoading.showToast(error.toString());
    });
  }

  _showPickerModal(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    Picker(
        adapter: PickerDataAdapter<String>(
          pickerdata: widget.countries.map((e) => e.countryName).toList(),
        ),
        changeToFirst: true,
        hideHeader: false,
        selectedTextStyle: TextStyle(color: AppTheme.color0F1015),
        confirmTextStyle: TextStyle(
          fontSize: 14,
        ),
        cancelTextStyle: TextStyle(
          fontSize: 14,
        ),
        onConfirm: (Picker picker, List value) {
          setState(() {
            _selectedCountry = widget.countries[value.first];
            _countryController.text = _selectedCountry.countryName;
            _selectedState = '';
          });
          Networking.request(ProvinceAPI(_selectedCountry.countryCode))
              .then((data) {
            setState(() {
              _states = List<String>.from(data['data']);
            });
          }).catchError((error) => EasyLoading.showError(error.toString()));
        }).showModal(this.context);
  }

  _showStatesPickerModal(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    Picker(
        adapter: PickerDataAdapter<String>(pickerdata: _states),
        changeToFirst: true,
        hideHeader: false,
        selectedTextStyle: TextStyle(color: AppTheme.color0F1015),
        confirmTextStyle: TextStyle(
          fontSize: 14,
        ),
        cancelTextStyle: TextStyle(
          fontSize: 14,
        ),
        onConfirm: (Picker picker, List value) {
          setState(() {
            _selectedState = _states[value.first];
            _provinceController.text = _selectedState;
          });
        }).showModal(this.context);
  }
}
