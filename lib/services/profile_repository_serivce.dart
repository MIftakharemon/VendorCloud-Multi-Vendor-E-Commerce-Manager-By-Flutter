import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/shared_pref_service.dart';
import '../../services/base/auth_client.dart';
import '../constants/network_constants.dart';
import '../models/user_model.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final BaseClient _baseClient = BaseClient();
  final SharedPrefService _prefService = SharedPrefService();

  Future<UserModel?> updateUserDetails(Map<String, dynamic> updateData) async {
    try {
      final sessionId = await _prefService.getSessionId();
      var response = await _baseClient.patch(
        NetworkConstants.updateMe,
        updateData,
        header: {
          'Content-Type': "application/json",
          'Cookie': "connect.sid=$sessionId",
        },
      );

      if (response != null && response['body'] != null) {
        var responseBody = response['body'];
        if (responseBody.containsKey('data')) {
          await _prefService.saveUser(responseBody['data']);
          return UserModel.fromJson(responseBody['data']);
        }
      }
      return null;
    } catch (e) {
      throw 'Failed to update user details';
    }
  }




  Future<bool> deleteUserAccount() async {
    try {
      final sessionId = await _prefService.getSessionId();

      var response = await _baseClient.delete(
        NetworkConstants.deleteMe,
        header: {
          'Content-Type': "application/json",
          'Cookie': "connect.sid=$sessionId",
        },
      );

      if (response == null) {
        return true;
      }
      Get.snackbar('Error', 'Unexpected response while deleting account');
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete user account: $e');
      throw 'Failed to delete user account';
    }
  }

  Future<UserModel?> updateSingleField(String field, dynamic value) async {
    try {
      if (field.isEmpty || value == null) {
        throw 'Invalid field or value';
      }
      switch (field) {
        case 'email':
          if (!GetUtils.isEmail(value.toString())) {
            throw 'Invalid email format';
          }
          break;
        case 'phone':
          if (!GetUtils.isPhoneNumber(value.toString())) {
            throw 'Invalid phone number format';
          }
          break;
      }

      return await updateUserDetails({field: value});
    } catch (e) {
      throw 'Failed to update $field: ${e.toString()}';
    }
  }


  Future<UserModel?> getUserProfile() async {
    try {
      var response = await _baseClient.get(
        '${NetworkConstants.baseURL}/api/users/me',
        header: {'Content-Type': "application/json"},
      );

      if (response != null && response.containsKey('data')) {
        return UserModel.fromJson(response['data']);
      }
      return null;
    } catch (e) {throw 'Failed to get user profile';
    }
  }


  Future<bool> changePassword(
      String currentPassword, String newPassword) async {
    try {
      var response = await _baseClient.post(
        '${NetworkConstants.baseURL}/api/users/change-password',
        {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
        header: {'Content-Type': "application/json"},
      );

      return response != null && response['statusCode'] == 200;
    } catch (e) {throw 'Failed to change password';
    }
  }
}
