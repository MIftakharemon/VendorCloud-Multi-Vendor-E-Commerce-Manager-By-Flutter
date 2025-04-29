import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:karmalab_assignment/utils/popups/loaders.dart';

class NetworkManager extends GetxController {
  static NetworkManager get instance => Get.find();

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  final Rx<ConnectivityResult> _connectivityStatus = ConnectivityResult.none.obs;

  @override
  void onInit() {
    super.onInit();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
          (List<ConnectivityResult> results) {
        if (results.isNotEmpty) {
          _updateConnectionStatus(results.first);
        }
      },
    );
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    _connectivityStatus.value = result;
    if (result == ConnectivityResult.none) {
      Loaders.warningSnackBar(title: 'No Internet Connection');
    }
  }

  Future<bool> isConnected() async {
    try {
      final result = await _connectivity.checkConnectivity();
      return result != ConnectivityResult.none;
    } on PlatformException catch (_) {
      return false;
    }
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }
}
