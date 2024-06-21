import 'package:ecommerce_app/data/authentication_repository/user_repository.dart';
import 'package:ecommerce_app/data/products/product_repository.dart';
import 'package:ecommerce_app/features/personalization/controllers/address_controller.dart';
import 'package:ecommerce_app/features/personalization/controllers/user_controller.dart';
import 'package:ecommerce_app/features/shop/controllers/brand_controller.dart';
import 'package:ecommerce_app/features/shop/controllers/category_controller.dart';
import 'package:ecommerce_app/features/shop/controllers/product/checkout_controller.dart';
import 'package:ecommerce_app/features/shop/controllers/product/product_controller.dart';
import 'package:ecommerce_app/features/shop/controllers/product/variation_controller.dart';
import 'package:ecommerce_app/util/helpers/network_manager.dart';
import 'package:get/get.dart';

class GeneralBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NetworkManager());
    Get.put(BrandController());
    Get.put(VariationController());
    Get.put(CheckoutController());
    Get.put(AddressController());
    Get.put(ProductRepository());
    Get.put(UserRepository());
    Get.put(UserController());
    Get.put(ProductController());
    Get.put(CategoryController());
  }
}
