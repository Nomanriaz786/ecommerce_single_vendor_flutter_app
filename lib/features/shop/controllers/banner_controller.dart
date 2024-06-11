import 'package:ecommerce_app/data/Banners/banner_repository.dart';
import 'package:ecommerce_app/features/shop/models/banner_model.dart';
import 'package:ecommerce_app/util/popup/loaders.dart';
import 'package:get/get.dart';

class BannerController extends GetxController {
  /// -Variables
  final isLoading = false.obs;
  final carouselCurrentIndex = 0.obs;
  final RxList<BannerModel> banners = <BannerModel>[].obs;

  @override
  void onInit() {
    fetchBanners();
    super.onInit();
  }

  /// -Update page navigation
  void updatePageIndicator(index) {
    carouselCurrentIndex.value = index;
  }

  /// -Fetch Banner
  Future<void> fetchBanners() async {
    try {
      // -Show loader while categories are loaded
      isLoading.value = true;
      // -Fetch Banners
      final bannerRepository = Get.put(BannerRepository());
      final banners = await bannerRepository.fetchBanners();

      // -Update the banners list
      this.banners.assignAll(banners);
    } catch (e) {
      // -Show some generic error to the user
      ELoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      //  -Remove Loader
      isLoading.value = false;
    }
  }
}
