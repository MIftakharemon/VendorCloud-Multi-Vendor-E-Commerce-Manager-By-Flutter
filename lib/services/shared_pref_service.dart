import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../screens/onboarding/onboarding_view.dart';
import '../screens/profile/profile_view.dart';

class SharedPrefService {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  static const String _userKey = 'user';
  Future<void> saveSessionId(String sessionId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('session_id', sessionId);
  }

  Future<String?> getSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('session_id');
  }





  Future<bool> getLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("login") ?? false;
  }

  Future<void> setLoginStatus(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("login", status);
  }

















  Future<void> clearSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('session_id');
  }

// Method to save the hash value in SharedPreferences
  Future<void> saveHash(String hash) async {
    final prefs = await SharedPreferences.getInstance();
    // Save the hash value under the key 'hash'
    bool result = await prefs.setString('hash', hash);

    // Optionally, add a debug statement to check if saving was successful
    if (result) {
      print("Hash saved successfully.");
    } else {
      print("Failed to save hash.");
    }
  }

// Method to get the hash value from SharedPreferences
  Future<String?> getHash() async {
    final prefs = await SharedPreferences.getInstance();
    // Retrieve the hash value stored under the key 'hash'
    String? hash = prefs.getString('hash');

    // Optionally, add a debug statement to check the retrieved hash value
    if (hash != null) {
      print("Retrieved hash: $hash");
    } else {
      print("No hash found in storage.");
    }

    return hash;
  }

  Future<bool> saveUser(Map<String, dynamic> userData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = jsonEncode(userData);
      return await prefs.setString(_userKey, userJson);
    } catch (e) {
      print('Error saving user: $e');
      return false;
    }
  }


  Future<UserModel?> getUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);

      if (userJson != null && userJson.isNotEmpty) {
        final userData = jsonDecode(userJson);
        return UserModel.fromJson(userData);
      }
      return null;
    } catch (e) {
      print('Error retrieving user: $e');
      return null;
    }
  }


  Future<bool> deleteUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_userKey);
    } catch (e) {
      print('Error deleting user: $e');
      return false;
    }
  }



  Future<void> forgotPassCred({String? token, int? otp}) async {
    SharedPreferences pref = await _prefs;
    // ? simulate delay
    await Future.delayed(const Duration(seconds: 0));

    pref.setInt("otp", otp ?? 0);
    pref.setString("token", token ?? "");
  }

  Future<String?> getToken() async {
    SharedPreferences pref = await _prefs;
    return pref.getString("token");
  }

  Future<void> updateToken(String? token) async {
    SharedPreferences pref = await _prefs;
    pref.setString("token", token ?? "");
  }

  Future<void> clear() async {
    SharedPreferences pref = await _prefs;
    pref.setBool("login", false);
    pref.remove("email");
    pref.remove("id");
    pref.remove("otp");
  }
}
