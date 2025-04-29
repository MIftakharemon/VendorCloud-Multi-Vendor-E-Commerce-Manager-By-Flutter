
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karmalab_assignment/controllers/user_controller.dart';
import '../../../services/hive_service.dart';
import '../services/profile_repository_serivce.dart';
import '../utils/constants/text_strings.dart';
import '../utils/popups/loaders.dart';
import 'image_controller.dart';

class UpdateUserDataController extends GetxController {
  static UpdateUserDataController get instance => Get.find();
  final HiveService _hiveService = HiveService();
  final mediaController = Get.put(MediaController());

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  TextEditingController getFieldController(String? fieldName) {
    switch (fieldName) {
      case TextStrings.name:
        return _nameController;
      case TextStrings.email:
        return _emailController;
      case TextStrings.password:
        return _passwordController;
      case TextStrings.phoneNo:
        return _phoneController;
      case TextStrings.gender:
        return _genderController;
      default:
        throw Exception('Unknown field name: $fieldName');
    }
  }

  final UserController userController = Get.find<UserController>();
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> updateProfileFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    initializeUserData();
    super.onInit();
  }

  Future<void> initializeUserData() async {
    _nameController.text = userController.user.value!.name;
    _emailController.text = userController.user.value!.email;
    _passwordController.text = userController.user.value!.password;
    _phoneController.text = userController.user.value!.phoneNumber ?? '';
    _genderController.text = userController.user.value!.gender ?? '';
  }

  bool validateField(String fieldName, String value) {
    switch (fieldName) {

      case 'email':
        return GetUtils.isEmail(value);
      case 'phone':
        return GetUtils.isPhoneNumber(value);
      case 'password':
        return value.length >= 6;
      default:
        return value.isNotEmpty;
    }
  }

  Future<void> updateUserField(String fieldName, TextEditingController controller) async {
    try {


      final value = controller.text.trim();
      final updatedUser = await userRepository.updateSingleField(fieldName, value);
      if (updatedUser != null) {
        await _hiveService.saveUser(updatedUser);
        userController.setUser(updatedUser);
        userController.update();
      }
      Loaders.succcessSnackBar(title: 'Success!', message: 'Your $fieldName has been updated.');
    } catch (e) {
      Loaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }






  Future<void> deleteUserAccount() async {
    try {

      final isDeleted = await userRepository.deleteUserAccount();

      if (isDeleted) {
        Loaders.succcessSnackBar(title: 'Account Deleted', message: 'Your account has been successfully deleted.');
      } else {
        Loaders.errorSnackBar(title: 'Error', message: 'Failed to delete your account. Please try again.');
      }
    } catch (e) {
      Loaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }






  Future<void> updateUserName() async => await updateUserField('name', _nameController);
  Future<void> updateUserEmail() async => await updateUserField('email', _emailController);
  Future<void> updateUserPassword() async => await updateUserField('password', _passwordController);
  Future<void> updateUserPhone() async => await updateUserField('phone', _phoneController);
  Future<void> updateUserGender() async => await updateUserField('gender', _genderController);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _genderController.dispose();
    super.dispose();
  }
}
