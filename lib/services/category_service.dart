import 'package:karmalab_assignment/constants/network_constants.dart';
import 'package:karmalab_assignment/controllers/base_controller.dart';
import 'package:karmalab_assignment/services/base/auth_client.dart';
import 'package:karmalab_assignment/services/shared_pref_service.dart';
import '../models/category_model.dart';

class CategoryService extends BaseController {
  final SharedPrefService _prefService = SharedPrefService();
  final BaseClient _baseClient = BaseClient();

  // Fetch all categories
  Future<Category?> getAllCategories() async {
    try {
      final sessionId = await _prefService.getSessionId();
      var response = await _baseClient.get(
        NetworkConstants.getAllCategories,
        header: {'Cookie': "connect.sid=$sessionId"},
      ).catchError(handleError);
      if (response['body'] != null) {
        return Category.FromJson(response['body']);
      }
    } catch (e) {
      print('Error fetching categories: $e');
    }
    return null;
  }

  // Fetch category by ID
  Future<Category?> getCategoryById(String id) async {
    try {
      final sessionId = await _prefService.getSessionId();
      var response = await _baseClient.get(
        NetworkConstants.getCategoryById(id),
        header: {'Cookie': "connect.sid=$sessionId"},
      ).catchError(handleError);

      if (response['body'] != null) {
        return Category.FromJson(response['body']);
      }
    } catch (e) {
      print('Error fetching category by ID: $e');
    }
    return null;
  }

  // Create a new category
  Future<Category?> createCategory(dynamic object) async {
    try {
      final sessionId = await _prefService.getSessionId();
      var response = await _baseClient.post(
        NetworkConstants.createCategory,
        object,
        header: {
          'Cookie': "connect.sid=$sessionId",
          'Content-Type': "application/json",
        },
      ).catchError(handleError);

      if (response['body'] != null ) {
        print('The response is: ... ... ... $response');
        return  Category.FromJson(response['body']);
      }
    } catch (e) {
      print('Error creating category: $e');
    }
    return null;
  }

  // Update category by ID
  Future<bool> updateCategoryById(String id, dynamic object) async {
    try {
      final sessionId = await _prefService.getSessionId();
      var response = await _baseClient.patch(
        NetworkConstants.updateCategoryById(id),
        object,
        header: {
          'Cookie': "connect.sid=$sessionId",
          'Content-Type': "application/json",
        },
      ).catchError(handleError);

      if (response['body'] != null) {
        return true;
      }
    } catch (e) {
      print('Error updating category by ID: $e');
    }
    return false;
  }

  // Delete category by ID
  Future<bool> deleteCategoryById(String id) async {
    try {
      final sessionId = await _prefService.getSessionId();
      var response = await _baseClient.delete(
        NetworkConstants.deleteCategoryById(id),
        header: {'Cookie': "connect.sid=$sessionId"},
      ).catchError(handleError);

      if (response['body'] == null) {
        return true;
      }
    } catch (e) {
      print('Error deleting category by ID: $e');
    }
    return false;
  }


  Future<bool> deleteSubCategoryId(String id) async {
    try {
      print('The id is: $id');
      final sessionId = await _prefService.getSessionId();
      var response = await _baseClient.delete(
        NetworkConstants.deleteSubCategoryById(id),
        header: {'Cookie': "connect.sid=$sessionId"},
      ).catchError(handleError);

      if (response['body'] == null) {
        return true;
      }
    } catch (e) {
      print('Error deleting category by ID: $e');
    }
    return false;
  }
}
