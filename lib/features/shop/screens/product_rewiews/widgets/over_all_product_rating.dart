import 'package:ecommerce_app/features/shop/screens/product_rewiews/widgets/progress_bar_rating.dart';
import 'package:flutter/material.dart';

class EOverAllProductRating extends StatelessWidget {
  const EOverAllProductRating({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            '4.8',
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
        const Expanded(
          flex: 7,
          child: Column(
            children: [
              ELinearProgressBar(
                text: '5',
                value: 1.0,
              ),
              ELinearProgressBar(
                text: '4',
                value: 0.7,
              ),
              ELinearProgressBar(
                text: '3',
                value: 0.6,
              ),
              ELinearProgressBar(
                text: '2',
                value: 0.5,
              ),
              ELinearProgressBar(
                text: '1',
                value: 0.3,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
