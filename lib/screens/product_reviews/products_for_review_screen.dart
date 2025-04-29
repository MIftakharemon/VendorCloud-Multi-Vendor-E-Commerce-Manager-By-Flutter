import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:karmalab_assignment/screens/product_reviews/product_reviews.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/user_controller.dart';
import '../../utils/constants/colors.dart';
import '../product_queries/product_question_ans.dart';

class ProductsListScreen extends GetView<ProductController> {
  static const routeNameReviews = "/products_list";
  static const routeNameQA = "/products_for_qa";

  final bool isReviewScreen;

  const ProductsListScreen({
    super.key,
    this.isReviewScreen = true,
  });
  String get routeName => isReviewScreen ? routeNameReviews : routeNameQA;

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();
    final user = userController.user.value;


    controller.getProducts(userId: user!.id??'');
    return Scaffold(
      appBar: AppBar(
        title: Text(isReviewScreen ? 'Products Reviews' : 'Products Q/A'),
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.products.isEmpty) {
          return const Center(child: Text('No products available.'));
        } else {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.products.length,
            itemBuilder: (context, index) {
              final product = controller.products[index];
              return Card(
                color: AppColors.white,
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 3,
                shadowColor: Colors.grey.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: Colors.grey.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Get.to(() => isReviewScreen
                        ? ProductReviewsScreen(productId: product.id ?? '')
                        : ProductQuestionAnswerScreen(productId: product.id ?? '')
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: product.coverPhoto != null
                                ? Image.network(
                              product.coverPhoto,
                              fit: BoxFit.cover,
                            )
                                : Container(
                              color: Colors.grey[200],
                              child: Icon(Icons.image,
                                  color: Colors.grey[400], size: 40),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 0.3,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),



                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
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
                                                fontSize: 12,
                                                decoration: TextDecoration.lineThrough,
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
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),






                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  // const Icon(
                                  //   Icons.star,
                                  //   size: 18,
                                  //   color: Colors.amber,
                                  // ),
                                  const SizedBox(width: 4),
                                  // Text(
                                  //   '4.5',
                                  //   style: Theme.of(context)
                                  //       .textTheme
                                  //       .bodyMedium
                                  //       ?.copyWith(
                                  //     fontWeight: FontWeight.w500,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        //Icon(Icons.chevron_right, color: Colors.grey[600]),
                      ],
                    ),
                  ),
                ),
              ).animate()
                  .fadeIn(
                duration: Duration(milliseconds: 1000),
                delay: Duration(milliseconds: 15 * index),
                curve: Curves.easeOutQuart,
              )
                  .slideY(
                begin: 0.5,
                end: 0,
                duration: Duration(milliseconds: 1000),
                delay: Duration(milliseconds: 15 * index),
                curve: Curves.easeOutQuart,
              );
            },
          );
        }
      }),
    );
  }
}
