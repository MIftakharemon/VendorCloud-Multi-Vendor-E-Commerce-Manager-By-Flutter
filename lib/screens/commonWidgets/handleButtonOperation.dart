import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

void handleApiCallButton(
    Future<void> Function(Function(bool, {String? errorMessage})) asyncOperation, {String successMessage = 'Operation completed successfully!',
      String? errorMessage,
      Function()? onSuccess,
      Function(String)? onError}) async {

  await asyncOperation((success, {errorMessage}) {
    if (success) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
          content: Text(successMessage),
          backgroundColor: Colors.green,
        ),
      );
      if (onSuccess != null) onSuccess();
    } else {
      final errorText = errorMessage ?? 'Error: $errorMessage';
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text(errorText),
          backgroundColor: Colors.red,
        ),
      );
      if (onError != null) onError(errorText);
    }
  });
}

