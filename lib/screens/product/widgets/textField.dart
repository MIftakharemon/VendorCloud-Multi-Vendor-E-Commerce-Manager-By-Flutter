import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:karmalab_assignment/controllers/product_controller.dart';
//final ProductController textFieldController = Get.find<ProductController>();


Widget buildTextField({
  required TextEditingController controller,
  required String label,
  IconData? icon,
  Color iconColor = Colors.blue,
  TextInputType keyboardType = TextInputType.text,
  int maxLines = 1,
  EdgeInsetsGeometry contentPadding = const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
}) {
  return TextField(
    controller: controller,
    keyboardType: keyboardType,
    maxLines: maxLines,
    style: const TextStyle(fontSize: 14),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: Colors.black87,
        fontSize: 14,
      ),
      prefixIcon: icon != null ? Icon(icon, color: iconColor, size: 20) : null,

      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.black54, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.black54, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.black, width: 1.5),
      ),
      contentPadding: contentPadding,
    ),
  );
}