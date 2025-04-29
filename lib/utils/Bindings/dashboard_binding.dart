import 'package:get/get.dart';
import '../../controllers/category_controller.dart';
import '../../controllers/dashboard_controller.dart';
import '../../controllers/product_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(()=>DashboardController());
  }
}
