import 'package:get/get.dart';
import '../../../services/base/auth_client.dart';
import '../../../services/shared_pref_service.dart';
import '../constants/network_constants.dart';
import '../models/review_model.dart';

class ReviewRepository extends GetxController {
  static ReviewRepository get instance => Get.find();
  final SharedPrefService _prefService = SharedPrefService();
  final BaseClient _baseClient = BaseClient();

  Future<reviewModel?> getProductReviews(String productId) async {
    try {
      final sessionId = await _prefService.getSessionId();
      final response = await _baseClient.get(
        NetworkConstants.getReviewsByProductId(productId),
        header: {'Cookie': "connect.sid=$sessionId"},
      );
      return response['body'] != null
          ? reviewModel.fromJson(response['body'])
          : null;
    } catch (e) {
      return null;
    }
  }

  Future<bool?> DeleteReview(String reviewId) async {
    try {
      final sessionId = await _prefService.getSessionId();
      await _baseClient.delete(
        NetworkConstants.deleteReviewById(reviewId),
        header: {'Cookie': "connect.sid=$sessionId"},
      );
      return true;
    } catch (e) {
      return null;
    }
  }

  Future<bool> createReview(dynamic reviewData) async {
    try {
      final sessionId = await _prefService.getSessionId();
      final response = await _baseClient.post(
        NetworkConstants.createReview,
        reviewData,
        header: {
          'Cookie': "connect.sid=$sessionId",
          'Content-Type': "application/json",
        },
      );
      return response['body'] != null && response['body'].containsKey('data');
    } catch (e) {
      return false;
    }
  }
}
