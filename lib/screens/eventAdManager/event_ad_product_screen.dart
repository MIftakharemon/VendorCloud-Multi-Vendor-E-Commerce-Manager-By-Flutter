import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karmalab_assignment/screens/event_ad_management_common_widgets/product_list.dart';

import '../../controllers/ad_package_product_controller.dart';
import '../../controllers/event_product_controller.dart';
import '../event_ad_management_common_widgets/event_product_card.dart';

class Event_AD_Products extends StatelessWidget {
  final bool isPackage;
  final String id;

  const Event_AD_Products({
    super.key,
    required this.isPackage,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    final eventController = Get.put(EventManagementController());
    final packageController = Get.put(PackageManagementController());

    isPackage
        ? packageController.syncProductsWithPackage()
        : eventController.syncProductsWithEvent();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Product Management'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() => isPackage
          ? (packageController.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Container(
            height: 150,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Added Package Products',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: packageController.packageProducts.isEmpty
                      ? const Center(
                    child: Text('No products added to package'),
                  )
                      : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: packageController.packageProducts.length,
                    itemBuilder: (context, index) {
                      final product = packageController.packageProducts[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: EventProductCard(product: product),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Available Products',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: packageController.availableProducts.isEmpty
                ? const Center(
              child: Text('No available products'),
            )
                : NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                  packageController.loadMoreProducts();
                  return true;
                }
                return false;
              },
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 16),
                itemCount: packageController.availableProducts.length,
                itemBuilder: (context, index) {
                  final product = packageController.availableProducts[index];
                  return ProductListItem(
                    product: product,
                    parentId: id,
                    controller: packageController,
                    isPackage: isPackage,
                  );
                },
              ),
            ),
          ),
        ],
      ))
          : (eventController.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Container(
            height: 150,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Added Event Products',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: eventController.eventProducts.isEmpty
                      ? const Center(
                    child: Text('No products added to event'),
                  )
                      : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: eventController.eventProducts.length,
                    itemBuilder: (context, index) {
                      final product = eventController.eventProducts[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: EventProductCard(product: product),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Available Products',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Expanded(
            child: eventController.availableProducts.isEmpty
                ? const Center(
              child: Text('No available products'),
            )
                : NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                  eventController.loadMoreProducts();
                  return true;
                }
                return false;
              },
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 16),
                itemCount: eventController.availableProducts.length,
                itemBuilder: (context, index) {
                  final product = eventController.availableProducts[index];
                  return ProductListItem(
                    isPackage:isPackage,
                    product: product,
                    parentId: id,
                    controller: eventController,
                  );
                },
              ),
            ),
          ),
        ],
      ))),
    );
  }
}