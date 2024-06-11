import 'package:ecommerce_app/common/widgets/images/e_circular_image.dart';
import 'package:ecommerce_app/util/constants/colors.dart';
import 'package:ecommerce_app/util/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

import '../../../util/constants/sizes.dart';

class EVerticalImageText extends StatelessWidget {
  const EVerticalImageText({
    super.key,
    required this.title,
    required this.image,
    this.textColor = EColors.white,
    this.backGroundColor,
    this.onTap,
    this.isNetworkImage = true,
  });
  final String title, image;
  final Color textColor;
  final bool isNetworkImage;
  final Color? backGroundColor;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: ESizes.spaceBtItems),
        child: Column(
          children: [
            ECircularImage(
              image: image,
              fit: BoxFit.fitWidth,
              padding: ESizes.sm * 1.4,
              isNetworkImage: isNetworkImage,
              backgroundColor: backGroundColor,
              overlayColor: dark ? EColors.light : EColors.dark,
            ),
            const SizedBox(
              width: ESizes.spaceBtItems / 2,
            ),
            SizedBox(
              width: 55,
              child: Center(
                child: Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .apply(color: textColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
