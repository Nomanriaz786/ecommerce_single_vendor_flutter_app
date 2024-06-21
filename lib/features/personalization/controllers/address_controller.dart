import 'dart:async';

import 'package:ecommerce_app/common/widgets/loaders/circular_loader.dart';
import 'package:ecommerce_app/common/widgets/text/section_heading.dart';
import 'package:ecommerce_app/data/address/address_repository.dart';
import 'package:ecommerce_app/features/personalization/models/address_model.dart';
import 'package:ecommerce_app/features/personalization/screens/address/add_new_address.dart';
import 'package:ecommerce_app/features/personalization/screens/address/widgets/single_address.dart';
import 'package:ecommerce_app/util/constants/image_strings.dart';
import 'package:ecommerce_app/util/constants/sizes.dart';
import 'package:ecommerce_app/util/helpers/network_manager.dart';
import 'package:ecommerce_app/util/popup/full_screen_loading.dart';
import 'package:ecommerce_app/util/popup/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressController extends GetxController {
  static AddressController get instance => Get.find();

  final Rx<AddressModel> selectedAddress = AddressModel.empty().obs;
  final addressRepository = Get.put(AddressRepository());

  final name = TextEditingController();
  final phoneNumber = TextEditingController();
  final street = TextEditingController();
  final postalCode = TextEditingController();
  final city = TextEditingController();
  final state = TextEditingController();
  final country = TextEditingController();
  GlobalKey<FormState> addressFormKey = GlobalKey<FormState>();

  RxBool refreshData = true.obs;

  /// -Fetch All User Specific Address
  Future<List<AddressModel>> getAllUserAddresses() async {
    try {
      final addresses = await addressRepository.fetchUserAddress();
      selectedAddress.value = addresses.firstWhere(
          (element) => element.selectedAddress,
          orElse: () => AddressModel.empty());
      return addresses;
    } catch (e) {
      ELoaders.errorSnackBar(title: 'Address not found', message: e.toString());
      return [];
    }
  }

  // -set default address for shipping
  Future<dynamic> selectNewAddressPop(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (_) => SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(ESizes.lg),
                child: Expanded(
                  flex: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ESectionHeading(
                          title: 'Shipping Address', showActionButton: false),
                      const SizedBox(height: ESizes.spaceBtItems),
                      FutureBuilder(
                          future: getAllUserAddresses(),
                          builder: (_, snapshot) {
                            const loader = ECircularLoader();
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return loader;
                            }
                            if (!snapshot.hasData ||
                                snapshot.data == null ||
                                snapshot.data!.isEmpty) {
                              return const Center(
                                child: Text('No Data Found'),
                              );
                            }
                            if (snapshot.hasError) {
                              return const Center(
                                child: Text('Something went wrong'),
                              );
                            }

                            return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data!.length,
                                itemBuilder: (_, index) {
                                  return ESingleAddress(
                                      address: snapshot.data![index],
                                      onTap: () async {
                                        await selectAddress(
                                            snapshot.data![index]);
                                        Get.back();
                                      });
                                });
                          }),
                      const SizedBox(
                        height: ESizes.spaceBtItems * 2,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () =>
                              Get.to(() => const AddNewAddressScreen()),
                          child: const Text('Add New Address'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
  }

  Future selectAddress(AddressModel newSelectedAddress) async {
    try {
      // -Clear the selected field
      await addressRepository.updateSelectedField(
          selectedAddress.value.id, false);

      // -Assign the selected address
      newSelectedAddress.selectedAddress = true;
      selectedAddress.value = newSelectedAddress;
      // -Set the 'selected' field to true for the newly selected address
      await addressRepository.updateSelectedField(
          selectedAddress.value.id, true);
    } catch (e) {
      ELoaders.errorSnackBar(
          title: 'Error in selection', message: e.toString());
    }
  }

  // -Select address popup for checkout screen

  Future<void> saveAddress() async {
    try {
      // -Start Loading
      EFullScreenLoader.openLoadingDialog(
          'Storing information...', EImages.docerAnimation);
      // -Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        // -Remove Loader
        EFullScreenLoader.stopLoading();
        return;
      }

      // -Form Validation
      if (!addressFormKey.currentState!.validate()) {
        // -Remove Loader
        EFullScreenLoader.stopLoading();
        return;
      }

      // -Save address data
      final address = AddressModel(
        id: '',
        name: name.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        street: street.text.trim(),
        state: state.text.trim(),
        country: country.text.trim(),
        postalCode: postalCode.text.trim(),
        selectedAddress: true,
        city: city.text.trim(),
      );
      final id = await addressRepository.addAddress(address);

      // -update selected address
      address.id = id;
      selectedAddress(address);

      // -Remove loaders
      EFullScreenLoader.stopLoading();

      // -Show success screen
      ELoaders.successSnackBar(
          title: 'Congratulations',
          message: 'Your address has been saved successfully');

      // -Refreshes data
      refreshData.toggle();

      // -Reset fields
      resetFormFields();

      // -Redirects
      Navigator.of(Get.context!).pop();
    } catch (e) {
      // -Remove Loader
      EFullScreenLoader.stopLoading();
      // -Show some generic error to the user
      ELoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  void resetFormFields() {
    name.clear();
    state.clear();
    city.clear();
    street.clear();
    country.clear();
    postalCode.clear();
    phoneNumber.clear();
    addressFormKey.currentState?.reset();
  }
}
