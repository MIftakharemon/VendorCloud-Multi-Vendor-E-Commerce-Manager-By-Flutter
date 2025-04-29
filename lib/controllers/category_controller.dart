import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karmalab_assignment/controllers/product_controller.dart';
import 'package:karmalab_assignment/models/category_model.dart';
import '../services/category_service.dart';
import 'image_controller.dart';

class CategoryController extends GetxController {
  final CategoryService _categoryService = CategoryService();
  final MediaController imageController = Get.put(MediaController());
  final ProductController controller = Get.put(ProductController());

  // Controllers for category details
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _shippingChargeController = TextEditingController();
  final TextEditingController _vatController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _commissionController = TextEditingController();
  final TextEditingController _iconController = TextEditingController();

  var isLoading = false.obs;
  var categoryList = <Data>[].obs;
  var selectedCategory = Rxn<Data>();
  var selectedSubCategory = Rxn<SubCategories>();
  var setSelectedCategoryId = Rxn<String>();


  @override
  void onInit() {
    getCategories();
    super.onInit();
  }

  // Getters for the controllers
  TextEditingController get nameController => _nameController;
  TextEditingController get shippingChargeController => _shippingChargeController;
  TextEditingController get vatController => _vatController;
  TextEditingController get statusController => _statusController;
  TextEditingController get commissionController => _commissionController;
  TextEditingController get iconController => _iconController;

  // Getter for categories
  List<Data> get categories => categoryList;

  bool validate() {
    final name = nameController.text.trim();
    final shippingCharge = shippingChargeController.text.trim();
    final vat = vatController.text.trim();
    final commission = commissionController.text.trim();
    final image = imageController.imageBase64;

    // Validate that all required fields are filled
    if (name.isEmpty ||
        shippingCharge.isEmpty ||
        vat.isEmpty ||
        commission.isEmpty ||
        image.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please fill all required fields and upload an image.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    // Validate numbers
    if (double.tryParse(shippingCharge) == null) {
      Get.snackbar(
        'Validation Error',
        'Shipping charge must be a valid number.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (double.tryParse(vat) == null) {
      Get.snackbar(
        'Validation Error',
        'VAT must be a valid number.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (double.tryParse(commission) == null) {
      Get.snackbar(
        'Validation Error',
        'Commission must be a valid number.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    return true;

  }



// Update this method to set the selected category
  void setSelectedCategory(String categoryId) {
    // Find the category by id or return a default Data object
    final category = categoryList.firstWhere(
          (cat) => cat.sId == categoryId,
      orElse: () => Data(),
    );

    // Check if the category is valid
    if (category.sId != null) {
      selectedCategory.value = category; // Update the selected category
      controller.categoryController.text = categoryId;
      print('the category ............. ${controller.categoryController.text}' );// Update text controller
// Update text controller
      // Get the list of subcategories for the selected category
      final subCategories = category.subCategories ?? [];

      // Reset the selected subcategory and subcategory text controller
      if (subCategories.isNotEmpty) {
        selectedSubCategory.value = subCategories.first;
        controller.subCategoryController.text = subCategories.first.sId ?? '';
      } else {
        selectedSubCategory.value = null;
        controller.subCategoryController.text = '';
      }
    }
  }

// Update this method to set the selected subcategory
  void setSelectedSubCategory(String subCategoryId) {
    if (selectedCategory.value != null) {
      // Find the subcategory by id or return a default SubCategories object
      final subCategory = selectedCategory.value!.subCategories?.firstWhere(
            (subCat) => subCat.sId == subCategoryId,
        orElse: () => SubCategories(),
      );

      // Check if the subcategory is valid
      if (subCategory != null && subCategory.sId != null) {
        selectedSubCategory.value = subCategory; // Update the selected subcategory
        controller.subCategoryController.text = subCategoryId;
        print('the Subcategory controller is............. ${controller.subCategoryController.text}' );// Update text controller

      }
    }
  }





  // // Update this method to set the selected category
  // void setSelectedCategory(String categoryId) {
  //   final category = categoryList.firstWhere((cat) => cat.sId == categoryId, orElse: () => Data());
  //   if (category.sId != null) {
  //     selectedCategory.value = category;
  //     selectedSubCategory.value = null; // Reset subcategory when category changes
  //     controller.subCategoryController.text = ''; // Reset the subcategory text controller
  //   }
  // }
  //
  //
  // // Add this method to set the selected subcategory
  // void setSelectedSubCategory(String subCategoryId) {
  //   if (selectedCategory.value != null) {
  //     final subCategory = selectedCategory.value!.subCategories?.firstWhere(
  //           (subCat) => subCat.sId == subCategoryId,
  //       orElse: () => SubCategories(),
  //     );
  //     if (subCategory != null && subCategory.sId != null) {
  //       selectedSubCategory.value = subCategory;
  //     }
  //   }
  // }










  // Create category
  Future<void> createCategory(
      Function(Category?, {String? errorMessage})? onCreate) async {
    final valid = validate();

    if (valid) {
      final category = Data(
        name: nameController.text,
        shippingCharge: shippingChargeController.text,
        vat: vatController.text,
        status: statusController.text,
        commission: commissionController.text,
        image: imageController.imageBase64,
        icon: iconController.text,
      );

      try {
        isLoading.value = true;
        final createdCategory = await _categoryService.createCategory(category.toJson());
        isLoading.value = false;
        if (onCreate != null) onCreate(createdCategory);
      } catch (e) {
        isLoading.value = false;
        if (onCreate != null) onCreate(null, errorMessage: e.toString());
      }
    }
  }

  Future<void> getCategories() async {
    try {
      isLoading.value = true;
      final categoryResponse = await _categoryService.getAllCategories();
      isLoading.value = false;
      if (categoryResponse != null && categoryResponse.data != null) {
        categoryList.assignAll(categoryResponse.data!);
      } else {
        categoryList.clear();
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to fetch products: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

// Fetch categories by ID

  Future<void> getCategoryById(
      String id, Function(Category, {String? errorMessage})?) async {
    try {
      isLoading.value = true;
      final productResponse = await _categoryService.getCategoryById(id);
      isLoading.value = false;
      if (productResponse != null && productResponse.data != null) {
        categoryList.assignAll(productResponse.data!);
      } else {
        categoryList.clear();
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to fetch products: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Update category
// Update category
Future<void> updateCategoryById(String id, Category category) async {
  try {
    isLoading.value = true;
    final updatedCategoryResponse = await _categoryService.updateCategoryById(id, category.toJson());
    isLoading.value = false;
    final updatedCategory = Category.FromJson(updatedCategoryResponse as Map<String, dynamic>);
    // Handle the updated category as needed
  } catch (e) {
    isLoading.value = false;
    Get.snackbar('Error', 'Failed to update category: $e', snackPosition: SnackPosition.BOTTOM);
  }
}










}
