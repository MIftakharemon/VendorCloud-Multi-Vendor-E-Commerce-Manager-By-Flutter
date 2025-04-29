import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/image_controller.dart';
import '../../../controllers/review_controller.dart';

class CreateInputBottomSheet extends StatelessWidget {
  final String productId;
  final VoidCallback? onSubmitted;
  final bool isQueryScreen;

  const CreateInputBottomSheet({
    Key? key,
    required this.productId,
    this.onSubmitted,
    this.isQueryScreen = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReviewController>();
    final mediaController = Get.find<MediaController>();
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + Sizes.defaultSpace / 2,
        left: Sizes.defaultSpace / 2,
        right: Sizes.defaultSpace / 2,
        top: Sizes.defaultSpace / 2,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 30,
              height: 3,
              margin: const EdgeInsets.only(bottom: Sizes.defaultSpace / 2),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isQueryScreen ? 'Ask a Question' : 'Write a Review',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                  fontSize: 18,
                ),
              ),
              IconButton(
                onPressed: () {
                  if (!isQueryScreen) mediaController.removeCoverPhoto();
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close, color: theme.primaryColor),
              ),
            ],
          ),
          const SizedBox(height: Sizes.spaceBtwItems),

          if (!isQueryScreen) ...[
            Center(
              child: Column(
                children: [
                  Obx(() => Text(
                    controller.rating.value == 0
                        ? 'Tap to Rate'
                        : '${controller.rating.value}/5',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: controller.rating.value == 0
                          ? Colors.grey
                          : Colors.amber,
                      fontSize: 16,
                    ),
                  )),
                  const SizedBox(height: Sizes.spaceBtwItems / 2),
                  RatingBar.builder(
                    initialRating: controller.rating.value.toDouble(),
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemSize: 30,
                    unratedColor: Colors.amber.withOpacity(0.2),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star_rounded,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      controller.rating.value = rating.toInt();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: Sizes.spaceBtwItems),
          ],

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Obx(() => TextField(
                  controller: isQueryScreen? controller.commentController:controller.reviewController,
                  maxLines: 4,
                  maxLength: 200,
                  style: theme.textTheme.bodyLarge,
                  decoration: InputDecoration(
                    hintText: isQueryScreen
                        ? 'What would you like to know about this product?'
                        : 'Share your thoughts about the product...',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: theme.primaryColor,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.red[300]!),
                    ),
                    filled: true,
                    fillColor: theme.cardColor,
                    errorText: controller.error.value.isNotEmpty
                        ? controller.error.value
                        : null,
                    contentPadding: const EdgeInsets.all(12),
                  ),
                  onChanged: (value) => controller.error.value = '',
                )),
              ),
              if (!isQueryScreen) ...[
                const SizedBox(width: Sizes.defaultSpace / 2),
                GestureDetector(
                  onTap: () async {
                    await mediaController.imagePickerAndBase64Conversion();
                  },
                  onDoubleTap: () {
                    mediaController.removeCoverPhoto();
                  },
                  child: Obx(() {
                    String imageBase64 = mediaController.imageBase64 ?? '';
                    String imageUrl = mediaController.imageUrl ?? '';

                    return Container(
                      width: 107,
                      height: 107,
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.primaryColor.withOpacity(0.3),
                          width: 2,
                        ),
                        image: imageBase64.isNotEmpty
                            ? DecorationImage(
                          image: MemoryImage(
                              base64Decode(imageBase64.split(',').last)),
                          fit: BoxFit.cover,
                        )
                            : imageUrl.isNotEmpty
                            ? DecorationImage(
                          image: Image.network(imageUrl).image,
                          fit: BoxFit.cover,
                        )
                            : null,
                        boxShadow: [
                          BoxShadow(
                            color: theme.primaryColor.withOpacity(0.1),
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: imageBase64.isEmpty && imageUrl.isEmpty
                          ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.camera,
                            color: theme.primaryColor.withOpacity(0.7),
                            size: 30,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Add Photo',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.primaryColor.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      )
                          : null,
                    );
                  }),
                ),
              ],
            ],
          ),
          const SizedBox(height: Sizes.spaceBtwItems),

          SizedBox(
            width: double.infinity,
            child: Obx(() => ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : () async {
                if (!isQueryScreen && controller.rating.value == 0) {
                  Get.snackbar(
                    'Rating Required',
                    'Please select a rating before submitting',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red[100],
                    colorText: Colors.red[900],
                    borderRadius: 10,
                    margin: const EdgeInsets.all(10),
                  );
                  return;
                }

                if (controller.reviewController.text.trim().isEmpty && controller.commentController.text.trim().isEmpty) {
                  controller.error.value = isQueryScreen
                      ? 'Please write your question'
                      : 'Please write a review';
                  return;
                }

                await controller.createReview(
                  productId,
                  onComplete: (success, {errorMessage}) {
                    if (success) {
                      if (!isQueryScreen) {
                        controller.rating.value = 0;
                        mediaController.removeCoverPhoto();
                      }
                      controller.reviewController.clear();
                      controller.commentController.clear();
                      _clearAllStates(controller, mediaController);

                      Navigator.pop(context);

                      onSubmitted?.call();

                      Get.snackbar(
                        isQueryScreen ? 'Question Submitted' : 'Review Submitted',
                        isQueryScreen
                            ? 'Your question has been submitted successfully!'
                            : 'Thank you for your feedback!',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green[100],
                        colorText: Colors.green[900],
                        borderRadius: 10,
                        margin: const EdgeInsets.all(10),
                      );
                    } else {
                      Get.snackbar(
                        'Submission Failed',
                        errorMessage ?? 'Please try again later',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red[100],
                        colorText: Colors.red[900],
                        borderRadius: 10,
                        margin: const EdgeInsets.all(10),
                      );
                    }
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                backgroundColor: theme.primaryColor,
              ),
              child: controller.isLoading.value
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
                  : Text(
                isQueryScreen ? 'Submit Question' : 'Submit Review',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )),
          ),
        ],
      ),
    );
  }

  void _clearAllStates(ReviewController reviewController, MediaController mediaController) {
    reviewController.rating.value = 0;
    reviewController.reviewController.clear();
    reviewController.commentController.clear();
    reviewController.error.value = '';
    if (!isQueryScreen) {
      mediaController.removeCoverPhoto();
    }
  }
}
