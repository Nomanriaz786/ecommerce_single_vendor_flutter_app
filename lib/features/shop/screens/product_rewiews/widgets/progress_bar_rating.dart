import 'package:ecommerce_app/util/constants/colors.dart';
import 'package:ecommerce_app/util/devices/device_utility.dart';
import 'package:flutter/material.dart';

class ELinearProgressBar extends StatelessWidget {
  const ELinearProgressBar({
    super.key,
    required this.text,
    required this.value,
  });
  final String text;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        flex: 1,
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
      Expanded(
        flex: 11,
        child: SizedBox(
          width: EDeviceUtils.getScreenWidth(context) * 0.8,
          child: LinearProgressIndicator(
            value: value,
            minHeight: 11,
            backgroundColor: EColors.grey,
            borderRadius: BorderRadius.circular(7),
            valueColor: const AlwaysStoppedAnimation(EColors.primary),
          ),
        ),
      ),
    ]);
  }
}
