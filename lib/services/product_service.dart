import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:karmalab_assignment/constants/network_constants.dart';
import 'package:karmalab_assignment/controllers/base_controller.dart';
import 'package:karmalab_assignment/services/base/auth_client.dart';
import 'package:karmalab_assignment/services/shared_pref_service.dart';
import '../controllers/product_controller.dart';
import '../models/product_model.dart';
import '../utils/exceptions/firebase_exceptions.dart';

class ProductService extends BaseController {
  final SharedPrefService _prefService = SharedPrefService();
  final BaseClient _baseClient = BaseClient();
  late  final allProduct? product;


  Future<allProduct?> getProducts({required String userId}) async {
    try {
      final sessionId = await _prefService.getSessionId();
      var response = await _baseClient.get(NetworkConstants.getUserProducts(userId),

        header: {'Cookie': "connect.sid=$sessionId"},
      ).catchError(handleError);

      if (response['body'] != null) {
        return allProduct.fromJson(response['body']);
      }
    } catch (e) {
      Get.snackbar('Error fetching products: $e', '');
    }
    return null;
  }





  Future<allProduct?> getProductById(String id) async {
    try {
      final sessionId = await _prefService.getSessionId();
      var response = await _baseClient.get(NetworkConstants.getProductById(id),
        header: {'Cookie': "connect.sid=$sessionId"},
      ).catchError(handleError);

      if (response['body'] != null) {
        //final productResponse = jsonDecode(response);
        //List<dynamic> data = productResponse['data'];
        return allProduct.fromJson(response['body']);
      }
    } catch (e) {
      print('Error fetching product by ID: $e');
    }
    return null;
  }



  Future<allProduct?> getProductsForSubCategory({
    required String subcategoryId,
    required String userId,
    int limit = 5000
  }) async {
    try {
      final sessionId = await _prefService.getSessionId();
      var response = await _baseClient.get(
        NetworkConstants.getSubCategoryProductsByUser(userId,subcategoryId, limit),
        header: {'Cookie': "connect.sid=$sessionId"},
      ).catchError((e) => throw CustomApiException('Failed to load products'));

      if (response != null) {
        var responseBody = response['body'];
        return allProduct.fromJson(responseBody);
      }
      return null;
    } catch (e) {
      throw CustomApiException('Error fetching products: $e');
    }
  }







  Future<bool> createProduct(dynamic object) async {
    try {
      final sessionId = await _prefService.getSessionId();
      var response = await _baseClient.post(
        NetworkConstants.createProduct,
        object,
        header: {
          'Cookie': "connect.sid=$sessionId",
          'Content-Type': "application/json",
        },
      ).catchError(handleError);
      if (response['body']['status']=='success') {
        return true;
      }


    } catch (e) {
      print('Error creating product: $e');
    }
    return false;
  }


  Future<bool> updateProductById(String id, dynamic object) async {
    try {
      final sessionId = await _prefService.getSessionId();
      var response = await _baseClient.patch(
        NetworkConstants.updateProductById(id),
        object,
        header: {
          'Cookie': "connect.sid=$sessionId",
          'Content-Type': "application/json",
        },
      ).catchError(handleError);

      if (response != null && response['body']['status'] == 'success') {
        return true;
      }
    } catch (e) {}
    return false; // Return false to indicate failure
  }

  // Delete product by ID
  Future<bool> deleteProductById(String id) async {
    try {
      final sessionId = await _prefService.getSessionId();
      var response = await _baseClient.delete(
        NetworkConstants.deleteProductById(id),
        header: {'Cookie': "connect.sid=$sessionId"},
      ).catchError(handleError);

      if (response==null) {
        return true;
      }
    } catch (e) {}
    return false;
  }

  // Toggle like on a product
  Future<bool> toggleLikeProduct(String productId) async {
    try {
      final sessionId = await _prefService.getSessionId();
      var response = await _baseClient.post(
        NetworkConstants.toggleLikeProduct(productId),
        null,
        header: {'Cookie': "connect.sid=$sessionId"},
      ).catchError(handleError);

      if (response['body'] != null) {
        return true;
      }
    } catch (e) {
      print('Error toggling like on product: $e');
    }
    return false;
  }

  // Get reviews by product ID
  Future<List<Reviews>?> getReviewsByProductId(String productId) async {
    try {
      final sessionId = await _prefService.getSessionId();
      var response = await _baseClient.get(
        NetworkConstants.getReviewsByProductId(productId),
        header: {'Cookie': "connect.sid=$sessionId"},
      ).catchError(handleError);

      if (response['body'] != null) {
        List<dynamic> data = json.decode(response['body']);
        return data.map((json) => Reviews.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error fetching reviews by product ID: $e');
    }
    return null;
  }

  // Create a new review
  Future<Reviews?> createReview(dynamic object) async {
    try {
      final sessionId = await _prefService.getSessionId();
      var response = await _baseClient.post(
        NetworkConstants.createReview,
        object,
        header: {
          'Cookie': "connect.sid=$sessionId",
          'Content-Type': "application/json",
        },
      ).catchError(handleError);

      if (response['body'] != null && response['body'].containsKey('data')) {
        var data = response['body']['data'];
        return Reviews.fromJson((data));
      }
    } catch (e) {
      print('Error creating review: $e');
    }
    return null;
  }

  // Delete review by ID
  Future<bool> deleteReviewById(String reviewId) async {
    try {
      final sessionId = await _prefService.getSessionId();
      var response = await _baseClient.delete(
        NetworkConstants.deleteReviewById(reviewId),
        header: {'Cookie': "connect.sid=$sessionId"},
      ).catchError(handleError);

      if (response['body'] != null) {
        return true;
      }
    } catch (e) {
      print('Error deleting review by ID: $e');
    }
    return false;
  }
}