import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karmalab_assignment/services/auth_service.dart';
import 'package:karmalab_assignment/services/base/app_exceptions.dart';

import '../models/user_model.dart';
import '../screens/authentication/login/login_view.dart';
import 'image_controller.dart';

class SignUpController extends GetxController {
  final imageController = Get.put(MediaController());

  final AuthService _authService = AuthService();
  final hidePassword = true.obs;
  final privacyPolicy = true.obs;
  final email = TextEditingController();
  final token = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final name = TextEditingController();
  final phoneNumber = TextEditingController();

  // Controllers
  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _conformPasswordController = TextEditingController();

  var type = ''.obs;

  final _loading = false.obs;

  final RxBool _isPasswordVisible = false.obs;
  void togglePasswordVisibility() {
    _isPasswordVisible.value = !_isPasswordVisible.value;
  }

  final RxBool _isConformPasswordVisible = false.obs;
  void toggleConformPasswordVisibility() {
    _isConformPasswordVisible.value = !_isConformPasswordVisible.value;
  }

  @override
  void dispose() {
    _nameTextController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _conformPasswordController.dispose();
    super.dispose();
  }

  bool get isPasswordVisible => _isPasswordVisible.value;
  bool get isConformPasswordVisible => _isConformPasswordVisible.value;
  TextEditingController get nameTextController => _nameTextController;
  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  TextEditingController get conformPasswordController => _conformPasswordController;

  bool get loading => _loading.value;
  String get Type => type.value;

  bool validate() {
    String ImageBase64 = imageController.imageBase64;

    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(_emailController.text);

    try {
      if (_nameTextController.text == "" ||
          _emailController.text == "" ||
          passwordController.text == "" ||
          _conformPasswordController.text == "" ||
          ImageBase64 == null) {
        throw InvalidException(
            "Please fill all the fields and upload an avatar image!", false);
      } else {
        if (emailValid) {
          if (passwordController.text.length >= 8) {
            if (passwordController.text == conformPasswordController.text) {
              return true;
            } else {
              throw InvalidException("Passwords do not match!", false);
            }
          } else {
            throw InvalidException(
                "Password must be at least 8 characters long!", false);
          }
        } else {
          throw InvalidException("Email is not valid!", false);
        }
      }
    } catch (e) {
      throw InvalidException("Error: $e", false);
    }
  }

  Future<void> register(Function(UserModel?)? onRegister) async {
    String ImageBase64 = imageController.imageBase64;

    final valid = validate();
    if (valid) {
      _loading.value = true;
      try {
        await Future.delayed(const Duration(seconds: 1));
        // Create a User object
        UserModel user = UserModel(
          name: _nameTextController.text,
          email: _emailController.text,
          password: _passwordController.text,
          confirmPassword: _conformPasswordController.text,
          avatar: ImageBase64,
          otherPermissions: OtherPermissions(),
        );
        UserModel? registeredUser = await _authService.register(user.toJson());
        _loading.value = false;

        if (registeredUser != null) {
          Get.snackbar(
            "",
            "",
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
            margin: const EdgeInsets.all(10),
            borderRadius: 10,
            titleText: const Text(
              "Success 🎉",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            messageText: const Text(
              "User registered successfully! Please login with your credentials.",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          );
          Get.to(LoginView());
          if (onRegister != null) {
            onRegister(registeredUser);
          }
        } else {
          Get.snackbar(
            "",
            "",
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
            margin: const EdgeInsets.all(10),
            borderRadius: 10,
            titleText: const Text(
              "Failed ❌",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            messageText: const Text(
              "Register failed! User already exists, please login",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          );
        }
      } catch (e) {
        _loading.value = false;
      }
    }
  }

  void clear() {
    // Clear text controllers
    _nameTextController.clear();
    _emailController.clear();
    _passwordController.clear();
    _conformPasswordController.clear();
    email.clear();
    token.clear();
    password.clear();
    confirmPassword.clear();
    name.clear();
    phoneNumber.clear();

    // Reset observable variables
    hidePassword.value = true;
    privacyPolicy.value = true;
    type.value = '';
    _loading.value = false;
    _isPasswordVisible.value = false;
    _isConformPasswordVisible.value = false;

    imageController.removeCoverPhoto();
  }
}
