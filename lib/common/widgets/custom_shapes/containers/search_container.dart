// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:iconsax/iconsax.dart';
//
// import '../../../../utils/constants/colors.dart';
// import '../../../../utils/constants/sizes.dart';
// import '../../../../utils/device/device_utility.dart';
// import '../../../../utils/helpers/helper_functions.dart';
//
// class SearchContainer extends StatelessWidget {
//   const SearchContainer({
//     Key? key,
//     required this.text,
//     this.icon = Iconsax.search_normal,
//     this.showBackground = true,
//     this.showBorder = true,
//     this.padding = const EdgeInsets.symmetric(horizontal: Sizes.defaultSpace),
//   }) : super(key: key);
//
//   final String text;
//   final IconData? icon;
//   final bool showBackground, showBorder;
//   final EdgeInsetsGeometry padding;
//
//   @override
//   Widget build(BuildContext context) {
//     final darkMode = HelperFunctions.isDarkMode(context);
//
//     return GestureDetector(
//       onTap: () => Get.to(() => SearchScreen()),
//       child: Padding(
//         padding: padding,
//         child: Container(
//           width: DeviceUtils.getScreenWidth(context),
//           padding: const EdgeInsets.all(Sizes.md),
//           decoration: BoxDecoration(
//             color: showBackground
//                 ? darkMode
//                 ? AppColors.dark
//                 : AppColors.light
//                 : Colors.transparent,
//             borderRadius: BorderRadius.circular(Sizes.cardRadiusLg),
//             border: showBorder ? Border.all(color: AppColors.grey) : null,
//           ),
//           child: Row(
//             children: [
//               Icon(icon, color: AppColors.darkerGrey),
//               const SizedBox(width: Sizes.spaceBtwItems),
//               Text(text, style: Theme.of(context).textTheme.bodySmall),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
