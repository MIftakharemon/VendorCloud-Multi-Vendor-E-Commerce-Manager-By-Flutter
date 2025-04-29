//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:iconsax/iconsax.dart';
//
// class PaymentTile extends StatelessWidget {
//   const PaymentTile({super.key, required this.paymentMethod});
//
//   final PaymentMethodModel paymentMethod;
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = CheckoutController.instance;
//     return ListTile(
//       contentPadding: const EdgeInsets.all(0),
//       onTap: () {
//         controller.selectedPaymentMethod.value = paymentMethod;
//         Get.back();
//       },
//       leading: RoundedContainer(
//         width: 55,
//         height: 45,
//         backgroundColor: HelperFunctions.isDarkMode(context) ? AppColors.light : AppColors.white,
//         padding: const EdgeInsets.all(Sizes.sm),
//         child: Image(image: AssetImage(paymentMethod.image), fit: BoxFit.contain),
//       ),
//       title: Text(paymentMethod.name),
//       trailing: const Icon(Iconsax.arrow_right_34),
//     );
//   }
// }
