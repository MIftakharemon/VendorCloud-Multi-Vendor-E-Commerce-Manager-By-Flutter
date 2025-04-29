
import 'package:flutter/material.dart';
import 'package:karmalab_assignment/common/widgets/shimmers/shimmer.dart';
import 'package:karmalab_assignment/utils/constants/sizes.dart';

class ListTileShimmer extends StatelessWidget {
  const ListTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [
            CustomShimmerEffect(width: 50, height: 50, radius: 50),
            SizedBox(width: Sizes.spaceBtwItems),
            Column(
              children: [
                CustomShimmerEffect(width: 100, height: 15),
                SizedBox(height: Sizes.spaceBtwItems / 2),
                CustomShimmerEffect(width: 80, height: 12),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
