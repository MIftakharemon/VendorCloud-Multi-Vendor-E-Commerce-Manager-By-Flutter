import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karmalab_assignment/screens/product/product_details_screen.dart';
import 'package:karmalab_assignment/screens/product/product_update_screen.dart';
import '../../controllers/product_controller.dart';
import '../../utils/constants/colors.dart';

class ProductGridView extends GetView<ProductController> {
  final String subcategoryId;
  final String userId;

  const ProductGridView({
    super.key,
    required this.subcategoryId,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(
        init: ProductController(),
        initState: (_) {
          controller.getProductsForSubCategory(subcategoryId: subcategoryId, userId: userId);
        },
        didChangeDependencies: (_) {
          controller.getProductsForSubCategory(subcategoryId: subcategoryId, userId: userId);
        },
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Product Grid'),
              elevation: 0,
            ),
            body: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else if (controller.products.isEmpty) {
                return const Center(child: Text('No products available.'));
              } else {
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.77,
                  ),
                  itemCount: controller.products.length,
                  itemBuilder: (context, index) {
                    final product = controller.products[index];
                    return GestureDetector(
                      onTap: () => Get.toNamed(
                        ProductDetailsScreen.routeName,
                        arguments: product,
                      ),
                      child: Hero(
                        tag: 'product-${product.id}',
                        child: Card(
                          color: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(12)),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: product.coverPhoto != null
                                            ? Image.network(
                                          product.coverPhoto,
                                          fit: BoxFit.scaleDown,
                                          errorBuilder: (context, error, stackTrace) => Container(
                                            color: Colors.grey[200],
                                            child: Icon(Icons.broken_image,
                                                color: Colors.grey[400],
                                                size: 40),
                                          ),
                                        )
                                            : Container(
                                          color: Colors.grey[200],
                                          child: Icon(Icons.image,
                                              color: Colors.grey[400], size: 40),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: PopupMenuButton<String>(
                                        icon: const Icon(Icons.more_vert,
                                            color: AppColors.darkOrange),
                                        onSelected: (value) {
                                          if (value == 'update') {
                                            Get.to(() =>
                                                ProductUpdateScreen(product: product));
                                          } else if (value == 'delete') {
                                            _showDeleteConfirmation(
                                                context, product.id ?? '');
                                          }
                                        },
                                        itemBuilder: (BuildContext context) => [
                                          const PopupMenuItem(
                                              value: 'update', child: Text('Update')),
                                          const PopupMenuItem(
                                              value: 'delete', child: Text('Delete')),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6.0, vertical: 4.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            product.name?.isNotEmpty == true
                                                ? ((product.name!.length > 20)
                                                ? '${product.name!.substring(0, 20)}...'
                                                : product.name!)
                                                : 'No Name',
                                            style: const TextStyle(fontSize: 10),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Text(
                                          'Stock: ${product.getTotalQuantity() ?? 0}',
                                          style: const TextStyle(
                                            fontSize: 9,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Builder(
                                          builder: (context) {
                                            final priceRange = product.getPriceRange();
                                            if (priceRange != null &&
                                                priceRange.isNotEmpty &&
                                                priceRange.contains('~~')) {
                                              return Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    '৳${priceRange.replaceAll('~~', '')}',
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 9,
                                                      decoration:
                                                      TextDecoration.lineThrough,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 3),
                                                ],
                                              );
                                            }
                                            return const SizedBox.shrink();
                                          },
                                        ),
                                        Text(
                                          '৳${product.getDiscountedPriceRange() ?? '0'}',
                                          style: TextStyle(
                                            color: Theme.of(context).primaryColor,
                                            fontSize: 9,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            }),
          );
        }
    );
  }

  void _showDeleteConfirmation(BuildContext context, String productId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this product?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Delete"),
              onPressed: () {
                Navigator.of(context).pop();
                controller.deleteProduct(
                  productId,
                      (success, {errorMessage}) {
                    if (success) {
                      Get.snackbar('Success', 'Product deleted successfully');
                      controller.getProductsForSubCategory(
                          subcategoryId: subcategoryId, userId: userId);
                    } else {
                      Get.snackbar(
                          'Error', errorMessage ?? 'Failed to delete product');
                    }
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}
