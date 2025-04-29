import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karmalab_assignment/constants/size_constants.dart';
import 'package:karmalab_assignment/controllers/sign_up_controller.dart';
import 'package:karmalab_assignment/helper/dialog_helper.dart';
import 'package:karmalab_assignment/utils/dimension.dart';
import 'package:karmalab_assignment/widgets/custom_button.dart';
import 'package:karmalab_assignment/widgets/custom_form.dart';
import 'package:karmalab_assignment/widgets/fancy2_text.dart';
import 'package:karmalab_assignment/widgets/social_media_log.dart';
import '../../../controllers/image_controller.dart';
import '../../../models/user_model.dart';
import '../../../services/base/app_exceptions.dart';
import '../../../utils/constants/colors.dart';
import '../../mainScreen/mainscreen.dart';
import '../login/login_view.dart';
import '../widget/auth_header.dart';

class SignUpView extends StatelessWidget {
  static const routeName = '/sign-up';

  final SignUpController _signUpController = Get.put(SignUpController());
  final imageController = Get.put(MediaController());

  SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.defaultPadding,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () async {
                      await imageController.imagePickerAndBase64Conversion();
                    },
                    child: Obx(() => imageController.imageBase64.isEmpty
                        ? Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Icon(Icons.add_a_photo),
                          )
                        : CircleAvatar(
                            radius: 50,
                            backgroundImage: MemoryImage(base64Decode(
                                imageController.imageBase64.split(',').last)
                            ),
                          )),
                  ),
                  context.spacing(height: 2),
                  const AuthHeader(
                    subTitle: "Create an account",
                    title: "Sign Up",
                  ),
                  const SizedBox(height: 25),
                  CustomForm(controller: _signUpController, isLogin: false, isEmailLogin:false),
                  const SizedBox(height: 5),
                  Obx(() {
                    return CustomButton(
                      label: "Sign Up",
                      isLoading: _signUpController.loading,
                      onTap: () async {
                        try {
                          await _signUpController.register((UserModel? user, {String? errorMessage}) {
                            if (user != null) {
                              FocusManager.instance.primaryFocus?.unfocus();
                              _signUpController.clear();
                              Get.to(()=> LoginView.routeName);
                            } else {
                              DialogHelper.showSnackBar(description: 'Register failed! User already exists, please login');
                            }
                          });
                        } catch (e) {
                          DialogHelper.showSnackBar(
                              description:
                                  'An unexpected error occurred: ${e.toString()}');
                        }
                      },
                    );
                  }),
                  const SizedBox(height: 15),
                  Fancy2Text(
                    first: "Already have an account? ",
                    second: " Login",
                    isCenter: true,
                    onTap: () { Navigator.pushNamed(
                      context,

                      LoginView.routeName,
                    );
                    _signUpController.clear();

                    },
                  ),
                  const SizedBox(height: 5),
                  // SocialMediaAuthArea(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
