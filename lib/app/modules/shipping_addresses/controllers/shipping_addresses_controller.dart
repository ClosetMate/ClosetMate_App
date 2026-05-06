import 'package:get/get.dart';
import 'package:closet_mate/models/shipping_address_model.dart';

class ShippingAddressesController extends GetxController {
  final RxList<ShippingAddressModel> addresses = <ShippingAddressModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadAddresses();
  }

  Future<void> loadAddresses() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // TODO: Replace with actual API call to fetch addresses
      // For now, using mock data
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
      
      // Mock addresses data - replace with actual API call
      addresses.value = _getMockAddresses();
      
    } catch (e) {
      errorMessage.value = e.toString();
      print('Error loading addresses: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshAddresses() async {
    await loadAddresses();
  }

  Future<void> addAddress(ShippingAddressModel address) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // TODO: Replace with actual API call to add address
      await Future.delayed(const Duration(milliseconds: 300));
      
      // If this is set as default, unset other defaults
      if (address.isDefault) {
        addresses.value = addresses.map((a) => a.copyWith(isDefault: false)).toList();
      }
      
      addresses.add(address);
      
      Get.back(); // Navigate back to addresses list
      Get.snackbar(
        'Success',
        'Address added successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
      );
      
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to add address: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateAddress(ShippingAddressModel address) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // TODO: Replace with actual API call to update address
      await Future.delayed(const Duration(milliseconds: 300));
      
      // If this is set as default, unset other defaults
      if (address.isDefault) {
        addresses.value = addresses.map((a) => 
          a.id == address.id ? address : a.copyWith(isDefault: false)
        ).toList();
      } else {
        final index = addresses.indexWhere((a) => a.id == address.id);
        if (index != -1) {
          addresses[index] = address;
        }
      }
      
      Get.back(); // Navigate back to addresses list
      Get.snackbar(
        'Success',
        'Address updated successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
      );
      
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to update address: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteAddress(String addressId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // TODO: Replace with actual API call to delete address
      await Future.delayed(const Duration(milliseconds: 300));
      
      addresses.removeWhere((a) => a.id == addressId);
      
      Get.snackbar(
        'Success',
        'Address deleted successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
      );
      
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to delete address: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> setDefaultAddress(String addressId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // TODO: Replace with actual API call to set default address
      await Future.delayed(const Duration(milliseconds: 300));
      
      addresses.value = addresses.map((a) => 
        a.copyWith(isDefault: a.id == addressId)
      ).toList();
      
      Get.snackbar(
        'Success',
        'Default address updated',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
      );
      
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to set default address: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Mock data - remove when implementing actual API
  List<ShippingAddressModel> _getMockAddresses() {
    return [
      ShippingAddressModel(
        id: '1',
        fullName: 'John Doe',
        street: '123 Main Street',
        city: 'New York',
        state: 'NY',
        zipCode: '10001',
        country: 'USA',
        phoneNumber: '+1 234-567-8900',
        isDefault: true,
      ),
      ShippingAddressModel(
        id: '2',
        fullName: 'Jane Smith',
        street: '456 Oak Avenue',
        city: 'Los Angeles',
        state: 'CA',
        zipCode: '90001',
        country: 'USA',
        phoneNumber: '+1 234-567-8901',
        isDefault: false,
      ),
    ];
  }
}

