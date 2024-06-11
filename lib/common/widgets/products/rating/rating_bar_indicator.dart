import 'package:ecommerce_app/util/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconsax/iconsax.dart';

class ERatingBarIndicator extends StatelessWidget {
  const ERatingBarIndicator({
    super.key,
    required this.value,
  });
  final double value;
  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
      rating: value,
      unratedColor: EColors.grey,
      itemSize: 20,
      itemBuilder: (_, __) => const Icon(
        Iconsax.star1,
        color: EColors.primary,
      ),
    );
  }
}
