import 'dart:convert';

import 'package:ecommerce_app/data/products/product_repository.dart';
import 'package:ecommerce_app/features/shop/models/product_model.dart';
import 'package:ecommerce_app/util/local_storage/local_storage.dart';
import 'package:ecommerce_app/util/popup/loaders.dart';
import 'package:get/get.dart';

class FavouriteController extends GetxController {
  static FavouriteController get instance => Get.find();

  /// -Variables
  final favourites = <String, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    initFavourite();
  }

  // -Method to initialize favourite by reading from storage
  void initFavourite() {
    final json = ELocalStorage.instance().readData('favourites');
    if (json != null) {
      final storedFavourites = jsonDecode(json) as Map<String, dynamic>;
      favourites.assignAll(
          storedFavourites.map((key, value) => MapEntry(key, value as bool)));
    }
  }

  bool isFavourite(String productId) {
    return favourites[productId] ?? false;
  }

  void toggleFavouriteProduct(String productId) {
    if (!favourites.containsKey(productId)) {
      favourites[productId] = true;
      savFavouritesToStorage();
      ELoaders.customToast(message: 'Product has been added to the wishlist');
    } else {
      ELocalStorage.instance().removeData(productId);
      favourites.remove(productId);
      savFavouritesToStorage();
      favourites.refresh();
      ELoaders.customToast(
          message: 'Product has been removed from the wishlist');
    }
  }

  void savFavouritesToStorage() {
    final encodedFavourites = jsonEncode(favourites);
    ELocalStorage.instance().saveData('favourites', encodedFavourites);
  }

  Future<List<ProductModel>> favouriteProducts() async {
    return await ProductRepository.instance
        .getFavouriteProducts(favourites.keys.toList());
  }
}
