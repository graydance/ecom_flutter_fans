import 'package:fans/models/models.dart';
import 'package:fans/networking/api.dart';
import 'package:fans/networking/networking.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fans/theme.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

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
  String _phoneNumber = '';
  bool _phoneNumberIsValid = false;

  @override
  Widget build(BuildContext context) {
    InputDecoration _commonInputDecoration(String hintText) {
      return InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 14.0, color: AppTheme.colorC4C5CD),
        labelText: hintText,
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
      );
    }

    final _textStyle = TextStyle(
      fontSize: 14,
    );

    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(
            height: 12,
          ),
          TextFormField(
            decoration: _commonInputDecoration('First Name'),
            controller: _firstNameController,
            validator: (value) => value.isEmpty || value.length > 64
                ? 'Invalid First Name'
                : null,
            style: _textStyle,
          ),
          SizedBox(
            height: 12,
          ),
          TextFormField(
            decoration: _commonInputDecoration('Last Name (optional)'),
            controller: _lastNameController,
            validator: (value) =>
                value.length > 64 ? 'Invalid Last Name' : null,
            style: _textStyle,
          ),
          SizedBox(
            height: 12,
          ),
          TextFormField(
            decoration: _commonInputDecoration('Address Line 1'),
            controller: _addressLine1Controller,
            validator: (value) => value.length < 10 || value.length > 256
                ? 'Invalid Address'
                : null,
            style: _textStyle,
          ),
          SizedBox(
            height: 12,
          ),
          TextFormField(
            decoration: _commonInputDecoration('Address Line 2 (optional)'),
            controller: _addressLine2Controller,
            validator: (value) => value.length > 256 ? 'Invalid Address' : null,
            style: _textStyle,
          ),
          SizedBox(
            height: 12,
          ),
          TextFormField(
            decoration: _commonInputDecoration('City'),
            controller: _cityController,
            validator: (value) =>
                value.isEmpty || value.length > 64 ? 'Invalid City' : null,
            style: _textStyle,
          ),
          SizedBox(
            height: 12,
          ),
          GestureDetector(
            onTap: () {
              _showPickerModal(context);
            },
            child: TextFormField(
              controller: _countryController,
              decoration: _commonInputDecoration('Country').copyWith(
                suffixIcon: Icon(
                  Icons.keyboard_arrow_down,
                  color: AppTheme.colorC4C5CD,
                ),
              ),
              enabled: false,
              style: _textStyle,
              validator: (value) => value.isEmpty ? 'Invalid Country' : null,
            ),
          ),
          SizedBox(
            height: 12,
          ),
          if (_states.isNotEmpty)
            GestureDetector(
              onTap: () {
                _showStatesPickerModal(context);
              },
              child: TextFormField(
                controller: _provinceController,
                decoration: _commonInputDecoration('State').copyWith(
                  suffixIcon: Icon(
                    Icons.keyboard_arrow_down,
                    color: AppTheme.colorC4C5CD,
                  ),
                ),
                enabled: false,
                style: _textStyle,
                validator: (value) => value.isEmpty && _states.isNotEmpty
                    ? 'Invalid State'
                    : null,
              ),
            ),
          if (_states.isNotEmpty)
            SizedBox(
              height: 12,
            ),
          TextFormField(
            decoration: _commonInputDecoration('Zip Code'),
            controller: _zipCodeController,
            validator: (value) =>
                value.isEmpty || value.length > 10 ? 'Invalid Zip Code' : null,
            style: _textStyle,
          ),
          SizedBox(
            height: 12,
          ),
          InternationalPhoneNumberInput(
            onInputChanged: (PhoneNumber value) {
              _phoneNumber = value.dialCode + ' ' + value.parseNumber();
              print(_phoneNumber);
            },
            initialValue: PhoneNumber(
                isoCode: _selectedCountry.countryCode.isNotEmpty
                    ? _selectedCountry.countryCode
                    : 'US'),
            selectorConfig: SelectorConfig(
              showFlags: false,
              setSelectorButtonAsPrefixIcon: false,
              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
              boxDecoration: BoxDecoration(
                border: Border.all(
                  color: AppTheme.colorC4C5CD,
                ),
              ),
              padding: EdgeInsets.all(11.0),
            ),
            ignoreBlank: false,
            textFieldController: _phoneNumberController,
            keyboardType: TextInputType.phone,
            inputDecoration: _commonInputDecoration('Phone Number'),
            onInputValidated: (bool value) {
              setState(() {
                _phoneNumberIsValid = value;
              });

              print('_phoneNumberIsValid: $value');
            },
            spaceBetweenSelectorAndTextField: 0,
            countries: widget.countries.map((e) => e.countryCode).toList(),
            selectorTextStyle: _textStyle,
            textStyle: _textStyle,
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
    if (!_formKey.currentState.validate() || !_phoneNumberIsValid) {
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
        phoneNumber:
            _selectedCountry.phoneCode + ' ' + _phoneNumberController.text,
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
