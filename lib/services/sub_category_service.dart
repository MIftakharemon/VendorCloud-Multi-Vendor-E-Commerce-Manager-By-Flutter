import 'package:karmalab_assignment/constants/network_constants.dart';
import 'package:karmalab_assignment/controllers/base_controller.dart';
import 'package:karmalab_assignment/services/base/auth_client.dart';
import 'package:karmalab_assignment/services/shared_pref_service.dart';
import '../models/category_model.dart';





class SubCategoryService extends BaseController {
  final SharedPrefService _prefService = SharedPrefService();
  final BaseClient _baseClient = BaseClient();



  // Fetch all subcategories
  Future<SubCategories?> getAllSubCategories() async {
    try {
      final sessionId = await _prefService.getSessionId();
      var response = await _baseClient.get(
        NetworkConstants.getAllSubCategories,
        header: {'Cookie': "connect.sid=$sessionId"},
      ).catchError(handleError);
      if (response['body'] != null) {
        return SubCategories.fromJson(response['body']);
      }
    } catch (e) {
      print('Error fetching subcategories: $e');
    }
    return null;
  }

  // Fetch subcategory by ID
  Future<SubCategories?> getSubCategoryById(String id) async {
    try {
      final sessionId = await _prefService.getSessionId();
      var response = await _baseClient.get(
        NetworkConstants.getSubCategoryById(id),
        header: {'Cookie': "connect.sid=$sessionId"},
      ).catchError(handleError);

      if (response['body'] != null) {
        return SubCategories.fromJson(response['body']);
      }
    } catch (e) {
      print('Error fetching subcategory by ID: $e');
    }
    return null;
  }




  // Create a new subcategory
  Future<SubCategories?> createSubCategory(dynamic object) async {
    try {
      final sessionId = await _prefService.getSessionId();
      var response = await _baseClient.post(
        NetworkConstants.createSubCategory,
        object,
        header: {
          'Cookie': "connect.sid=$sessionId",
          'Content-Type': "application/json",
        },
      ).catchError(handleError);

      if (response['body'] != null) {
        print('The response is: ... ... ... $response');
        return SubCategories.fromJson(response['body']);
      }
    } catch (e) {
      print('Error creating subcategory: $e');
    }
    return null;
  }


  // Update subcategory by ID
  Future<bool> updateSubCategoryById(String id, dynamic object) async {
    try {
      final sessionId = await _prefService.getSessionId();
      var response = await _baseClient.patch(
        NetworkConstants.updateSubCategoryById(id),
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
      print('Error updating subcategory by ID: $e');
    }
    return false;
  }




  // Delete subcategory by ID
  Future<bool> deleteSubCategoryById(String id) async {
    try {
      final sessionId = await _prefService.getSessionId();
      var response = await _baseClient.delete(
        NetworkConstants.deleteSubCategoryById(id),
        header: {'Cookie': "connect.sid=$sessionId"},
      ).catchError(handleError);

      if (response['body'] == null) {
        return true;
      }
    } catch (e) {
      print('Error deleting subcategory by ID: $e');
    }
    return false;
  }
}
