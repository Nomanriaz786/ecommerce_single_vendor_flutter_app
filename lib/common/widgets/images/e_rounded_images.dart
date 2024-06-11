import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/util/constants/sizes.dart';
import 'package:flutter/material.dart';

import '../shimmers/shimmer.dart';

class ERoundedImage extends StatelessWidget {
  const ERoundedImage({
    super.key,
    this.width,
    this.height,
    required this.imageUrl,
    this.applyImageRadius = true,
    this.border,
    this.backGroundColor,
    this.fit = BoxFit.contain,
    this.isNetworkImage = false,
    this.padding,
    this.onPressed,
    this.borderRadius = ESizes.md,
  });
  final double? width, height;
  final String imageUrl;
  final bool applyImageRadius;
  final BoxBorder? border;
  final Color? backGroundColor;
  final BoxFit? fit;
  final bool isNetworkImage;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: backGroundColor,
          border: border,
        ),
        child: ClipRRect(
          borderRadius: applyImageRadius
              ? BorderRadius.circular(borderRadius)
              : BorderRadius.zero,
          child: isNetworkImage
              ? CachedNetworkImage(
                  imageUrl: imageUrl,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      const EShimmerEffect(width: double.infinity, height: 190),
                  errorWidget: (context, url, downloadProgress) =>
                      const Icon(Icons.error),
                )
              : Image(
                  image: AssetImage(imageUrl),
                ),
        ),
      ),
    );
  }
}
