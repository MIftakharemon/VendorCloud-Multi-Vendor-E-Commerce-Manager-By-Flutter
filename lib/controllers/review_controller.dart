import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:karmalab_assignment/controllers/user_controller.dart';
import '../../models/review_model.dart';
import '../services/review_services.dart';
import 'image_controller.dart';

class ReviewController extends GetxController {
  static ReviewController get instance => Get.find();
  final ReviewRepository _reviewRepository = Get.find();
  final MediaController mediaController = Get.put(MediaController());
  final UserController userController = Get.find<UserController>();


  final TextEditingController reviewController = TextEditingController();
  final TextEditingController commentController = TextEditingController();
  final RxMap<String, TextEditingController> replyControllers = <String, TextEditingController>{}.obs;

// Method to get or create controller for specific review
  TextEditingController getReplyController(String reviewId) {
    if (!replyControllers.containsKey(reviewId)) {
      replyControllers[reviewId] = TextEditingController();
    }
    return replyControllers[reviewId]!;
  }

  final RxInt rating = 0.obs;


  final RxList<dynamic> reviews = <Data>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxDouble averageRating = 0.0.obs;
  final RxMap<dynamic, dynamic> ratingDistribution = <int, double>{}.obs;
  final RxString currentProductId = ''.obs;


  StreamSubscription? _reviewSubscription;

  @override
  void onInit() {
    super.onInit();
    ever(currentProductId, (_) => getProductReviews(currentProductId.value));
  }

  void setCurrentProduct(String productId) {
    currentProductId.value = productId;
  }

  Future<void> createReview(String productId, {Function(bool, {String? errorMessage})? onComplete}) async {
    try {
      if (reviewController.text.isEmpty &&  commentController.text.isEmpty) {
        throw 'Cannot be empty';
      }


      isLoading.value = true;
      error.value = '';

      final user = userController.user.value;
      if (user == null) {
        throw 'User not found';
      }

      final review = Data(
        user: user.id,
        image: mediaController.imageBase64,
        product: productId,
        ratings: rating.value,
        review: reviewController.text.isNotEmpty ?reviewController.text : null,
        comment: commentController.text.isNotEmpty ? commentController.text : null,
      );

      final success = await _reviewRepository.createReview(review.toJson());

      if (success) {
        String imageBase64 = mediaController.imageBase64 ?? '';

        final newReview = Data(
          user: user,
          image: imageBase64,
          product: productId,
          ratings: rating.value,
          review: reviewController.text.isNotEmpty ? reviewController.text : null,
          comment: commentController.text.isNotEmpty ? commentController.text : null,
          createdAt: DateTime.now().toIso8601String(),
        );

        reviews.insert(0, newReview);
        calculateRatingDistribution();


        reviewController.clear();
        commentController.clear();
        rating.value = 0;
        mediaController.removeCoverPhoto();

        if (onComplete != null) onComplete(true);
      } else {
        if (onComplete != null) onComplete(false, errorMessage: 'Failed to create review');
      }
    } catch (e) {
      error.value = e.toString();
      if (onComplete != null) onComplete(false, errorMessage: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getProductReviews(String productId) async {
    if (productId.isEmpty) return;

    try {
      isLoading.value = true;
      error.value = '';
      final result = await _reviewRepository.getProductReviews(productId);
      if (result != null && result.data != null) {
        reviews.assignAll(result.data!);
        calculateRatingDistribution();
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }





// Update createReply method to use specific controller
  Future<void> createReply(String productId, String replyToId, {Function(bool, {String? errorMessage})? onComplete}) async {
    try {
      final replyController = getReplyController(replyToId);
      if (replyController.text.isEmpty) {
        throw 'Reply cannot be empty';
      }

      isLoading.value = true;
      error.value = '';

      final user = userController.user.value;
      if (user == null) {
        throw 'User not found';
      }

      final replyData = {
        "user": user.id,
        "product": productId,
        "comment": replyController.text,
        "replyTo": replyToId
      };

      final success = await _reviewRepository.createReview(replyData);

      if (success) {
        await getProductReviews(productId);
        replyController.clear();
        if (onComplete != null) onComplete(true);
      } else {
        if (onComplete != null) onComplete(false, errorMessage: 'Failed to create reply');
      }
    } catch (e) {
      error.value = e.toString();
      if (onComplete != null) onComplete(false, errorMessage: e.toString());
    } finally {
      isLoading.value = false;
    }
  }




  Future<void> deleteReviewOrComment(String reviewId) async {
    if (reviewId.isEmpty) return;
    try {
      isLoading.value = true;
      error.value = '';
     await _reviewRepository.DeleteReview(reviewId);
      reviews.removeWhere((review) => review.sId == reviewId);

    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void calculateRatingDistribution() {
    if (reviews.isEmpty) return;
    Map<int, int> ratingCounts = {};
    double totalRating = 0;
    double totalReviews = 0;
    for (var review in reviews) {

      if (review.ratings != null && (review.comment != null && review.comment!.trim().length <=0)) {

        ratingCounts[review.ratings!] = (ratingCounts[review.ratings!] ?? 0) + 1;
        totalRating += review.ratings!;
        totalReviews += 1;
        ('Found valid review - Rating: ${review.ratings}');
      }
    }


    averageRating.value = totalReviews > 0 ? totalRating / totalReviews : 0.0;
    for (int i = 1; i <= 5; i++) {
      ratingDistribution[i] = totalReviews > 0 ? (ratingCounts[i] ?? 0) / totalReviews : 0.0;
    }
  }


  int getRatingCount(int rating) {return reviews.where((review) => review.ratings == rating && review.review != null && review.review!.isNotEmpty).length;}



  double getRatingPercentage(int rating) {
    if (reviews.isEmpty) return 0.0;
    int count = getRatingCount(rating);
    return count / reviews.length;
  }


  @override
  void onClose() {
    _reviewSubscription?.cancel();
    for (var controller in replyControllers.values) {
      controller.dispose();
    }
    replyControllers.clear();
    super.onClose();
  }
}