import 'package:flutter/painting.dart';
import 'package:get/get.dart';

class DialogHelper {

  static void showErrorDialog({
    String? title = "Oops 🤦🏻♂️",
    String? description,
  }) {
    Get.snackbar(
      title!,
      description ?? "something went wrong",
      margin: const EdgeInsets.all(20),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  static void showSnackBar(
      {String? title = "OTP 📲",
      String? description,
      Duration? duration = const Duration(seconds: 3)}) {
    Get.snackbar(
      title!,
      description ?? "something went wrong",
      margin: const EdgeInsets.all(20),
      snackPosition: SnackPosition.BOTTOM,
      duration: duration,
    );
  }
}
