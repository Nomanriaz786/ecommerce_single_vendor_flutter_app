import 'dart:io';
import 'package:ecommerce_app/Admin_Panel/screen/addProducts/display_products.dart';
import 'package:ecommerce_app/data/products/product_repository.dart';
import 'package:ecommerce_app/features/shop/models/brand_model.dart';
import 'package:ecommerce_app/features/shop/models/product_model.dart';
import 'package:ecommerce_app/util/constants/enums.dart';
import 'package:ecommerce_app/util/constants/image_strings.dart';
import 'package:ecommerce_app/util/helpers/network_manager.dart';
import 'package:ecommerce_app/util/popup/full_screen_loading.dart';
import 'package:ecommerce_app/util/popup/loaders.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProductController extends GetxController {
  static ProductController get instance => Get.find();

  /// - Variables
  final isLoading = false.obs;
  RxBool refreshData = true.obs;
  // Initialize controllers with existing product data if editing
  final title = TextEditingController();
  final description = TextEditingController();
  final price = TextEditingController();
  final salePrice = TextEditingController();
  final stock = TextEditingController();
  final productType = TextEditingController();

  // Brand-related variables
  RxList<BrandModel> brands = <BrandModel>[].obs;
  Rx<BrandModel?> selectedBrand = Rx<BrandModel?>(null);

  // Category-related variables
  RxList<String> categories = <String>[].obs;
  RxString selectedCategory = ''.obs;

  RxBool isFeatured = false.obs;
  Rxn<File> thumbnail = Rxn<File>();

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  GlobalKey<FormState> productFormKey = GlobalKey<FormState>();
  final productRepository = Get.put(ProductRepository());
  RxList<ProductModel> featuredProducts = <ProductModel>[].obs;
  @override
  void onInit() {
    fetchFeaturedProducts();
    super.onInit();
  }

  /// -Fetch Featured products
  Future<void> fetchFeaturedProducts() async {
    try {
      // -Show Loader
      isLoading.value = true;

      // -Fetch Featured Products
      final featuredProducts = await productRepository.getFeaturedProducts();

      // -Assign products
      this.featuredProducts.assignAll(featuredProducts);
    } catch (e) {
      ELoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// -Fetch Featured products
  Future<List<ProductModel>> fetchAllFeaturedProducts() async {
    try {
      // -Fetch Featured Products
      final products = await productRepository.getAllFeaturedProducts();

      return products;
    } catch (e) {
      ELoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    }
  }

  /// -Get the product price and price range of variations
  String getProductPrice(ProductModel product) {
    double smallestPrice = double.infinity;
    double largestPrice = 0.0;

    // -If no variations exist,return the single price or sale price
    if (product.productType == ProductType.single.toString()) {
      return (product.salePrice > 0 ? product.salePrice : product.price)
          .toString();
    } else {
      // - Calculate the smallest and largest price or sale price
      for (var variation in product.productVariations ?? []) {
        // -Determine the price to consider
        double priceToConsider =
            variation.salesPrice > 0.0 ? variation.salesPrice : variation.price;

        // -Update the smallest and largest price
        if (priceToConsider < smallestPrice) {
          smallestPrice = priceToConsider;
        }
        if (priceToConsider > largestPrice) {
          largestPrice = priceToConsider;
        }
      }
      // if smallest and largest prices are the same, return a single price
      if (smallestPrice.isEqual(largestPrice)) {
        return largestPrice.toString();
      }
      //otherwise, return a price range
      return '$smallestPrice - $largestPrice';
    }
  }

  /// - Calculate Discount Percentage
  String? calculateSalePercentage(dynamic originalPrice, double? salePrice) {
    if (salePrice == null || salePrice <= 0.0) return null;
    if (originalPrice <= 0) return null;

    double percentage = ((originalPrice - salePrice) / originalPrice) * 100;
    return percentage.toStringAsFixed(0);
  }

  /// - Check the stock status
  String getProductStockStatus(int stock) {
    return stock > 0 ? 'In Stock' : 'Out of Stock';
  }

/*---------------------------------Admin Side Functions----------------------------------*/
  void loadProduct(ProductModel product) {
    // Initialize form fields if editing existing product
    title.text = product.title;
    description.text = product.description ?? '';
    price.text = product.price.toString();
    salePrice.text = product.salePrice.toStringAsFixed(2);
    stock.text = product.stock.toString();
    productType.text = product.productType;
    isFeatured.value = product.isFeatured;
  }

  // Pick image from gallery
  Future<void> pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      thumbnail.value = File(pickedFile.path);
    }
  }

  // Upload image to Firebase Storage
  Future<String?> uploadImageToStorage() async {
    try {
      if (thumbnail.value != null) {
        File file = thumbnail.value!;
        Reference storageRef =
            _storage.ref().child('products/${file.path.split('/').last}');
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

  Future<void> addNewProduct() async {
    try {
      // -Start Loading
      EFullScreenLoader.openLoadingDialog(
          'Uploading product to Firebase...', EImages.docerAnimation);
      // -Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        // -Remove Loader
        EFullScreenLoader.stopLoading();
        return;
      }

      // -Form Validation
      if (!productFormKey.currentState!.validate()) {
        // -Remove Loader
        EFullScreenLoader.stopLoading();
        return;
      }
      // -Save new product in Firebase Firestore
      String? imageUrl = await uploadImageToStorage();
      if (imageUrl != null) {
        final newProduct = ProductModel(
          id: UniqueKey().toString(),
          title: title.text.trim(),
          description: description.text.trim(),
          price: double.parse(price.text),
          salePrice:
              salePrice.text.isEmpty ? 0.00 : double.parse(salePrice.text),
          stock: int.parse(stock.text),
          productType: productType.text.trim(),
          isFeatured: isFeatured.value,
          brand: selectedBrand.value,
          thumbnail: imageUrl,
        );
        await ProductRepository.instance.addProduct(newProduct);
        // -Remove Loader
        EFullScreenLoader.stopLoading();

        // -Show success screen
        ELoaders.successSnackBar(
            title: 'Congratulations', message: 'Product is uploaded');
        clearControllers();
        Get.to(() =>
            const DisplayProducts()); // Go back to the previous screen after saving
      } else {
        ELoaders.errorSnackBar(
            title: 'Oh Snap!', message: 'Failed to upload image');
      }
    } catch (e) {
      ELoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  // Update an existing product
  Future<void> updateProduct(
      String productId, ProductModel existingProduct) async {
    if (!productFormKey.currentState!.validate()) return;

    String? imageUrl = existingProduct.thumbnail;
    if (thumbnail.value != null &&
        thumbnail.value!.path != existingProduct.thumbnail) {
      imageUrl = await uploadImageToStorage();
    }

    final updatedProduct = ProductModel(
      id: productId,
      title: title.text,
      description: description.text,
      price: double.parse(price.text),
      salePrice: salePrice.text.isEmpty ? 0.0 : double.parse(salePrice.text),
      stock: int.parse(stock.text),
      productType: productType.text,
      thumbnail: imageUrl ?? '',
      isFeatured: isFeatured.value,
    );

    await ProductRepository.instance.updateProduct(productId, updatedProduct);
    refreshData.toggle(); // Toggle to trigger UI refresh
    clearControllers();
    Get.to(() => const DisplayProducts());
  }

  // -Clear controllers
  void clearControllers() {
    title.clear();
    description.clear();
    price.clear();
    salePrice.clear();
    stock.clear();
    productType.clear();
    thumbnail.value = null;
    isFeatured.value = false;
  }

  /// -Fetch All products
  Future<List<ProductModel>> fetchAllProducts() async {
    try {
      // -Fetch All Products
      final products = await productRepository.getAllProducts();

      return products;
    } catch (e) {
      ELoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    }
  }

  // --Delete product from database
  Future<void> deleteProduct(String productId) async {
    await ProductRepository.instance.deleteProduct(productId);
    refreshData.toggle(); // Toggle to trigger UI refresh
  }

  Future<List<BrandModel>> fetchBrands() async {
    return await ProductRepository.instance.fetchBrands();
  }

  Future<void> fetchCategories() async {
    categories.value = await ProductRepository.instance.fetchCategories();
  }
}
