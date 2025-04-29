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

class PackageManagementController extends GetxController {
  static PackageManagementController get instance => Get.find();

  final ProductController productController =Get.find<ProductController>();
  var packageProducts = <Product>[].obs;
  // Add these properties
  final int pageSize = 10;
  int currentPage = 0;
  bool hasMoreProducts = true;
  RxList<Product> availableProducts = <Product>[].obs;
  RxBool isLoading = false.obs;

  final _eventProductRepository = EventProductRepository();
  final error = ''.obs;
  final UserController userController = Get.find<UserController>();

  final parentController = Get.find<GenericController<Package>>(tag: 'package');



  @override
  void onInit() {
    super.onInit();
    syncProductsWithPackage();
  }

  Future<void> syncProductsWithPackage() async {
    try {
      isLoading.value = true;

      // Get all products first
      await productController.getProductsforEventAd(userId: userController.user.value!.id??'');
      final allProducts = productController.productsForEventAdd;

      // Then get package products
      final packageProductsList = await _eventProductRepository.getPackageProducts();
      packageProducts.assignAll(packageProductsList);

      // Create a Set of package product IDs for efficient lookup
      final packageProductIds = packageProducts.map((p) => p.id).toSet();

      // Filter and update available products
      availableProducts.value = allProducts
          .where((product) => !packageProductIds.contains(product.id))
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
      final productResponse = await _eventProductRepository.getPackageProducts(
          page: currentPage + 1,
          pageSize: pageSize
      );

      // Create a set of existing product IDs for efficient lookup
      final existingIds = packageProducts.map((p) => p.id).toSet();

      // Filter out any duplicates from the new response
      final uniqueNewProducts = productResponse.where((product) =>
      !existingIds.contains(product.id)
      ).toList();

      if (uniqueNewProducts.isEmpty) {
        hasMoreProducts = false;
      } else {
        currentPage++;
        packageProducts.addAll(uniqueNewProducts);
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
        'package': parentId,
        'name': product.name,
      };

      final success = await _eventProductRepository.addProductToPackage(productData);

      if (success) {
        removeProductFromAvailable(product);
        await parentController.refreshData();
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
  Future<void> getPackageProducts() async {
    currentPage = 0;
    hasMoreProducts = true;
    await loadMoreProducts();
  }

  void removeProductFromAvailable(Product product) {
    availableProducts.remove(product);
    packageProducts.add(product);
  }
}