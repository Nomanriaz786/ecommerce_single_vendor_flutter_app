import 'package:ecommerce_app/data/products/product_repository.dart';
import 'package:ecommerce_app/features/shop/models/product_model.dart';
import 'package:ecommerce_app/util/constants/enums.dart';
import 'package:ecommerce_app/util/popup/loaders.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  static ProductController get instance => Get.find();

  /// - Variables
  final isLoading = false.obs;
  final productRepository = Get.put(ProductRepository());
  RxList<ProductModel> featuredProducts = <ProductModel>[].obs;
  @override
  void onInit() {
    fetchFeaturedProducts();
    super.onInit();
  }

  /// -Fetch Featured products
  void fetchFeaturedProducts() async {
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
      for (var variation in product.productVariations!) {
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
      return '\$$smallestPrice - \$$largestPrice';
    }
  }

  /// - Calculate Discount Percentage
  String? calculateSalePercentage(double originalPrice, double? salePrice) {
    if (salePrice == null || salePrice <= 0.0) return null;
    if (originalPrice <= 0) return null;

    double percentage = ((originalPrice - salePrice) / originalPrice) * 100;
    return percentage.toStringAsFixed(0);
  }

  /// - Check the stock status
  String getProductStockStatus(int stock) {
    return stock > 0 ? 'In Stock' : 'Out of Stock';
  }
}
