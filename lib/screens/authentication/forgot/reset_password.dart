
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karmalab_assignment/screens/authentication/forgot/reset_screen_with_password_form.dart';

import '../../../../utils/helpers/helper_functions.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import 'forget_password_controller.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(CupertinoIcons.clear),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.defaultSpace),
          child: Column(
            children: [
              Image(
                image: const AssetImage(ImageStrings.deliveredEmailIllustration),
                width: HelperFunctions.screenWidth() * 0.6,
              ),
              const SizedBox(height: Sizes.spaceBtwSections),
              Text(
                TextStrings.changeYourPasswordTitle,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Sizes.spaceBtwItems),
              Text(
                TextStrings.changeYourPasswordSubTitle,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Sizes.spaceBtwSections),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.offAll(() => ResetScreenWithPasswordForm()),
                  child: const Text(TextStrings.done),
                ),
              ),
              const SizedBox(height: Sizes.spaceBtwItems),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => ForgetPasswordController.instance.sendPasswordResetEmail(),
                  child: const Text(TextStrings.resendEmail),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
