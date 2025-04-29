import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:karmalab_assignment/controllers/category_controller.dart';
import 'package:karmalab_assignment/controllers/product_controller.dart';

class DropDownButtonSubCategory extends StatelessWidget {
  const DropDownButtonSubCategory({
    super.key,
    required this.categoryController,
    required this.controller,
  });

  final CategoryController categoryController;
  final ProductController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final subCategories = categoryController
          .selectedCategory.value?.subCategories ??
          [];

      // Clear the selected subcategory and controller text if the current subcategory is not in the new category's subcategories
      if (controller
          .subCategoryController.text.isNotEmpty &&
          !subCategories.any((subCat) =>
          subCat.sId ==
              controller.subCategoryController.text)) {
        controller.subCategoryController.text = '';
        categoryController.selectedSubCategory.value =
        null; // Reset selected subcategory
      }

      return DropdownButtonFormField<String>(
        borderRadius: BorderRadius.circular(15), // Round the corners of the dropdown menu
        dropdownColor: Colors.white, // Set the background color of the dropdown menu

        decoration: InputDecoration(
          labelText: 'Subcategory',
          prefixIcon: const Icon(FontAwesomeIcons.tags,
              color: Colors.blue),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
                color: Colors.blue.withOpacity(0.5)),
          ),
        ),
        value: controller.subCategoryController.text
            .isNotEmpty &&
            subCategories.any((subCat) =>
            subCat.sId ==
                controller.subCategoryController.text)
            ? controller.subCategoryController.text
            : null,
        items: subCategories.map((subCategory) {
          return DropdownMenuItem<String>(
            value: subCategory.sId,
            child: Text(subCategory.name ?? ''),
          );
        }).toList(),
        onChanged: (String? subCategoryId) {
          if (subCategoryId != null) {
            categoryController
                .setSelectedSubCategory(subCategoryId);
          } else {
            controller.subCategoryController.text = '';
            categoryController.selectedSubCategory.value =
            null;
          }
        },
      );
    });
  }
}
