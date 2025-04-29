// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:karmalab_assignment/utils/constants/sizes.dart';
// import '../../../common/widgets/texts/section_heading.dart';
// import '../../../controllers/review_controller.dart';
// import '../../../models/product_model.dart';
// import '../product_reviews.dart';
//
// class ProductReviewsList extends StatefulWidget {
//   final Product product;
//   const ProductReviewsList({super.key, required this.product});
//   @override
//   State<ProductReviewsList> createState() => _ProductReviewsListState();
// }
// class _ProductReviewsListState extends State<ProductReviewsList> {
//   final controller = Get.find<ReviewController>();
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//
//             Obx(() => SectionHeading(title: 'Rating & Reviews(${controller.isLoading.value ? '...' : controller.reviews.where((review) => review.review?.isNotEmpty == true && review.replyTo == null).toList().length})', showActionButton: false,)),
//             IconButton(onPressed: () => Get.to(() => ProductReviewsScreen(productId: widget.product.id ?? '')), icon: const Icon(Iconsax.arrow_right_3, size: 18),),],),
//         const SizedBox(height: Sizes.spaceBtwItems),
//         Obx(() {
//           if (controller.isLoading.value) {return Column(children: List.generate(3, (index) => const ReviewItem(isLoading: true),),);}
//           final reviews = controller.reviews.where((review) => review.review != null && review.review!.isNotEmpty).take(3).toList();
//           if (reviews.isEmpty) {return const Center(child: Text('No reviews yet'));}
//           return Column(children: reviews.map((review) => ReviewItem(review: review)).toList(),);}),
//       ],
//     );
//   }
// }
