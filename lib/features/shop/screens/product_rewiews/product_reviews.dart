import 'package:ecommerce_app/common/widgets/appbar/app_bar.dart';
import 'package:ecommerce_app/common/widgets/products/rating/rating_bar_indicator.dart';
import 'package:ecommerce_app/features/shop/screens/product_rewiews/widgets/over_all_product_rating.dart';
import 'package:ecommerce_app/features/shop/screens/product_rewiews/widgets/user_review_card.dart';
import 'package:ecommerce_app/util/constants/sizes.dart';
import 'package:flutter/material.dart';

class ProductReviewsScreen extends StatelessWidget {
  const ProductReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///Appbar
      appBar: const EAppBar(
        showBackArrow: true,
        title: Text('Reviews & Rating'),
      ),

      ///Body
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(ESizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  'Reviews and ratings are verified and are from those people whose use the same device you use'),
              const SizedBox(
                height: ESizes.spaceBtItems,
              ),

              /// Overall product rating
              const EOverAllProductRating(),
              const ERatingBarIndicator(
                value: 3.5,
              ),
              Text(
                '12,000',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(
                height: ESizes.spaceBtSections,
              ),
              const EUserReviewCard(),
              const EUserReviewCard(),
              const EUserReviewCard(),
              const EUserReviewCard(),
            ],
          ),
        ),
      ),
    );
  }
}
