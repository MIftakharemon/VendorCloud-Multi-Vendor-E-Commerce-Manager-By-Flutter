
import 'package:flutter/material.dart';
import 'package:karmalab_assignment/common/widgets/shimmers/shimmer.dart';
import 'package:karmalab_assignment/utils/constants/sizes.dart';

import '../layouts/grid_layout.dart';

class VerticalProductShimmer extends StatelessWidget {
  const VerticalProductShimmer({
    super.key,
    this.itemCount = 4,
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return GridLayout(
      itemCount: itemCount,
      itemBuilder: (_, __) => const SizedBox(
        width: 180,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomShimmerEffect(width: 180, height: 180),
            SizedBox(height: Sizes.spaceBtwItems),
            CustomShimmerEffect(width: 160, height: 15),
            SizedBox(height: Sizes.spaceBtwItems / 2),
            CustomShimmerEffect(width: 110, height: 15),
          ],
        ),
      ),
    );
  }
}
