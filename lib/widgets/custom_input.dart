import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/constants/colors.dart';

class CustomInputFelid extends StatelessWidget {
  const CustomInputFelid({
    Key? key,
    this.hint,
    this.isPassWord = false,
    this.secure = false,
    this.toggle,
    this.keyboardType = TextInputType.text,
    this.lowerMargin = false,
    this.controller,
    this.decoration,  // Add this line
  }) : super(key: key);

  final String? hint;
  final TextInputType? keyboardType;
  final bool? isPassWord;
  final bool? secure;
  final Function()? toggle;
  final bool? lowerMargin;
  final TextEditingController? controller;
  final InputDecoration? decoration;  // Add this line

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: lowerMargin! ? 18 : 35),
      decoration: BoxDecoration(
        color: AppColors.deepOrange.withOpacity(.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        obscureText: secure!,
        keyboardType: keyboardType,
        cursorColor: AppColors.darkOrange,
        style: GoogleFonts.openSans(color: AppColors.darkOrange),
        decoration: decoration?.copyWith(
          hintText: hint,
          hintStyle: GoogleFonts.openSans(color: AppColors.darkOrange),
          suffixIcon: isPassWord!
              ? GestureDetector(
            onTap: toggle,
            child: Icon(
              secure! ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              color: AppColors.darkOrange,
            ),
          )
              : null,
        ) ?? InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          border: InputBorder.none,
          hintText: hint,
          hintStyle: GoogleFonts.openSans(color: AppColors.darkOrange),
          suffixIcon: isPassWord!
              ? GestureDetector(
            onTap: toggle,
            child: Icon(
              secure! ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              color: AppColors.darkOrange,
            ),
          )
              : null,
        ),
      ),
    );
  }
}
