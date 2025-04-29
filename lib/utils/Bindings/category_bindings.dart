import 'package:get/get.dart';
import '../../controllers/category_controller.dart';
import '../../controllers/product_controller.dart';
class Categorybindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoryController>(()=>CategoryController());
  }
}
