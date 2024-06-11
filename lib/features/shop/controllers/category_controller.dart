import 'dart:async';

import 'package:ecommerce_app/data/Categories/category_repository.dart';
import 'package:ecommerce_app/data/products/product_repository.dart';
import 'package:ecommerce_app/features/shop/models/category_model.dart';
import 'package:ecommerce_app/features/shop/models/product_model.dart';
import 'package:ecommerce_app/util/popup/full_screen_loading.dart';
import 'package:ecommerce_app/util/popup/loaders.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  static CategoryController get instance => Get.find();

  /// -Variables
  final isLoading = false.obs;
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
  Future<List<ProductModel>> getCategoryProducts(
      {required String categoryId, int limit = 4}) async {
    // -Fetch limited products against each sub-category
    final products = await ProductRepository.instance
        .getProductsForCategory(categoryId: categoryId, limit: limit);
    return products;
  }
}
