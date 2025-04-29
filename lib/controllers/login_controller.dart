import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karmalab_assignment/services/auth_service.dart';
import 'package:karmalab_assignment/models/user_model.dart';

import '../screens/authentication/login/changePasswordForPhoneLogin.dart';
import '../screens/mainScreen/mainscreen.dart';
import '../services/shared_pref_service.dart';

class LoginController extends GetxController {
  final AuthService _authService = AuthService();
  final SharedPrefService prefService = SharedPrefService();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final RxString _otpValue = ''.obs;
  void updateOtpValue(String value) {
    _otpValue.value = value;
  }

  String get otpValue => _otpValue.value;
  final RxBool _isEmailLogin = true.obs;
  final RxBool _isOtpSent = false.obs;
  final RxBool _isPasswordVisible = false.obs;
  final RxBool _loading = false.obs;

  bool get isEmailLogin => _isEmailLogin.value;
  bool get isOtpSent => _isOtpSent.value;
  bool get isPasswordVisible => _isPasswordVisible.value;
  bool get loading => _loading.value;

  void toggleLoginMode(bool isEmail) {
    _isEmailLogin.value = isEmail;
    _isOtpSent.value = false;
    _otpValue.value = '';
  }

  void togglePasswordVisibility() {
    _isPasswordVisible.value = !_isPasswordVisible.value;
  }

  Future<void> login() async {
    if (_validate()) {
      _loading.value = true;
      try {
        UserModel? user;
        if (_isEmailLogin.value) {
          // Email login flow
          user = await _authService.login(
            {
              "email": emailController.text,
              "password": passwordController.text,
            },
          );
          if (user != null) {
            Get.offAllNamed(MainScreen.routeName);
          } else {
            Get.snackbar('Error', 'Login failed');
          }
        } else {
          // OTP login flow
          if (otpValue.isEmpty) {
            // Sending OTP
            bool otpSent = await _authService.sentOtp({
              "phone": phoneController.text,
            });
            if (otpSent) {
              Get.snackbar('Success', 'An OTP has been sent to your phone');
              _isOtpSent.value = true;
            } else {
              Get.snackbar('Error', 'Failed to send OTP');
            }
          } else {
            String? hash = await prefService.getHash();
            user = await _authService.verifyOtp(
              {
                "otp": _otpValue.value,
                "phone": phoneController.text,
                "role": "vendor",
                "hash": hash ?? '', // Use empty string if hash is null
              },
            );
            if (user != null) {
              Get.to(() => CreatePasswordScreen(currentPassword:'${user!.password}'));
            } else {
              Get.snackbar('Error', 'OTP verification failed');
            }
          }
        }
      } catch (e) {
      } finally {
        _loading.value = false;
      }
    }
  }

  bool _validate() {
    if (_isEmailLogin.value) {
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        Get.snackbar('Error', 'Please fill all fields');
        return false;
      }
    } else {
      if (phoneController.text.isEmpty) {
        Get.snackbar('Error', 'Please enter your phone number');
        return false;
      }
      if (!GetUtils.isPhoneNumber(phoneController.text)) {
        Get.snackbar('Error', 'Please enter a valid phone number');
        return false;
      }
      if (_isOtpSent.value && _otpValue.value.isEmpty) {
        Get.snackbar('Error', 'Please enter the OTP');
        return false;
      }
    }
    return true;
  }

  @override
  void onClose() {
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    _otpValue.value = '';
    super.onClose();
  }
}
