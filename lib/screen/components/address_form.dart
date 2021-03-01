import 'package:fans/networking/api.dart';
import 'package:fans/networking/networking.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fans/theme.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AddressForm extends StatefulWidget {
  final bool isEditShipping;
  final VoidCallback onAdded;
  AddressForm({Key key, @required this.isEditShipping, this.onAdded})
      : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    InputDecoration _commonInputDecoration(String hintText) {
      return InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 12.0, color: AppTheme.colorC4C5CD),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: AppTheme.colorC4C5CD),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppTheme.colorC4C5CD),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppTheme.color0F1015),
        ),
      );
    }

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
                ),
              )
            ],
          ),
          TextFormField(
            decoration: _commonInputDecoration('Address Line 1*'),
            controller: _addressLine1Controller,
            validator: (value) => value.isEmpty ? '' : null,
          ),
          TextFormField(
            decoration: _commonInputDecoration('Address Line 2'),
            controller: _addressLine2Controller,
            validator: null,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: TextFormField(
                  decoration: _commonInputDecoration('Zip Code*'),
                  controller: _zipCodeController,
                  validator: (value) => value.isEmpty ? '' : null,
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
                ),
              )
            ],
          ),
          TextFormField(
            decoration: _commonInputDecoration('Province'),
            controller: _provinceController,
            validator: (value) => value.isEmpty ? '' : null,
          ),
          TextFormField(
            decoration: _commonInputDecoration('Country'),
            controller: _countryController,
            validator: (value) => value.isEmpty ? '' : null,
          ),
          TextFormField(
            decoration: _commonInputDecoration('Phone Number*'),
            controller: _phoneNumberController,
            validator: (value) => value.isEmpty ? '' : null,
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
                        'Set As Default',
                        style: TextStyle(
                          color: AppTheme.colorED8514,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        side: BorderSide(color: AppTheme.colorED8514),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    TextButton(
                      onPressed: _loading ? null : () => _uploadAddress(false),
                      child: Text(
                        'Confirm & Save',
                        style: TextStyle(
                          color: AppTheme.color48B6EF,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        side: BorderSide(color: AppTheme.color48B6EF),
                      ),
                    ),
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
}
