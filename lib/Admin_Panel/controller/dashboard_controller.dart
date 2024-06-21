import 'package:ecommerce_app/data/products/product_repository.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  static DashboardController get instance => Get.find();
  RxInt noOfUsers = 0.obs;
  RxInt noOfBrands = 0.obs;
  RxInt noOfCategories = 0.obs;
  RxInt noOfProducts = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTotalProducts();
    fetchTotalBrands();
    fetchTotalUsers();
    fetchTotalCategories();
  }

  void fetchTotalProducts() async {
    try {
      int totalProducts = await ProductRepository.instance.getTotalProducts();
      noOfProducts.value = totalProducts;
    } catch (e) {
      throw 'Error fetching total products: $e';
    }
  }

  void fetchTotalUsers() async {
    try {
      int totalUsers = await ProductRepository.instance.getTotalUsers();
      noOfUsers.value = totalUsers;
    } catch (e) {
      throw 'Error fetching total Users: $e';
    }
  }

  void fetchTotalBrands() async {
    try {
      int totalBrands = await ProductRepository.instance.getTotalBrands();
      noOfBrands.value = totalBrands;
    } catch (e) {
      throw 'Error fetching total brands: $e';
    }
  }

  void fetchTotalCategories() async {
    try {
      int totalCategories =
          await ProductRepository.instance.getTotalCategories();
      noOfCategories.value = totalCategories;
    } catch (e) {
      throw 'Error fetching total categories: $e';
    }
  }
}
