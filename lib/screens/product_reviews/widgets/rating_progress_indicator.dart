import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../controllers/review_controller.dart';
import 'progress_indicator_and_rating.dart';

class OverallProductRating extends StatelessWidget {
   OverallProductRating({super.key,required this.rating});
   final double rating;
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReviewController>();

    return Obx(() => Row(
      children: [

        Expanded(
            flex: 3,
            child:


            Text(
              rating.toStringAsFixed(1),
              style: Theme.of(context).textTheme.displayLarge,
            )

        ),

        Expanded(
          flex: 7,
          child: Column(
            children: [
              RatingProgressIndicator(
                text: '5',
                value: controller.getRatingPercentage(5),
                ratingCount: controller.getRatingCount(5),
              ),
              RatingProgressIndicator(
                text: '4',
                value: controller.getRatingPercentage(4),
                ratingCount: controller.getRatingCount(4),
              ),
              RatingProgressIndicator(
                text: '3',
                value: controller.getRatingPercentage(3),
                ratingCount: controller.getRatingCount(3),
              ),
              RatingProgressIndicator(
                text: '2',
                value: controller.getRatingPercentage(2),
                ratingCount: controller.getRatingCount(2),
              ),
              RatingProgressIndicator(
                text: '1',
                value: controller.getRatingPercentage(1),
                ratingCount: controller.getRatingCount(1),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}