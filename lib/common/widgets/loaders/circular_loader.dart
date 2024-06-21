import 'package:ecommerce_app/util/constants/colors.dart';
import 'package:flutter/material.dart';

class ECircularLoader extends StatelessWidget {
  const ECircularLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        backgroundColor: EColors.primary,
        color: Colors.white,
      ),
    );
  }
}
