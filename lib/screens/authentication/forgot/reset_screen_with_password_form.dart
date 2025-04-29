import 'package:animated_text_kit/animated_text_kit.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../controllers/sign_up_controller.dart';
import '../../../services/auth_service.dart';
import '../../../utils/network_manager.dart';
import '../../../utils/validators/validation.dart';
import '../login/login_view.dart';

class ResetScreenWithPasswordForm extends StatelessWidget {
  ResetScreenWithPasswordForm({super.key});
  final AuthService _authService = AuthService();
  final controller = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            margin: const EdgeInsets.all(Sizes.defaultSpace),
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: Sizes.spaceBtwSections),
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Reset Password',
                        textStyle:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                        speed: const Duration(milliseconds: 100),
                      ),
                    ],
                    totalRepeatCount: 1,
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: controller.token,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.token)
                          .animate()
                          .fade(duration: 500.ms)
                          .scale(delay: 200.ms),
                      labelText: 'Token',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .slideX(begin: -0.2, end: 0),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: controller.password,
                    validator: (value) =>
                        Validator.validateEmailForLogin(value),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Iconsax.direct_right)
                          .animate()
                          .fade(duration: 500.ms)
                          .scale(delay: 300.ms),
                      labelText: TextStrings.password,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 500.ms, delay: 200.ms)
                      .slideX(begin: -0.2, end: 0),
                  const SizedBox(height: 20),
                  Obx(
                    () => TextFormField(
                      controller: controller.confirmPassword,
                      obscureText: controller.hidePassword.value,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Iconsax.password_check)
                            .animate()
                            .fade(duration: 500.ms)
                            .scale(delay: 400.ms),
                        labelText: 'Confirm Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        suffixIcon: IconButton(
                          onPressed: () => controller.hidePassword.value =
                              !controller.hidePassword.value,
                          icon: Icon(
                            controller.hidePassword.value
                                ? Iconsax.eye_slash
                                : Iconsax.eye,
                          ).animate().fade(duration: 200.ms),
                        ),
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 500.ms, delay: 400.ms)
                      .slideX(begin: -0.2, end: 0),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          FullScreenLoader.openLoadingDialog(
                              'Processing your request...',
                              ImageStrings.docerAnimation);
                          final isConnected =
                              await NetworkManager.instance.isConnected();
                          if (!isConnected) {
                            FullScreenLoader.stopLoading();
                            return;
                          }
                          await _authService.changePasswordAndSiginIn(
                            resetToken: controller.token.text.trim(),
                            newPassword: controller.password.text.trim(),
                            confirmPassword:
                                controller.confirmPassword.text.trim(),
                          );

                          FullScreenLoader.stopLoading();
                          Loaders.succcessSnackBar(
                            title: 'Password changed',
                            message: 'Please login with your new password',
                          );
                          Get.to(() => LoginView());
                        } catch (e) {
                          FullScreenLoader.stopLoading();
                          Loaders.errorSnackBar(
                              title: 'Oh Snap', message: e.toString());
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        TextStrings.submit,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 500.ms, delay: 600.ms)
                      .slideY(begin: 0.2, end: 0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
