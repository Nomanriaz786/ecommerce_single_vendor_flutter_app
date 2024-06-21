import 'dart:io';

import 'package:ecommerce_app/Admin_Panel/screen/addBrands/display_brands.dart';
import 'package:ecommerce_app/data/brands/brand_repository.dart';
import 'package:ecommerce_app/data/products/product_repository.dart';
import 'package:ecommerce_app/features/shop/models/brand_model.dart';
import 'package:ecommerce_app/features/shop/models/product_model.dart';
import 'package:ecommerce_app/util/constants/image_strings.dart';
import 'package:ecommerce_app/util/helpers/network_manager.dart';
import 'package:ecommerce_app/util/popup/full_screen_loading.dart';
import 'package:ecommerce_app/util/popup/loaders.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class BrandController extends GetxController {
  static BrandController get instance => Get.find();

  RxBool isLoading = true.obs;
  RxBool refreshData = true.obs;

  /// -Variables
  final name = TextEditingController();
  final productCount = TextEditingController();
  RxBool isFeatured = false.obs;
  Rxn<File> image = Rxn<File>();
  final GlobalKey<FormState> brandFormKey = GlobalKey<FormState>();
  final _storage = FirebaseStorage.instance;
  final RxList<BrandModel> featuredBrands = <BrandModel>[].obs;
  final RxList<BrandModel> allBrands = <BrandModel>[].obs;
  final brandRepository = Get.put(BrandRepository());

  @override
  void onInit() {
    getFeaturedBrands();
    super.onInit();
  }

  /// -Load Brands
  Future<void> getFeaturedBrands() async {
    try {
      // - Show loader while brands load
      isLoading.value = true;

      final brands = await brandRepository.getAllBrands();

      allBrands.assignAll(brands);

      featuredBrands.assignAll(
          allBrands.where((brand) => brand.isFeatured ?? false).take(4));
    } catch (e) {
      ELoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      // -Stop loading
      isLoading.value = false;
    }
  }

  ///  -Get Brands for Category
  Future<List<BrandModel>> getBrandsForCategory(String categoryId) async {
    try {
      final brands =
          await BrandRepository.instance.getBrandsForCategory(categoryId);
      return brands;
    } catch (e) {
      ELoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    }
  }

  ///  -Get Brand Specific products from data source
  Future<List<ProductModel>> getBrandSpecificProducts(
      {required String brandId, int limit = -1}) async {
    try {
      final products = await ProductRepository.instance
          .getProductsForBrands(brandId: brandId, limit: limit);
      return products;
    } catch (e) {
      ELoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    }
  }

  /*----------------------------Admin Panel-------------------------------------*/
  /// -Load Brands data
  Future<List<BrandModel>> getBrands() async {
    try {
      // -Fetch Brand from data source (FireBase)
      final categories = await brandRepository.getAllBrands();
      return categories;
    } catch (e) {
      ELoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    }
  }

  /// -Delete Brand
  Future<void> deleteBrand(String brandId) async {
    try {
      // -Delete Brand from data source (FireBase)
      await brandRepository.deleteBrand(brandId);
      refreshData.toggle();
    } catch (e) {
      ELoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  // Pick image from gallery
  Future<void> pickImage() async {
    final XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image.value = File(pickedFile.path);
    }
  }

  // Upload image to Firebase Storage
  Future<String?> uploadImageToStorage() async {
    try {
      if (image.value != null) {
        File file = image.value!;
        Reference storageRef =
            _storage.ref().child('Brands/${file.path.split('/').last}');
        UploadTask uploadTask = storageRef.putFile(file);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        return downloadUrl;
      }
      return null;
    } catch (e) {
      ELoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      return null;
    }
  }

  /// -Add Brand
  Future<void> addNewBrand() async {
    try {
      // -Start Loading
      EFullScreenLoader.openLoadingDialog(
          'Uploading brand to Firebase...', EImages.docerAnimation);
      // -Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        // -Remove Loader
        EFullScreenLoader.stopLoading();
        return;
      }

      // -Form Validation
      if (!brandFormKey.currentState!.validate()) {
        // -Remove Loader
        EFullScreenLoader.stopLoading();
        return;
      }
      // -Save new product in Firebase Firestore
      String? imageUrl = await uploadImageToStorage();
      if (imageUrl != null) {
        final newBrand = BrandModel(
          id: UniqueKey().toString(),
          name: name.text.trim(),
          isFeatured: isFeatured.value,
          productCount: productCount.text,
          image: imageUrl,
        );
        await brandRepository.addBrand(newBrand);
        // -Remove Loader
        EFullScreenLoader.stopLoading();

        // -Show success screen
        ELoaders.successSnackBar(
            title: 'Congratulations', message: 'Brand is uploaded');
        clearControllers();
        Get.to(() =>
            const DisplayBrands()); // Go back to the previous screen after saving
      } else {
        ELoaders.errorSnackBar(
            title: 'Oh Snap!', message: 'Failed to upload image');
      }
    } catch (e) {
      ELoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  void loadBrand(BrandModel brand) {
    // Initialize form fields if editing existing product
    name.text = brand.name;
    productCount.text = brand.productCount;
    isFeatured.value = brand.isFeatured!;
  }

  // Update an existing product
  Future<void> updateBrand(String brandId, BrandModel existingBrand) async {
    if (!brandFormKey.currentState!.validate()) return;

    String? imageUrl = existingBrand.image;
    if (image.value != null && image.value!.path != existingBrand.image) {
      imageUrl = await uploadImageToStorage();
    }

    final updatedBrand = BrandModel(
      id: brandId,
      name: name.text,
      image: imageUrl ?? '',
      isFeatured: isFeatured.value,
      productCount: productCount.text,
    );

    await brandRepository.updateBrand(brandId, updatedBrand);
    refreshData.toggle(); // Toggle to trigger UI refresh
    clearControllers();
    Get.to(() => const DisplayBrands());
  }

  // -Clear controllers
  void clearControllers() {
    name.clear();
    productCount.clear();
    image.value = null;
    isFeatured.value = false;
  }
}
