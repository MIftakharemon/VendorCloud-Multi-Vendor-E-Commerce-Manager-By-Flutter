import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:karmalab_assignment/utils/constants/colors.dart';

import '../../../utils/device/device_utility.dart';
import '../../../utils/helpers/helper_functions.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.showBackArrow = false,
    this.leadingIcon,
    this.actions,
    this.leadingOnPressed,
  });

  final Widget? title;
  final bool showBackArrow;
  final IconData? leadingIcon;
  final List<Widget>? actions;
  final VoidCallback? leadingOnPressed;

  @override
  Widget build(BuildContext context) {
    final isDark = HelperFunctions.isDarkMode(context);
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0, // Set elevation to 0 to avoid shadow changes on scroll
      automaticallyImplyLeading: false,
      leading: showBackArrow
          ? IconButton(
        onPressed: () => Get.back(),
        icon: Icon(Iconsax.arrow_left, color: isDark ? AppColors.white : AppColors.dark),
      )
          : leadingIcon != null
          ? IconButton(onPressed: leadingOnPressed, icon: Icon(leadingIcon))
          : null,
      title: title,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(DeviceUtils.getAppBarHeight());
}
