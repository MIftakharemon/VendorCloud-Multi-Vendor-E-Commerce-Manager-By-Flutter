
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:karmalab_assignment/screens/authentication/forgot/forget_password_controller.dart';
import 'package:karmalab_assignment/services/auth_service.dart';
import 'package:karmalab_assignment/services/event_ad_package_service.dart';
import 'package:karmalab_assignment/services/review_services.dart';
import 'package:karmalab_assignment/utils/network_manager.dart';
import '../services/hive_service.dart';
import '../services/shared_pref_service.dart';
import '../controllers/user_controller.dart';
import '../controllers/chat_controller.dart';
import '../controllers/event_ad_management_package_controller.dart';
import '../controllers/product_controller.dart';
import '../controllers/profile_update_controller.dart';
import '../controllers/review_controller.dart';
import '../controllers/mainscreen_controller.dart';
import '../controllers/category_controller.dart';
import '../controllers/order_controller.dart';
import '../models/event_model.dart';
import '../models/pachakge_model.dart';
import '../constants/network_constants.dart';
import 'controllers/event_product_controller.dart';
import 'controllers/image_controller.dart';
import 'controllers/product_update_controller.dart';

class InitializationScreen {
  static late bool isLoggedIn;

  static Future<void> init() async {
    // Initialize Shared Preferences and User
    final prefService = SharedPrefService();
    isLoggedIn = await prefService.getLoginStatus();

    // Initialize UserController and set user if logged in
    final userController = Get.put(UserController(), permanent: true);
    if (isLoggedIn) {
      final savedUser = await prefService.getUser();
      if (savedUser != null) {
        userController.setUser(savedUser);
      }
    }

    // Initialize Hive Service
    final hiveService = HiveService();
    await hiveService.init();
    Get.put(hiveService, permanent: true);

    // Initialize Network Manager
    Get.put(NetworkManager(), permanent: true);

    // Initialize AuthService
    Get.put(AuthService(), permanent: true);

    // Lazy-load controllers that are not needed immediately
    Get.lazyPut(() => EventManagementController(), fenix: true);
    Get.lazyPut(() => ChatController(), fenix: true);
    Get.lazyPut(() => UpdateUserDataController(), fenix: true);
    Get.lazyPut(() => ReviewController(), fenix: true);
    Get.lazyPut(() => ReviewRepository(), fenix: true);
    Get.lazyPut(() => PageController(), fenix: true);
    Get.lazyPut(() => MainController(), fenix: true);
    Get.lazyPut(() => ProductController(), fenix: true);
    Get.lazyPut(() => ProductUpdateController(), fenix: true);
    Get.lazyPut(() => CategoryController(), fenix: true);
    Get.lazyPut(() => OrderController(), fenix: true);
    Get.lazyPut(() => ForgetPasswordController(), fenix: true);
    Get.lazyPut(()=>MediaController(), fenix: true);

    // Initialize Repositories and Controllers only when needed
    Get.lazyPut(
          () => GenericController<Package>(
        GenericRepository<Package>(
          fromJson: (json) => PackageModel.fromJson(json),
          endpoint: NetworkConstants.getAllPackages(1, 10),
        ),
        isPackageScreen: true,
      ),
      tag: 'package',
      fenix: true,
    );

    Get.lazyPut(
          () => GenericController<Event>(
        GenericRepository<Event>(
          fromJson: (json) => EventModel.fromJson(json),
          endpoint: NetworkConstants.getAllEvents(1, 10),
        ),
        isPackageScreen: false,
      ),
      tag: 'event',
      fenix: true,
    );
  }
}