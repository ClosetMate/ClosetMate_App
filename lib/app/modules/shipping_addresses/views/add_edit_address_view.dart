import 'package:closet_mate/config/theme/theme_colors.dart';
import 'package:closet_mate/models/shipping_address_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/shipping_addresses_controller.dart';

class AddEditAddressView extends StatefulWidget {
  const AddEditAddressView({super.key});

  @override
  State<AddEditAddressView> createState() => _AddEditAddressViewState();
}

class _AddEditAddressViewState extends State<AddEditAddressView> {
  final ShippingAddressesController controller = Get.find<ShippingAddressesController>();
  final formKey = GlobalKey<FormState>();
  
  late TextEditingController fullNameController;
  late TextEditingController streetController;
  late TextEditingController cityController;
  late TextEditingController stateController;
  late TextEditingController zipCodeController;
  late TextEditingController countryController;
  late TextEditingController phoneController;
  late RxBool isDefault;

  ShippingAddressModel? address;

  @override
  void initState() {
    super.initState();
    // Get address from arguments if editing
    address = Get.arguments as ShippingAddressModel?;
    
    fullNameController = TextEditingController(text: address?.fullName ?? '');
    streetController = TextEditingController(text: address?.street ?? '');
    cityController = TextEditingController(text: address?.city ?? '');
    stateController = TextEditingController(text: address?.state ?? '');
    zipCodeController = TextEditingController(text: address?.zipCode ?? '');
    countryController = TextEditingController(text: address?.country ?? 'USA');
    phoneController = TextEditingController(text: address?.phoneNumber ?? '');
    isDefault = (address?.isDefault ?? false).obs;
  }

  @override
  void dispose() {
    fullNameController.dispose();
    streetController.dispose();
    cityController.dispose();
    stateController.dispose();
    zipCodeController.dispose();
    countryController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLightTheme = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      backgroundColor: ThemeColors.getScaffoldBackground(isLightTheme),
      appBar: AppBar(
        title: Text(
          address == null ? 'Add Address' : 'Edit Address',
          style: TextStyle(color: ThemeColors.getTextPrimary(isLightTheme)),
        ),
        backgroundColor: ThemeColors.getScaffoldBackground(isLightTheme),
        iconTheme: IconThemeData(color: ThemeColors.getTextPrimary(isLightTheme)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: fullNameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  labelStyle: TextStyle(color: ThemeColors.getTextPrimary(isLightTheme)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                style: TextStyle(color: ThemeColors.getTextPrimary(isLightTheme)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter full name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              TextFormField(
                controller: streetController,
                decoration: InputDecoration(
                  labelText: 'Street Address',
                  labelStyle: TextStyle(color: ThemeColors.getTextPrimary(isLightTheme)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                style: TextStyle(color: ThemeColors.getTextPrimary(isLightTheme)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter street address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: cityController,
                      decoration: InputDecoration(
                        labelText: 'City',
                        labelStyle: TextStyle(color: ThemeColors.getTextPrimary(isLightTheme)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      style: TextStyle(color: ThemeColors.getTextPrimary(isLightTheme)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: TextFormField(
                      controller: stateController,
                      decoration: InputDecoration(
                        labelText: 'State',
                        labelStyle: TextStyle(color: ThemeColors.getTextPrimary(isLightTheme)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      style: TextStyle(color: ThemeColors.getTextPrimary(isLightTheme)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: zipCodeController,
                      decoration: InputDecoration(
                        labelText: 'ZIP Code',
                        labelStyle: TextStyle(color: ThemeColors.getTextPrimary(isLightTheme)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      style: TextStyle(color: ThemeColors.getTextPrimary(isLightTheme)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: TextFormField(
                      controller: countryController,
                      decoration: InputDecoration(
                        labelText: 'Country',
                        labelStyle: TextStyle(color: ThemeColors.getTextPrimary(isLightTheme)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      style: TextStyle(color: ThemeColors.getTextPrimary(isLightTheme)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number (Optional)',
                  labelStyle: TextStyle(color: ThemeColors.getTextPrimary(isLightTheme)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                style: TextStyle(color: ThemeColors.getTextPrimary(isLightTheme)),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16.h),
              Obx(
                () => CheckboxListTile(
                  title: Text(
                    'Set as default address',
                    style: TextStyle(color: ThemeColors.getTextPrimary(isLightTheme)),
                  ),
                  value: isDefault.value,
                  onChanged: (value) {
                    isDefault.value = value ?? false;
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
              SizedBox(height: 32.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      final newAddress = ShippingAddressModel(
                        id: address?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                        fullName: fullNameController.text.trim(),
                        street: streetController.text.trim(),
                        city: cityController.text.trim(),
                        state: stateController.text.trim(),
                        zipCode: zipCodeController.text.trim(),
                        country: countryController.text.trim(),
                        phoneNumber: phoneController.text.trim().isEmpty 
                            ? null 
                            : phoneController.text.trim(),
                        isDefault: isDefault.value,
                      );

                      if (address == null) {
                        controller.addAddress(newAddress);
                      } else {
                        controller.updateAddress(newAddress);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                  ),
                  child: Text(
                    address == null ? 'Add Address' : 'Update Address',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

