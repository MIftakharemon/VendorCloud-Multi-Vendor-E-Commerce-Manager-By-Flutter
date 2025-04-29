import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

Widget customDropdown({
  required String labelText,
  required String? value,
  required List<String> items,
  required ValueChanged<String?> onChanged,
}) {
  return Expanded(
    child: Theme(
      data: Theme.of(Get.context!).copyWith(
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners
            borderSide: const BorderSide(color: Colors.black54),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black54),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black, width: 1.5),
          ),
          filled: true, // Enable filling the background
          fillColor: Colors.white, // White background
        ),
      ),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.black87, fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 12),
        ),
        value: value,
        items: items
            .map((item) => DropdownMenuItem(
          value: item,
          child: Text(
            item,
            style: const TextStyle(color: Colors.black87), // Text color
          ),
        ))
            .toList(),
        onChanged: onChanged,
        style: const TextStyle(color: Colors.black87), // Selected item text color
        icon: const Icon(Icons.arrow_drop_down, color: Colors.black54), // Dropdown icon
        dropdownColor: Colors.white, // Dropdown background color
        borderRadius: BorderRadius.circular(12), // Rounded corners for dropdown
        elevation: 2, // Add a slight shadow
      ),
    ),
  );
}