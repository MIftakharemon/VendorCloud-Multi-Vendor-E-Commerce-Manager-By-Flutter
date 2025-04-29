import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:karmalab_assignment/controllers/event_product_controller.dart';
import '../../controllers/event_ad_management_package_controller.dart';
import '../../models/product_model.dart';

class ProductListItem extends StatelessWidget {
  final Product product;
  final String parentId;
  final bool isPackage;
  final dynamic controller;

  const ProductListItem({
    Key? key,
    required this.product,
    required this.parentId,
    required this.controller,
    required this.isPackage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image with animation
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.grey[200]!,
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: product.coverPhoto != null && product.coverPhoto!.isNotEmpty
                    ? Image.network(
                  product.coverPhoto!,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[100],
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey[400],
                        size: 30,
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey[100],
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                              : null,
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  },
                )
                    : Container(
                  color: Colors.grey[100],
                  child: Icon(
                    Icons.image_not_supported,
                    color: Colors.grey[400],
                    size: 30,
                  ),
                ),
              ),
            ).animate()
                .fadeIn(duration: Duration(milliseconds: 600))
                .scale(delay: Duration(milliseconds: 200)),
            const SizedBox(width: 16),

            // Product Details with animation
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name ?? 'Unnamed Product',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ).animate()
                      .fadeIn(duration: Duration(milliseconds: 600))
                      .slideX(begin: 0.2, end: 0),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price section with wrap
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Builder(
                              builder: (context) {
                                final priceRange = product.getPriceRange();
                                if (priceRange != null &&
                                    priceRange.isNotEmpty &&
                                    priceRange.contains('~~')) {
                                  return Text(
                                    '৳${priceRange.replaceAll('~~', '')}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 9,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                    softWrap: true,
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                            Text(
                              '৳${product.getDiscountedPriceRange() ?? '0'}',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 12,
                              ),
                              softWrap: true,
                            ),
                          ],
                        ).animate().fadeIn(delay: Duration(milliseconds: 200)),
                      ),

                      // Add Product button
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Obx(() {
                          isPackage
                              ? (controller.packageProducts.any((ep) => product.id == product.id))
                              : (controller.eventProducts.any((ep) => product.id == product.id));

                          return SizedBox(
                            width: 90,
                            height: 36,
                            child: ElevatedButton(
                              onPressed: () => controller.addProductToEventOrPackage(
                                product,
                                parentId,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                elevation: 0,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Add Product',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ).animate()
                              .fadeIn(delay: Duration(milliseconds: 400))
                              .scale(delay: Duration(milliseconds: 400));
                        }),
                      ),
                    ],
                  ),

                  if (product.summary != null && product.summary!.isNotEmpty)
                    Text(
                      product.summary!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ).animate()
                        .fadeIn(delay: Duration(milliseconds: 300))
                        .slideX(begin: 0.2, end: 0),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate()
        .fadeIn(duration: Duration(milliseconds: 800))
        .slideY(begin: 0.2, end: 0);
  }
}
