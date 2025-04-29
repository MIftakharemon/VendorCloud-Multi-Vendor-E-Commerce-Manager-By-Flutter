import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karmalab_assignment/screens/product_reviews/widgets/rating_indicator.dart';
import 'package:karmalab_assignment/utils/constants/colors.dart';
import 'package:karmalab_assignment/utils/constants/sizes.dart';
import 'package:readmore/readmore.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../controllers/review_controller.dart';
import '../../../models/review_model.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/helpers/helper_functions.dart';

class UserReviewCard extends StatelessWidget {
  final Data review;
  final bool isReviewScreen;

  const UserReviewCard({
    super.key,
    required this.review,
    this.isReviewScreen = true,
  });

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    final ReviewController controller = Get.find<ReviewController>();

    if (!isReviewScreen &&
        (review.comment == null || review.comment!.isEmpty)) {
      return SizedBox.fromSize();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: review.user?.avatar != null
                      ? NetworkImage(review.user!.avatar)
                      : const AssetImage(ImageStrings.userProfileImage2)
                          as ImageProvider,
                ),
                const SizedBox(width: Sizes.spaceBtwItems),
                Text(
                  review.user?.name ?? 'Anonymous',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                Data? replyToDelete;
                for (var item in controller.reviews) {
                  if (item.replyTo?.sId == review.sId) {
                    replyToDelete = item;
                    controller.deleteReviewOrComment(replyToDelete!.sId ?? '');
                  }
                }

                controller.deleteReviewOrComment(review.sId ?? '');
              },
              icon: const Icon(Icons.delete),
            )
          ],
        ),
        const SizedBox(height: Sizes.spaceBtwItems),
        if (isReviewScreen) ...[
          Row(
            children: [
              CustomRatingBarIndicator(rating: review.ratings?.toDouble() ?? 0),
              const SizedBox(width: Sizes.spaceBtwItems),
              if (review.createdAt != null && review.createdAt!.isNotEmpty)
                Text(
                  HelperFunctions.getFormattedDate(
                      DateTime.parse(review.createdAt!)),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ],
          ),
          const SizedBox(height: Sizes.spaceBtwItems),
        ],
        ReadMoreText(
          isReviewScreen ? (review.review ?? '') : (review.comment ?? ''),
          trimLines: 2,
          trimExpandedText: ' show less',
          trimCollapsedText: ' show more',
          trimMode: TrimMode.Line,
          moreStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
          lessStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        if (isReviewScreen && review.image != null) ...[
          const SizedBox(height: Sizes.spaceBtwItems),
          ClipRRect(
            borderRadius: BorderRadius.circular(Sizes.cardRadiusLg),
            child: Image.network(
              review.image!,
              width: 110,
              height: 110,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return SizedBox(
                  width: 110,
                  height: 110,
                  child: Center(
                    child: LoadingAnimationWidget.staggeredDotsWave(
                      color: AppColors.primary,
                      size: 40,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 110,
                  height: 110,
                  color: dark ? AppColors.darkerGrey : AppColors.grey,
                  child: const Icon(Icons.error_outline),
                );
              },
            ),
          ),
        ],
        const SizedBox(height: Sizes.sm),
      ],
    );
  }
}
