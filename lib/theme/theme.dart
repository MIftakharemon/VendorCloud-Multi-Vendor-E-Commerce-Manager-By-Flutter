import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karmalab_assignment/utils/constants/colors.dart';
import 'package:karmalab_assignment/utils/theme/widget_themes/text_theme.dart';

import '../utils/theme/widget_themes/appbar_theme.dart';
import '../utils/theme/widget_themes/bottom_sheet_theme.dart';
import '../utils/theme/widget_themes/checkbox_theme.dart';
import '../utils/theme/widget_themes/chip_theme.dart';
import '../utils/theme/widget_themes/elevated_button_theme.dart';
import '../utils/theme/widget_themes/outlined_button_theme.dart';
import '../utils/theme/widget_themes/text_field_theme.dart';

class AppTheme {
  AppTheme._();

  const AppTheme();
  static ThemeData theme() {
    return
      ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      disabledColor: AppColors.grey,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      textTheme: CustomTextTheme.lightTextTheme,
      chipTheme: CustomChipTheme.lightChipTheme,
      scaffoldBackgroundColor: AppColors.white,
      appBarTheme: CustomAppBarTheme.lightAppBarTheme,
      checkboxTheme: CustomCheckboxTheme.lightCheckboxTheme,
      bottomSheetTheme: BottomSheetTheme.lightBottomSheetTheme,
      elevatedButtonTheme: CustomElevatedButtonTheme.lightElevatedButtonTheme,
      outlinedButtonTheme: CustomOutlinedButtonTheme.lightOutlinedButtonTheme,
      inputDecorationTheme: TextFormFieldTheme.lightInputDecorationTheme,
    );
  }
}
