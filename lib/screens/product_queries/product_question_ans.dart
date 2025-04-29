import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:karmalab_assignment/utils/constants/colors.dart';
import 'package:karmalab_assignment/utils/constants/sizes.dart';
import '../../common/widgets/appbar/appbar.dart';
import '../../controllers/review_controller.dart';
import '../product_reviews/widgets/create_review_bottom_sheet.dart';
import '../product_reviews/widgets/user_review_card.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ProductQuestionAnswerScreen extends StatelessWidget {
  final String productId;

  const ProductQuestionAnswerScreen({
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
      backgroundColor: Colors.grey[100],
appBar: PreferredSize(
  preferredSize: Size.fromHeight(kToolbarHeight),
  child: CustomAppBar(
    title: Text('Questions & Answers'),
    showBackArrow: true,
  ).animate().fadeIn(duration: 600.ms),
),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateReviewSheet(context, controller),
        label: const Text('Ask Question'),
        icon: const Icon(Icons.question_answer_outlined),
      ).animate()
          .fadeIn(delay: Duration(milliseconds: 400))
          .slideY(begin: 1, end: 0),
      body: Obx(() {
        final mainComments = controller.reviews
            .where((review) =>
        review.comment?.isNotEmpty == true && review.replyTo == null)
            .toList();

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
          return Center(
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
                Text(
                  controller.error.value,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: Sizes.spaceBtwItems),
                ElevatedButton.icon(
                  onPressed: () => controller.getProductReviews(productId),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ).animate().fadeIn(duration: Duration(milliseconds: 600)),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${mainComments.length} Questions',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ).animate()
                      .fadeIn(duration: Duration(milliseconds: 600))
                      .slideX(begin: -0.2, end: 0),
                  const SizedBox(height: Sizes.spaceBtwItems),
                  mainComments.isEmpty
                      ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(Sizes.defaultSpace),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.question_answer_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: Sizes.spaceBtwItems),
                          Text(
                            'No questions yet. Be the first to ask!',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ).animate()
                        .fadeIn(duration: Duration(milliseconds: 800))
                       .scale(begin: Offset(0.8, 0.8))
                  )
                      : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: mainComments.length,
                    separatorBuilder: (context, index) =>
                    const SizedBox(height: Sizes.spaceBtwItems),
                    itemBuilder: (context, index) {
                      final mainComment = mainComments[index];
                      final replies = repliesMap[mainComment.sId] ?? [];

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
                                review: mainComment,
                                isReviewScreen: false,
                              ).animate()
                                  .fadeIn(duration: Duration(milliseconds: 600))
                                  .slideX(begin: 0.2, end: 0),
                              if (replies.isNotEmpty) ...[
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: Sizes.sm),
                                  child: Divider(height: 1),
                                ),
                                ...replies.map((reply) => Container(
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
                                          const SizedBox(width: Sizes.sm),
                                          Text(
                                            'Vendor Reply',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.copyWith(
                                              fontWeight:
                                              FontWeight.bold,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
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
                                ).animate()
                                    .fadeIn(
                                    duration: Duration(milliseconds: 600),
                                    delay: Duration(milliseconds: 200 * replies.indexOf(reply))
                                )
                                    .slideX(begin: 0.2, end: 0))
                              ],
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
                                            mainComment.sId!),
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
                                        mainComment.sId!,
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
                                          size: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ).animate()
                                  .fadeIn(
                                  duration: Duration(milliseconds: 600),
                                  delay: Duration(milliseconds: 400)
                              )
                                  .slideY(begin: 0.2, end: 0),
                            ],
                          ),
                        ),
                      ).animate()
                          .fadeIn(
                          duration: Duration(milliseconds: 800),
                          delay: Duration(milliseconds: 100 * index)
                      )
                          .slideY(begin: 0.2, end: 0);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  void _showCreateReviewSheet(BuildContext context, ReviewController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => CreateInputBottomSheet(
        isQueryScreen: true,
        productId: productId,
        onSubmitted: () {
          controller.getProductReviews(productId);
        },
      ),
    );
  }
}
