import 'dart:ui';
import 'package:get/get.dart';
import 'package:karmalab_assignment/models/event_product_model.dart';
import '../models/event_model.dart';
import '../models/pachakge_model.dart';
import '../models/product_model.dart';
import '../services/event_product_service.dart';
import '../controllers/product_controller.dart';
import '../controllers/user_controller.dart';
import 'event_ad_management_package_controller.dart';

class EventManagementController extends GetxController {
  static EventManagementController get instance => Get.find();

  final ProductController productController =Get.find<ProductController>();
  var eventProducts = <Product>[].obs;
  // Add these properties
  final int pageSize = 10;
  int currentPage = 0;
  bool hasMoreProducts = true;
  RxList<Product> availableProducts = <Product>[].obs;
  RxBool isLoading = false.obs;

  final _eventProductRepository = EventProductRepository();
  final error = ''.obs;
  final UserController userController = Get.find<UserController>();

  //late final GenericController<dynamic> parentController;
  final parentController = Get.find<GenericController<Event>>(tag: 'event');


  @override
  void onInit() {
    super.onInit();
    syncProductsWithEvent();
  }

  Future<void> syncProductsWithEvent() async {
    try {
      isLoading.value = true;
      final user = userController.user.value;
      // Get all products first
      await productController.getProducts(userId: user!.id??'');
      final allProducts = productController.products;

      // Then get event products
      final eventProductsList = await _eventProductRepository.getEventProducts();
      eventProducts.assignAll(eventProductsList);

      // Create a Set of event product IDs for efficient lookup
      final eventProductIds = eventProducts.map((p) => p.id).toSet();

      // Filter and update available products
      availableProducts.value = allProducts
          .where((product) => !eventProductIds.contains(product.id))
          .toList();

    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }






  Future<void> loadMoreProducts() async {
    if (!hasMoreProducts || isLoading.value) return;

    try {
      isLoading.value = true;
      final productResponse = await _eventProductRepository.getEventProducts(
        page: currentPage + 1,
        pageSize: pageSize
      );

      // Create a set of existing product IDs for efficient lookup
      final existingIds = eventProducts.map((p) => p.id).toSet();
    
      // Filter out any duplicates from the new response
      final uniqueNewProducts = productResponse.where((product) => 
        !existingIds.contains(product.id)
      ).toList();

      if (uniqueNewProducts.isEmpty) {
        hasMoreProducts = false;
      } else {
        currentPage++;
        eventProducts.addAll(uniqueNewProducts);
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'Failed to fetch products: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> addProductToEventOrPackage(Product product, String parentId) async {
    try {
      isLoading.value = true;
      error.value = '';

      final user = userController.user.value;
      if (user == null) throw 'User not found';

      final productData = {
        'user': user.id,
        'product': product.id,
        'event': parentId,
        'name': product.name,
      };

      final success = await _eventProductRepository.addProductToEvent(productData);

      if (success) {
        await parentController.refreshData();
        // Add this line to sync both controllers
        await syncProductsWithEvent();
        // Force UI update
        parentController.update();
        update();


        Get.snackbar('Success', '${product.name} added successfully');
      } else {
        Get.snackbar('Error', 'Failed to add ${product.name}');
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Initial load method
  Future<void> getEventProducts() async {
    currentPage = 0;
    hasMoreProducts = true;
    await loadMoreProducts();
  }

  void removeProductFromAvailable(Product product) {
    availableProducts.remove(product);
    eventProducts.add(product);
  }
}
