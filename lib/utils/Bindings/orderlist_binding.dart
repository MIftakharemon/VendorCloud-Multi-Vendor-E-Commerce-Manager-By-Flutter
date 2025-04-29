import 'package:get/get.dart';
import 'package:karmalab_assignment/controllers/order_controller.dart';
class OrderlistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderController>(()=>OrderController());
  }
}
