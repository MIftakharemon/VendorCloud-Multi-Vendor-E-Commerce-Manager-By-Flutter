import 'dart:async';

import 'package:get/get.dart';
import 'package:karmalab_assignment/controllers/product_controller.dart';
import 'package:karmalab_assignment/controllers/user_controller.dart';
import '../models/event_model.dart';
import '../models/pachakge_model.dart';
import '../services/event_ad_package_service.dart';
import '../utils/popups/loaders.dart';

class GenericController<T> extends GetxController {
  final GenericRepository<T> repository;
  final bool isPackageScreen;

  RxList<EventProducts> eventProducts = <EventProducts>[].obs;
  RxList<PackageProducts> packageProducts = <PackageProducts>[].obs;
  final RxList<T> items = <T>[].obs;
  final RxBool isLoading = false.obs;

  int currentPage = 1;
  final int limit = 10;
  bool hasMoreData = true;

  final ProductController productController = Get.put(ProductController());
  final UserController userController = Get.find<UserController>();

  GenericController(this.repository, {this.isPackageScreen = false});


  Future<void> fetchItems({bool isLoadMore = false}) async {
    if (!isLoadMore) {
      currentPage = 1;
      items.clear();
      hasMoreData = true;
    }

    if (!hasMoreData || isLoading.value) return;

    try {
      isLoading.value = true;
      final newItems =
          await repository.fetchItems(page: currentPage, limit: limit);

      if (newItems.isEmpty || newItems.length < limit) hasMoreData = false;

      isLoadMore ? items.addAll(newItems) : items.value = newItems;
      //syncProducts();
      if (hasMoreData) currentPage++;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    try {
      isLoading.value = true;
      final updatedItems =
          await repository.fetchItems(page: 1, limit: items.length);
      items.value = updatedItems;
      //syncProducts();
    } finally {
      isLoading.value = false;
    }
  }
}
