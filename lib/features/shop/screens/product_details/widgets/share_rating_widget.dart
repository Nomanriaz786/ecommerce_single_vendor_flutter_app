import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../util/constants/sizes.dart';

class EProductShareRatingWidget extends StatelessWidget {
  const EProductShareRatingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ///Rating
        Row(
          children: [
            const Icon(
              Iconsax.star5,
              color: Colors.amber,
              size: 24,
            ),
            const SizedBox(
              width: ESizes.spaceBtItems / 2,
            ),
            Text.rich(
              TextSpan(children: [
                TextSpan(
                  text: '5.0',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const TextSpan(text: '(1000)')
              ]),
            ),
          ],
        ),

        ///Share
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.share,
            size: ESizes.iconMd,
          ),
        )
      ],
    );
  }
}
