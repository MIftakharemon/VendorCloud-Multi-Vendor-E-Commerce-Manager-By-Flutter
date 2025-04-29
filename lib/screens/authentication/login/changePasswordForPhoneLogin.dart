import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/login_controller.dart';
import '../../../services/auth_service.dart';
import '../../../services/shared_pref_service.dart';
import '../../mainScreen/mainscreen.dart';
import 'login_view.dart';

class CreatePasswordScreen extends StatelessWidget {
  static const String routeName = '/create-password';
  final LoginController controller = Get.find<LoginController>();
  final AuthService _authService = AuthService();

  final String currentPassword;
  CreatePasswordScreen({super.key, required this.currentPassword});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 80),
                  // Title
                  const Text(
                    'Create New Password',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  // Subtitle
                  const Text(
                    'Please create a secure password for your account',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  // Password Field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Obx(() => TextFormField(
                      controller: controller.passwordController,
                      obscureText: !controller.isPasswordVisible,
                      decoration: InputDecoration(
                        hintText: 'Enter new password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Colors.deepOrange,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: controller.togglePasswordVisibility,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    )),
                  ),
                  const SizedBox(height: 24),
                  // Confirm Password Field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Obx(() => TextFormField(
                      controller: controller.confirmPasswordController,
                      obscureText: !controller.isPasswordVisible,
                      decoration: InputDecoration(
                        hintText: 'Confirm new password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Colors.deepOrange,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: controller.togglePasswordVisibility,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    )),
                  ),
                  const SizedBox(height: 48),
                  // Submit Button
                  Obx(() => ElevatedButton(
                    onPressed: controller.loading ? null : () async {
                      if (controller.passwordController.text.isEmpty ||
                          controller.confirmPasswordController.text.isEmpty) {
                        Get.snackbar('Error', 'Please fill all fields');
                        return;
                      }
                      if (controller.passwordController.text !=
                          controller.confirmPasswordController.text) {
                        Get.snackbar('Error', 'Passwords do not match');
                        return;
                      }

                      final success = await _authService.changePassword(
                        currentPassword: currentPassword,
                        newPassword: controller.passwordController.text,
                        confirmPassword: controller.confirmPasswordController.text,
                      );

                      if (success) {
                        Get.snackbar('Success', 'Password changed successfully. Please login with your phone and password!');

                        Get.offAllNamed(LoginView.routeName);
                      } else {
                        Get.snackbar('Error', 'Account already created , please login with existing account');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: controller.loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}