import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:karmalab_assignment/models/user_model.dart';
import 'package:karmalab_assignment/utils/popups/loaders.dart';
import '../models/order_model.dart';
import '../services/hive_service.dart';
import '../services/order_repository.dart';

class OrderController extends GetxController {
  static OrderController get instance => Get.find();
  final HiveService _hiveService = HiveService();
  final orderRepository = Get.put(OrderRepository());

  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxList<OrderModel> all_orders_together = <OrderModel>[].obs;
  final RxBool isLoading = false.obs;
  int currentPage = 0;
  final int limit = 10;
  bool hasMoreData = true;
  RxString orderStatus = 'pending'.obs; // Default status is 'pending'

  Future<void> updateOrderStatusById(String orderId, String newStatus) async {
    try {
      final success = await orderRepository.updateOrderStatus(orderId, newStatus);
      if (success) {
        final orderIndex = orders.indexWhere((order) => order.sId == orderId);
        if (orderIndex != -1) {
          orders[orderIndex].status = newStatus;
          orders.refresh(); // Trigger UI update
        }
        Loaders.succcessSnackBar(
          title: 'Success',
          message: 'Order status updated successfully',
        );
      }
    } catch (e) {
      Loaders.errorSnackBar(
        title: 'Error',
        message: e.toString(),
      );
    }
  }

  Future<List<OrderModel>> fetchUserOrders({bool isLoadMore = false}) async {
    if (!isLoadMore) {
      currentPage = 1;
      orders.clear();
      hasMoreData = true;
    }

    if (!hasMoreData || isLoading.value) return orders;

    try {
      isLoading.value = true;
      UserModel? user = await _hiveService.getUser();
      final userId = user?.id ?? '';
      final newOrders = await orderRepository.fetchUserOrders(
          userId,
          page: currentPage,
          limit: limit
      );

      if (newOrders.isEmpty) {
        hasMoreData = false;
      } else {
        orders.addAll(newOrders);
        currentPage++;
      }

      return orders;
    } catch (e) {
      Loaders.warningSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<OrderModel>> fetchAllUserOrders() async {
    try {
      isLoading.value = true;
      UserModel? user = await _hiveService.getUser();
      final userId = user?.id ?? '';
      final orders = await orderRepository.fetchAllUserOrders(userId);
      all_orders_together.addAll(orders);
      return all_orders_together;
    } catch (e) {
      Loaders.warningSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    } finally {
      isLoading.value = false;
    }
  }

}
