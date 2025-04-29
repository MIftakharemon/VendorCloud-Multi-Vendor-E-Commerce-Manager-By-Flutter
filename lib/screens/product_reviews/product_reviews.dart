import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../../utils/constants/colors.dart';
import '../../common/widgets/appbar/appbar.dart';
import '../../controllers/review_controller.dart';
import '../../utils/constants/sizes.dart';
import 'widgets/create_review_bottom_sheet.dart';
import 'widgets/rating_indicator.dart';
import 'widgets/rating_progress_indicator.dart';
import 'widgets/user_review_card.dart';
import 'package:get/get.dart';

class ProductReviewsScreen extends StatelessWidget {
  final String productId;

  const ProductReviewsScreen({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReviewController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.setCurrentProduct(productId);
      controller.getProductReviews(productId);
    });

    return Scaffold(
      appBar: const CustomAppBar(
        title: Text('Reviews & Ratings'),
        showBackArrow: true,
      ),
      body: Obx(
        () {
          final reviews = controller.reviews.where((review) =>
          review.review?.isNotEmpty == true && review.replyTo == null).toList();

          final repliesMap = <String, List<dynamic>>{};
          for (var review in controller.reviews) {
            if (review.replyTo != null) {
              final parentId = review.replyTo!.sId!;
              if (!repliesMap.containsKey(parentId)) {
                repliesMap[parentId] = [];
              }
              repliesMap[parentId]!.add(review);
            }
          }

          if (controller.isLoading.value) {
            return
              Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: AppColors.primary,
                size: 40,
              ),
            );
          }
          if (controller.error.value.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(controller.error.value),
                  ElevatedButton(
                    onPressed: () => controller.getProductReviews(productId),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => controller.getProductReviews(productId),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(Sizes.defaultSpace),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => OverallProductRating(rating: controller.averageRating.value,),),
                    Obx(() => CustomRatingBarIndicator(rating: controller.averageRating.value,)),
                    Text(
                      '${reviews.length} Reviews',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: Sizes.spaceBtwSections),
                    Obx(() {
                      if (controller.reviews.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(Sizes.defaultSpace),
                            child:
                                Text('No reviews yet!'),
                          ),
                        );
                      }

                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: reviews.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: Sizes.spaceBtwItems),
                        itemBuilder: (context, index) {
                          final totalreview = reviews[index];
                          final replies = repliesMap[totalreview.sId] ?? [];

                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                              borderRadius:
                                  BorderRadius.circular(Sizes.cardRadiusLg),
                            ),
                            margin: EdgeInsets.zero,
                            child: Padding(
                              padding: const EdgeInsets.all(Sizes.md),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  UserReviewCard(
                                    review: totalreview,
                                  ),
                                  if (replies.isNotEmpty) ...[
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: Sizes.sm),
                                      child: Divider(height: 1),
                                    ),
                                    ...replies
                                        .map((reply) => Container(
                                              margin: const EdgeInsets.only(
                                                  left: Sizes.lg),
                                              padding: const EdgeInsets.only(
                                                  left: Sizes.sm),
                                              decoration: const BoxDecoration(
                                                border: Border(
                                                  left: BorderSide(
                                                    color: AppColors.primary,
                                                    width: 2,
                                                  ),
                                                ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const CircleAvatar(
                                                        backgroundColor:
                                                            AppColors.primary,
                                                        radius: 12,
                                                        child: Icon(
                                                          Icons.store,
                                                          size: 16,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          width: Sizes.sm),
                                                      Text(
                                                        'Vendor Reply',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleSmall
                                                            ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: AppColors
                                                                  .primary,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: Sizes.lg + Sizes.xs,
                                                      top: Sizes.xs,
                                                    ),
                                                    child: Text(
                                                      reply.comment ?? '',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ))
                                        .toList(),
                                  ],
                                  SizedBox(
                                    height: Sizes.sm,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                      left: Sizes.lg + Sizes.xs,
                                      right: Sizes.sm,
                                      top: Sizes.xs,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            controller:
                                                controller.getReplyController(
                                                    totalreview.sId!),
                                            decoration: InputDecoration(
                                              hintText: 'Write a reply...',
                                              isDense: true,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Sizes.borderRadiusMd),
                                                borderSide: BorderSide(
                                                    color:
                                                        Colors.grey.shade300),
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: Sizes.sm,
                                                vertical: Sizes.xs,
                                              ),
                                            ),
                                            style: const TextStyle(
                                              fontSize: Sizes.fontSizeSm,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: Sizes.sm),
                                        InkWell(
                                          onTap: () => controller.createReply(
                                            productId,
                                            totalreview.sId!,
                                            onComplete: (success,
                                                {errorMessage}) {
                                              if (!success &&
                                                  errorMessage != null) {
                                                Get.snackbar(
                                                    'Error', errorMessage);
                                              }
                                            },
                                          ),
                                          child: Container(
                                            padding:
                                                const EdgeInsets.all(Sizes.sm),
                                            decoration: BoxDecoration(
                                              color: AppColors.primary,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Sizes.borderRadiusMd),
                                            ),
                                            child: const Icon(
                                              Icons.send,
                                              color: Colors.white,
                                              size:12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
