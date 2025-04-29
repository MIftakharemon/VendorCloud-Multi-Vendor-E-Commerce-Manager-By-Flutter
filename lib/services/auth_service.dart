// import 'package:flutter/rendering.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karmalab_assignment/constants/network_constants.dart';
import 'package:karmalab_assignment/services/base/auth_client.dart';
import 'package:karmalab_assignment/services/shared_pref_service.dart';
import '../controllers/base_controller.dart';
import '../controllers/user_controller.dart';
import '../models/user_model.dart';
import '../screens/authentication/login/login_view.dart';
import 'hive_service.dart';

class AuthService extends BaseController {
  final SharedPrefService _prefService = SharedPrefService();

  final BaseClient _baseClient = BaseClient();
  UserController userController = Get.find<UserController>();
  final HiveService _hiveService = HiveService();

  Future<void> _saveSessionId(Map<String, String> headers) async {
    var setCookie = headers['set-cookie'];
    if (setCookie != null) {
      var cookies = setCookie.split(';');
      for (var cookie in cookies) {
        if (cookie.startsWith('connect.sid=')) {
          var sessionId = cookie.split('=')[1];
          await _prefService.saveSessionId(sessionId);
          break;
        }
      }
    }
  }

// !! Register method
  Future<UserModel?> register(dynamic object) async {
    try {
      var response = await _baseClient.post(
        NetworkConstants.registerAPI,
        object,
        header: {'Content-Type': "application/json"},
      );
      if (response != null) {
        var responseBody = response['body'];
        if (responseBody.containsKey('data')) {
          var data = responseBody['data'];
          UserModel fetchedUser = UserModel.fromJson(data);
          return fetchedUser;
        }
      }
    } catch (e) {}
    return null;
  }

  Future<UserModel?> login(dynamic object) async {
    try {
      var response = await _baseClient.post(
        NetworkConstants.loginAPI,
        object,
        header: {'Content-Type': "application/json"},
      ).catchError(handleError);
      if (response != null) {
        var responseBody = response['body'];
        var headers = response['headers'];
        if (responseBody.containsKey('data')) {
          await _saveSessionId(headers);
          var data = responseBody['data'];
          await _prefService.saveUser(data);
          UserModel fetchedUser = UserModel.fromJson(data);
          await _hiveService.saveUser(fetchedUser);
          userController.setUser(fetchedUser);
          await _prefService.setLoginStatus(true);
          return fetchedUser;
        }
      }
    } catch (e) {}
    return null;
  }

// !! send otp
  Future<bool> sentOtp(dynamic object) async {
    try {
      var response = await _baseClient.post(
        NetworkConstants.sendOtp,
        object,
        header: {'Content-Type': "application/json"},
      ).catchError(handleError);

      if (response['body'] != null &&
          response['body'] is Map<String, dynamic>) {
        if (response['body'].containsKey("data") &&
            response['body']["data"] is Map<String, dynamic> &&
            response['body']["data"].containsKey("hash")) {
          final hash = response['body']["data"]["hash"];
          await _prefService.saveHash(hash);
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }





  // !! verify otp
  Future<UserModel?> verifyOtp(dynamic object) async {
    try {
      var response = await _baseClient.post(
        NetworkConstants.verifyOtp,
        object,
        header: {'Content-Type': "application/json"},
      ).catchError(handleError);
      if (response != null) {
        var responseBody = response['body'];
        var headers = response['headers'];
        if (responseBody.containsKey('data')) {
          await _saveSessionId(headers);
          var data = responseBody['data'];
          UserModel fetchedUser = UserModel.fromJson(data);
          return fetchedUser;
        }
      } else {}
    } catch (e) {}
    return null;
  }




  Future<void> logout() async {
    await _prefService.clear();
    await _prefService.setLoginStatus(false);
    Get.offAllNamed(LoginView.routeName);
  }

  //  resetPassword
  Future<bool> resetPassword(dynamic object) async {
    debugPrint("new token");
    debugPrint(object.toString());

    debugPrint(await _prefService.getToken());
    var token = await _prefService.getToken();
    var result = await _baseClient.post(
      NetworkConstants.resetPassword,
      object,
      header: {
        'Content-Type': "application/json",
        'Authorization': "Token $token"
      },
    ).catchError(handleError);
    debugPrint(result.toString());

    if (result != null) {
      result = json.decode(result);
      debugPrint("reset password");
      debugPrint(result.toString());

      return true;
    } else {
      return false;
    }
  }

  // Fetch the current user's data
  Future<Map<String, dynamic>?> fetchCurrentUser() async {
    try {
      final token = await _prefService.getToken();
      if (token == null) {
        throw Exception("No token found. User might not be logged in.");
      }

      final result = await _baseClient.get(
        NetworkConstants.getMe,
        header: {
          'Authorization': 'Token $token',
        },
      ).catchError(handleError);

      if (result != null) {
        return json.decode(result);
      }
    } catch (e) {}
    return null;
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      final response = await _baseClient.post(
        NetworkConstants.forgotPassword,
        {'email': email},
        header: {'Content-Type': "application/json"},
      );
      if (response != null && response['body']['status'] == 'success') {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> changePasswordAndSiginIn({
    required String resetToken,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final response = await _baseClient.patch(
        NetworkConstants.resetPassword,
        {
          'resetToken': resetToken,
          'password': newPassword,
          'confirmPassword': confirmPassword,
        },
        header: {'Content-Type': "application/json"},
      );
      if (response != null && response['body']['status'] == 'success') {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final sessionId = await _prefService.getSessionId();
      final response = await _baseClient.patch(
        NetworkConstants.changePassword,
        {
          "currentPassword": currentPassword,
          "password": newPassword,
          "confirmPassword": confirmPassword,
        },
        header: {
          'Cookie': "connect.sid=$sessionId",
          'Content-Type': 'application/json',
        },
      );

      if (response != null && response['body']['status'] == 'success') {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }



}
