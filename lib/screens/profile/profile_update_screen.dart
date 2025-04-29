import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:karmalab_assignment/screens/profile/profile_menu.dart';
import 'package:karmalab_assignment/screens/profile/profile_update_bottom_sheet.dart';
import '../../common/widgets/appbar/appbar.dart';
import '../../common/widgets/images/circular_image.dart';
import '../../common/widgets/texts/section_heading.dart';
import '../../controllers/image_controller.dart';
import '../../controllers/profile_update_controller.dart';
import '../../controllers/user_controller.dart';
import '../../services/hive_service.dart';
import '../../utils/constants/image_strings.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/constants/text_strings.dart';
import '../../utils/popups/loaders.dart';
import '../../utils/validators/validation.dart';



class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController controller = Get.find<UserController>();

    final updateProfileController = UpdateUserDataController.instance;
    final mediaController = Get.find<MediaController>();

    return Scaffold(
      appBar: const CustomAppBar(
        title: Text('Profile'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.defaultSpace),
          child: Obx(() {
            return Column(
              children: [

                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          try {
                            await mediaController.imagePickerAndBase64Conversion();
                            if (mediaController.imageBase64.isNotEmpty) {
                              final imageController = TextEditingController(
                                  text: mediaController.imageBase64);
                              await updateProfileController.updateUserField(
                                  'avatar', imageController);
                            }
                          } catch (e) {
                            Loaders.errorSnackBar(
                                title: 'Error',
                                message: 'Failed to update profile picture');
                          }
                        },
                        child: Obx(() => mediaController.imageBase64.isEmpty
                            ?
                        CircularImage(
                          image: controller.user.value!.avatar?.isNotEmpty == true
                              ? controller.user.value!.avatar!
                              : ImageStrings.user,
                          width: 80,
                          height: 80,
                          isNetworkImage: controller.user.value!.avatar?.isNotEmpty == true,)
                            : CircleAvatar(
                          radius: 40,
                          backgroundImage: MemoryImage(base64Decode(
                              mediaController.imageBase64.split(',').last)),
                        )),
                      ),
                      TextButton(
                        onPressed: () async {
                          try {
                            await mediaController.imagePickerAndBase64Conversion();
                            if (mediaController.imageBase64.isNotEmpty) {
                              final imageController = TextEditingController(
                                  text: mediaController.imageBase64);
                              await updateProfileController.updateUserField(
                                  'avatar', imageController);
                            }
                          } catch (e) {
                            Loaders.errorSnackBar(
                                title: 'Error',
                                message: 'Failed to update profile picture');
                          }
                        },
                        child: const Text('Change Profile Picture'),
                      ),
                    ],
                  ),
                ),


                const SizedBox(height: Sizes.spaceBtwItems / 2),
                const Divider(),
                const SizedBox(height: Sizes.spaceBtwItems),
                const SectionHeading(
                    title: 'Profile Information', showActionButton: false),
                const SizedBox(height: Sizes.spaceBtwItems),
                ProfileMenu(
                  title: 'Name',
                  value:  controller.user.value!.name,
                  onPressed: () => showUpdateProfileBottomSheet(
                    context,
                    title: 'Name',
                    fieldName: TextStrings.name,
                    hintText: 'Enter your name',
                    prefixIcon: Iconsax.user,
                    validator: (value) => Validator.validateEmptyText('Name', value),
                    onSave: () => updateProfileController.updateUserName(),
                  ),
                ),


                const SizedBox(height: Sizes.spaceBtwItems),
                const Divider(),
                const SizedBox(height: Sizes.spaceBtwItems),
                const SectionHeading(
                    title: 'Personal Information', showActionButton: false),
                const SizedBox(height: Sizes.spaceBtwItems),

                ProfileMenu(
                  title: 'User ID',
                  value: controller.user.value!.id ?? '',
                  icon: Iconsax.copy,
                  onPressed: () {},
                ),

                ProfileMenu(
                  title: 'E-mail',
                  value: controller.user.value!.email,
                  onPressed: () => showUpdateProfileBottomSheet(
                    context,
                    title: 'Email',
                    fieldName: TextStrings.email,
                    hintText: 'Enter your email',
                    prefixIcon: Icons.email,
                    validator: (value) => Validator.validateEmail(value),
                    onSave: () => updateProfileController.updateUserEmail(),
                  ),
                ),

                ProfileMenu(
                  title: 'Phone Number',
                  value: controller.user.value!.phoneNumber ?? '',
                  onPressed: () => showUpdateProfileBottomSheet(
                    context,
                    title: 'Phone',
                    fieldName: TextStrings.phoneNo,
                    hintText: 'Enter your phone number',
                    prefixIcon: Icons.phone,
                    validator: (value) => Validator.validatePhoneNumber(value),
                    onSave: () => updateProfileController.updateUserPhone(),
                  ),
                ),

                ProfileMenu(
                  title: 'Gender',
                  value: controller.user.value!.gender ?? '',
                  onPressed: () => showUpdateProfileBottomSheet(
                    context,
                    title: 'Gender',
                    fieldName: TextStrings.gender,
                    hintText: 'Enter your gender',
                    prefixIcon: Icons.person,
                    validator: (value) => Validator.validateEmptyText('Gender', value),
                    onSave: () => updateProfileController.updateUserGender(),
                  ),
                ),


                const Divider(),
                const SizedBox(height: Sizes.spaceBtwItems),
                Center(
                  child: TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Close Account'),
                            content: const Text(
                              'Are you sure you want to close your account? This action cannot be undone.',
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  updateProfileController.deleteUserAccount();
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'Close Account',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text(
                      'Close Account',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                )
              ],
            );
          }),
        ),
      ),
    );
  }
}
