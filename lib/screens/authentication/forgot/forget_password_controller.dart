
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karmalab_assignment/screens/authentication/forgot/reset_password.dart';

import '../../../../utils/validators/validation.dart';
import '../../../services/auth_service.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/network_manager.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../../utils/popups/loaders.dart';

class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();
  final AuthService _authService = AuthService();

  final email = TextEditingController();
  GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();

  sendPasswordResetEmail() async {

    final isValid = Validator.validateEmailForLogin(email.text.trim());
    if (isValid != null) {
      Loaders.errorSnackBar(title: 'Invalid Email', message: isValid);
      return;
    }

    try {
      FullScreenLoader.openLoadingDialog(
          'Processing your request...', ImageStrings.docerAnimation);

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FullScreenLoader.stopLoading();
        return;
      }
      await _authService.sendPasswordResetEmail(email.text.trim());

      FullScreenLoader.stopLoading();

      Loaders.succcessSnackBar(
          title: 'Email Sent',
          message: 'Email Link Sent to Reset Your Password.');

      Get.to(() => ResetPassword(email: email.text.trim()));
    } catch (e) {
      FullScreenLoader.stopLoading();
      Loaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}
