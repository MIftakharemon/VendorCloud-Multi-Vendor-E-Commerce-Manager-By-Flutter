// import 'package:ecommerce_store/features/shop/models/category_model.dart';
// import 'package:get/get.dart';
// import '../../features/shop/controllers/category_controller.dart';
// import '../../features/shop/models/cart_item_model.dart';
//
// class PricingCalculator extends GetxController {
//   static PricingCalculator get instance => Get.find();
//
//   final CategoryController _categoryController = CategoryController.instance;
//
//   final RxDouble subTotal = 0.0.obs;
//   final RxDouble totalVAT = 0.0.obs;
//   final RxDouble totalCommission = 0.0.obs;
//   final RxDouble totalTransactionCost = 0.0.obs;
//   final RxDouble totalShippingCost = 0.0.obs;
//   final RxDouble totalProfit = 0.0.obs;
//   final RxDouble grandTotal = 0.0.obs;
//   final RxBool isCalculating = false.obs;
//   final RxDouble discountAmount = 0.0.obs;
//   final RxString discountType = ''.obs;
//   final RxDouble discountValue = 0.0.obs;
//
//   double parseStringToDouble(String? value, String? type) {
//     if (value == null || value.isEmpty) return 0.0;
//     if (type == "percentage" && (value == "0" || value.isEmpty)) return 0.0;
//     if (type == "flat" && (value == "0" || value.isEmpty)) return 0.0;
//     return double.tryParse(value) ?? 0.0;
//   }
//
//   void resetTotals() {
//     subTotal.value = 0.0;
//     totalVAT.value = 0.0;
//     totalCommission.value = 0.0;
//     totalTransactionCost.value = 0.0;
//     totalShippingCost.value = 0.0;
//     totalProfit.value = 0.0;
//     grandTotal.value = 0.0;
//     discountAmount.value = 0.0;
//     discountType.value = '';
//     discountValue.value = 0.0;
//     isCalculating.value = false;
//   }
//
//   void calculateItemPrices({
//     required double itemSubTotal,
//     required int quantity,
//     required double vatRate,
//     required double commissionRate,
//     required double transactionRate,
//     required double shippingRate,
//     required dynamic category,
//   }) {
//     String? vatType;
//     String? commissionType;
//     String? transactionCostType;
//     String? shippingChargeType;
//
//     if (category is CategoryModel) {
//       vatType = category.vatType;
//       commissionType = category.commissionType;
//       transactionCostType = category.transactionCostType;
//       shippingChargeType = category.shippingChargeType;
//     } else if (category is SubCategories) {
//       vatType = category.vatType;
//       commissionType = category.commissionType;
//       transactionCostType = category.transactionCostType;
//       shippingChargeType = category.shippingChargeType;
//     }
//
//     vatType ??= "flat";
//     commissionType ??= "flat";
//     transactionCostType ??= "flat";
//     shippingChargeType ??= "flat";
//
//     double itemVAT = vatType == "percentage"
//         ? (itemSubTotal * vatRate / 100)
//         : vatRate * quantity;
//     totalVAT.value += itemVAT;
//
//     double itemCommission = commissionType == "percentage"
//         ? (itemSubTotal * commissionRate / 100)
//         : commissionRate * quantity;
//     totalCommission.value += itemCommission;
//
//     double itemTransactionCost = transactionCostType == "percentage"
//         ? (itemSubTotal * transactionRate / 100)
//         : transactionRate * quantity;
//     totalTransactionCost.value += itemTransactionCost;
//
//     double itemShipping = shippingChargeType == "percentage"
//         ? (itemSubTotal * shippingRate / 100)
//         : shippingRate * quantity;
//     totalShippingCost.value += itemShipping;
//
//     double itemProfit =
//         itemSubTotal - (itemVAT + itemCommission + itemTransactionCost);
//     totalProfit.value += itemProfit;
//   }
//
//   void calculateGrandTotal() {
//     (grandTotal.value = subTotal.value +
//         totalVAT.value +
//         totalCommission.value +
//         totalTransactionCost.value +
//         totalShippingCost.value -
//         discountAmount.value);
//   }
//
//   void applyDiscount(String type, double value) {
//     discountType.value = type;
//     discountValue.value = value.toDouble();
//
//     if (type == 'percentage') {
//       discountAmount.value = (grandTotal.value * value ~/ 100).toDouble();
//     } else {
//       discountAmount.value = value.toDouble();
//     }
//
//     calculateGrandTotal();
//   }
//
//   Future<void> calculateTotalPrices(List<CartItemModel> cartItems) async {
//     if (cartItems.isEmpty) return;
//
//     try {
//       isCalculating.value = true;
//       resetTotals();
//
//       for (var item in cartItems) {
//         if (item.price == null) continue;
//
//         final categoryId =
//             (item.subCategory != null && item.subCategory!.isNotEmpty)
//                 ? item.subCategory
//                 : item.category;
//         ('The category id is ..........................$categoryId');
//
//         if (categoryId == null) continue;
//
//         dynamic selectedCategory;
//
//         if (item.subCategory != null && item.subCategory!.isNotEmpty) {
//           await _categoryController.getSubCategoriesForProductPrice(categoryId);
//           selectedCategory =
//               _categoryController.SubCategoryForProductPriceInfo.value;
//         }
//
//         if (selectedCategory == null) {
//           await _categoryController.getCategoryById(categoryId);
//           selectedCategory =
//               _categoryController.CategoryForProductPriceInfo.value;
//         }
//
//         if (selectedCategory == null) continue;
//
//         double itemSubTotal = item.price! * item.quantity;
//         subTotal.value += itemSubTotal;
//
//         double vatRate =
//             parseStringToDouble(selectedCategory.vat, selectedCategory.vatType);
//         double commissionRate = parseStringToDouble(
//             selectedCategory.commission, selectedCategory.commissionType);
//         double transactionRate = parseStringToDouble(
//             selectedCategory.transactionCost,
//             selectedCategory.transactionCostType);
//         double shippingRate = parseStringToDouble(
//             selectedCategory.shippingCharge,
//             selectedCategory.shippingChargeType);
//
//         calculateItemPrices(
//           itemSubTotal: itemSubTotal,
//           quantity: item.quantity,
//           vatRate: vatRate,
//           commissionRate: commissionRate,
//           transactionRate: transactionRate,
//           shippingRate: shippingRate,
//           category: selectedCategory,
//         );
//       }
//
//       calculateGrandTotal();
//     } finally {
//       isCalculating.value = false;
//     }
//   }
//
//   String formatPrice(double amount) => amount.toStringAsFixed(2);
// }
