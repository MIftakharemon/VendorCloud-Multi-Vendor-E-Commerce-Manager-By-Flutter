import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/sizes.dart';

class CustomCheckboxTheme {
  CustomCheckboxTheme._();


  static CheckboxThemeData lightCheckboxTheme = CheckboxThemeData(
    shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(Sizes.xs)),
    checkColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.white;
      } else {
        return AppColors.black;
      }
    }),
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.primary;
      } else {
        return Colors.transparent;
      }
    }),
  );


  static CheckboxThemeData darkCheckboxTheme = CheckboxThemeData(
    shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(Sizes.xs)),
    checkColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.white;
      } else {
        return AppColors.black;
      }
    }),
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.primary;
      } else {
        return Colors.transparent;
      }
    }),
  );
}
