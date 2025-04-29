import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:karmalab_assignment/controllers/category_controller.dart';

class DropDownButtonForCategory extends StatelessWidget {
  const DropDownButtonForCategory({
    super.key,
    required this.categoryController,
  });

  final CategoryController categoryController;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return DropdownButtonFormField(
        isExpanded: true,
        decoration: InputDecoration(
          labelText: 'Category',
          prefixIcon: const Icon(FontAwesomeIcons.layerGroup, color: Colors.blue),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.blue.withOpacity(0.5)),
          ),
        ),
        value: categoryController.selectedCategory.value?.sId,
        items: categoryController.categories.map((category) {
          return DropdownMenuItem(
            value: category.sId,
            child: Text(category.name),
          );
        }).toList(),
        onChanged: (String? categoryId) {
          if (categoryId != null) {
            categoryController.setSelectedCategory(categoryId);
          }
        },
        dropdownColor: Colors.white, // Set the background color of the dropdown menu
        menuMaxHeight: 200, // Set the maximum height of the dropdown menu
        borderRadius: BorderRadius.circular(15), // Round the corners of the dropdown menu
      );
    });
  }
}