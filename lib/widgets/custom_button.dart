import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmalab_assignment/utils/dimension.dart';

import '../utils/constants/colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    this.label = "label",
    this.isFilled = true,
    this.onTap,
    this.isLoading = false,
  }) : super(key: key);
  final bool? isFilled;
  final String? label;
  final Function()? onTap;
  final bool? isLoading;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: ButtonStyle(
        overlayColor: WidgetStateColor.resolveWith(
            (states) => AppColors.deepOrange.withOpacity(.1)),
        shadowColor:
            WidgetStateProperty.resolveWith((states) => AppColors.darkOrange),
        side: WidgetStateProperty.resolveWith(
          (states) => BorderSide(
              color: isFilled! ? AppColors.transparent : AppColors.darkOrange),
        ),
        backgroundColor: WidgetStateProperty.resolveWith(
          (states) => isFilled! ? AppColors.darkOrange : AppColors.transparent,
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: context.getHeight(5),
        child: Center(
          child: isLoading!
              ? const CupertinoActivityIndicator(
                  color: AppColors.white,
                )
              : Text(
                  label!,
                  style: GoogleFonts.openSans(
                      color: isFilled! ? AppColors.white : AppColors.darkOrange,
                      fontSize: 20),
                ),
        ),
      ),
    );
  }
}
