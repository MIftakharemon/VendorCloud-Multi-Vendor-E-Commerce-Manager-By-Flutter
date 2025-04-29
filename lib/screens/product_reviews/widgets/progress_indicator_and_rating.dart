import 'package:flutter/material.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/device/device_utility.dart';

class RatingProgressIndicator extends StatelessWidget {
  const RatingProgressIndicator({
    super.key,
    required this.text,
    required this.value,
    required this.ratingCount,
  });

  final String text;
  final double value;
  final int ratingCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        Expanded(
            flex: 1,
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium)
        ),

        Expanded(
          flex: 8,
          child: SizedBox(
            width: DeviceUtils.getScreenWidth(context) * 0.5,
            child: LinearProgressIndicator(
              value: value,
              minHeight: 11,
              backgroundColor: AppColors.grey,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              borderRadius: BorderRadius.circular(7),
            ),
          ),
        ),

        Expanded(
          flex: 3,
          child:
          Text(
            ' ($ratingCount)',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }
}