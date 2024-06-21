import 'dart:async';
import 'dart:io';

import 'package:ecommerce_app/Admin_Panel/screen/addCategories/display_categories.dart';
import 'package:ecommerce_app/data/Categories/category_repository.dart';
import 'package:ecommerce_app/data/products/product_repository.dart';
import 'package:ecommerce_app/features/shop/models/category_model.dart';
import 'package:ecommerce_app/features/shop/models/product_model.dart';
import 'package:ecommerce_app/util/constants/image_strings.dart';
import 'package:ecommerce_app/util/helpers/network_manager.dart';
import 'package:ecommerce_app/util/popup/full_screen_loading.dart';
import 'package:ecommerce_app/util/popup/loaders.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CategoryController extends GetxController {
  static CategoryController get instance => Get.find();

  /// -Variables
  final isLoading = false.obs;
  RxBool refreshData = true.obs;

  final name = TextEditingController();
  RxBool isFeatured = false.obs;
  Rxn<File> image = Rxn<File>();
  final GlobalKey<FormState> categoryFormKey = GlobalKey<FormState>();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final _categoryRepository = Get.put(CategoryRepository());
  RxList<CategoryModel> allCategories = <CategoryModel>[].obs;
  RxList<CategoryModel> featuredCategories = <CategoryModel>[].obs;

  @override
  void onInit() {
    fetchCategories();
    super.onInit();
  }

  /// -Load category data
  Future<void> fetchCategories() async {
    try {
      // -Show loader while categories are loaded
      isLoading.value = true;
      // -Fetch categories from data source (FirBase)
      final categories = await _categoryRepository.getAllCategories();

      // -Update the categories list
      allCategories.assignAll(categories);

      // -Filter the featured categories
      featuredCategories.assignAll(allCategories
          .where((category) => category.isFeatured && category.parentId.isEmpty)
          .take(8)
          .toList());
    } catch (e) {
      // -Remove Loader
      EFullScreenLoader.stopLoading();
      // -Show some generic error to the user
      ELoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      //  -Remove Loader
      isLoading.value = false;
    }
  }

  /// -Get Category or Sub-Category
  Future<List<CategoryModel>> getSubCategories(String categoryId) async {
    final subCategories =
        await _categoryRepository.getSubCategories(categoryId);
    return subCategories;
  }

  /// -Get Category or Sub-Category
  Future<List<ProductModel>> getCategoryProducts(
      {required String categoryId, int limit = 4}) async {
    // -Fetch limited products against each sub-category
    final products = await ProductRepository.instance
        .getProductsForCategory(categoryId: categoryId, limit: limit);
    return products;
  }

  /*-------------------------------Admin Panel---------------------------------*/
  /// -Load category data
  Future<List<CategoryModel>> getCategories() async {
    try {
      // -Fetch categories from data source (FireBase)
      final categories = await _categoryRepository.getAllCategories();
      return categories;
    } catch (e) {
      ELoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    }
  }

  /// -Delete category
  Future<void> deleteCategories(String categoryId) async {
    try {
      // -Delete categories from data source (FireBase)
      await _categoryRepository.deleteCategories(categoryId);
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
            _storage.ref().child('Categories/${file.path.split('/').last}');
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

  /// -Add category
  Future<void> addNewCategory() async {
    try {
      // -Start Loading
      EFullScreenLoader.openLoadingDialog(
          'Uploading category to Firebase...', EImages.docerAnimation);
      // -Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        // -Remove Loader
        EFullScreenLoader.stopLoading();
        return;
      }

      // -Form Validation
      if (!categoryFormKey.currentState!.validate()) {
        // -Remove Loader
        EFullScreenLoader.stopLoading();
        return;
      }
      // -Save new product in Firebase Firestore
      String? imageUrl = await uploadImageToStorage();
      if (imageUrl != null) {
        final newCategory = CategoryModel(
          id: UniqueKey().toString(),
          name: name.text.trim(),
          isFeatured: isFeatured.value,
          image: imageUrl,
        );
        await CategoryRepository.instance.addCategories(newCategory);
        // -Remove Loader
        EFullScreenLoader.stopLoading();

        // -Show success screen
        ELoaders.successSnackBar(
            title: 'Congratulations', message: 'Category is uploaded');
        clearControllers();
        Get.to(() =>
            const DisplayCategories()); // Go back to the previous screen after saving
      } else {
        ELoaders.errorSnackBar(
            title: 'Oh Snap!', message: 'Failed to upload image');
      }
    } catch (e) {
      ELoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  void loadCategory(CategoryModel category) {
    // Initialize form fields if editing existing product
    name.text = category.name;
    isFeatured.value = category.isFeatured;
  }

  // Update an existing product
  Future<void> updateCategory(
      String categoryId, CategoryModel existingCategory) async {
    if (!categoryFormKey.currentState!.validate()) return;

    String? imageUrl = existingCategory.image;
    if (image.value != null && image.value!.path != existingCategory.image) {
      imageUrl = await uploadImageToStorage();
    }

    final updatedCategory = CategoryModel(
      id: categoryId,
      name: name.text,
      image: imageUrl ?? '',
      isFeatured: isFeatured.value,
    );

    await CategoryRepository.instance
        .updateCategory(categoryId, updatedCategory);
    refreshData.toggle(); // Toggle to trigger UI refresh
    clearControllers();
    Get.to(() => const DisplayCategories());
  }

  // -Clear controllers
  void clearControllers() {
    name.clear();
    image.value = null;
    isFeatured.value = false;
  }
}
