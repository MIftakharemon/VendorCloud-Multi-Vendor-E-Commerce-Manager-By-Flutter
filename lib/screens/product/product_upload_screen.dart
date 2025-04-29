import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:karmalab_assignment/screens/product/widgets/additioal_images.dart';
import 'package:karmalab_assignment/screens/product/widgets/categoryDropDown.dart';
import 'package:karmalab_assignment/screens/product/widgets/coverphoto.dart';
import 'package:karmalab_assignment/screens/product/widgets/customDropDownButton.dart';
import 'package:karmalab_assignment/screens/product/widgets/dropDownButtonItems.dart';
import 'package:karmalab_assignment/screens/product/widgets/electronic_product_details.dart';
import 'package:karmalab_assignment/screens/product/widgets/packaging.dart';
import 'package:karmalab_assignment/screens/product/widgets/subCategoryDropDown.dart';
import 'package:karmalab_assignment/screens/product/widgets/textField.dart';
import 'package:karmalab_assignment/screens/product/widgets/video.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/category_controller.dart';
import '../../utils/constants/colors.dart';
import '../commonWidgets/handleButtonOperation.dart';

class ProductCreationScreen extends GetView<ProductController> {
  static const routeName = "/productUploadScreen";
  final CategoryController categoryController = Get.put(CategoryController());


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        controller.onClose();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Product',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600)),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  coverPhotoSection(controller: controller),
                  const SizedBox(height: 8),
                  AdditionalImagesSection(controller: controller),
                  const SizedBox(height: 8),
                  videoSection(controller: controller),
                  const SizedBox(height: 8),
                  _buildProductDetailsContent(),
                  const SizedBox(height: 8),
                  _buildProductVariantsContent(),
                  const SizedBox(height: 12),
                  Obx(() => ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : _handleCreateProduct,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:AppColors.darkOrange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 4, // Elevation retained
                          shadowColor: Colors.black.withOpacity(0.2),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 12), // Adjusted for better spacing
                          minimumSize: const Size(
                              100, 50), // Smaller width, increased height
                        ),
                        child: controller.isLoading.value
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                  strokeWidth: 2.0,
                                ),
                              )
                            : const Text(
                                'Create Product',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  letterSpacing: 0.3,
                                ),
                              ),
                      )),
                  const SizedBox(height: 20),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductDetailsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildTextField(
            controller: controller.nameController,
            label: 'Name',
            icon: FontAwesomeIcons.tag,
            iconColor: Colors.blue,
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
        const SizedBox(height: 8),
        buildTextField(
            controller: controller.summaryController,
            label: 'Summary',
            icon: FontAwesomeIcons.alignLeft,
            maxLines: 2,
            iconColor: Colors.orange,
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
        const SizedBox(height: 8),
        buildTextField(
            controller: controller.descriptionController,
            label: 'Description',
            icon: FontAwesomeIcons.alignJustify,
            maxLines: 3,
            iconColor: Colors.purple,
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
                child: DropDownButtonForCategory(
                    categoryController: categoryController)),
            const SizedBox(width: 8),
            Expanded(
                child: DropDownButtonSubCategory(
                    categoryController: categoryController,
                    controller: controller)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
                child: buildTextField(
                    controller: controller.brandController,
                    label: 'Brand',
                    icon: FontAwesomeIcons.trademark,
                    iconColor: Colors.red,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 4))),
            const SizedBox(width: 8),
            customDropdown(
              labelText: 'Warranty',
              value: controller.warrantyController.text.isEmpty
                  ? null
                  : controller.warrantyController.text,
              items: warrantyOptions,
              onChanged: (value) {
                controller.warrantyController.text = value!;
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        packaging(controller: controller),
        const SizedBox(height: 8),
        SpecificationsScreen(controller: controller),
      ],
    );
  }

  Widget _buildProductVariantsContent() {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.remove_circle_outline,
                      color: Colors.black, size: 24),
                  onPressed: () => controller.decrementVariantCount(),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
                SizedBox(width: 12),
                Text(
                  '${controller.variantCount.value}',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.red),
                ),
                SizedBox(width: 12),
                IconButton(
                  icon: Icon(Icons.add_circle_outline, color: Colors.black, size: 24),
                  onPressed: () => controller.incrementVariantCount(),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...List.generate(controller.variantCount.value, (index) => _buildVariantFields(index)),
          ],
        ));
  }

  Widget _buildVariantFields(int index) {
    return Obx(() {
      final image = controller.mediaController
          .getVariantImage('variant_$index')
          .split(',')
          .last;
      return Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Variant ${index + 1}',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black)),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                    child: buildTextField(
                  controller: controller.variantPriceControllers[index],
                  label: 'Price',
                  keyboardType: TextInputType.number,
                  iconColor: Colors.green,
                )),
                SizedBox(width: 12),
                Expanded(
                    child: buildTextField(
                  controller: controller.variantQuantityControllers[index],
                  label: 'Quantity',
                  keyboardType: TextInputType.number,
                  iconColor: Colors.orange,
                )),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [


                customDropdown(
                  labelText: 'Size',
                  value: controller.variantSizeControllers[index].text.isEmpty
                      ? null
                      : controller.variantSizeControllers[index].text,
                  items: sizeOptions,
                  onChanged: (value) {
                    controller.variantSizeControllers[index].text = value!;
                  },
                ),


                SizedBox(width: 12),

                customDropdown(
                  labelText: 'Color',
                  value: controller.variantColorControllers[index].text.isEmpty
                      ? null
                      : controller.variantColorControllers[index].text,
                  items: colorOptions,
                  onChanged: (value) {
                    controller.variantColorControllers[index].text = value!;
                  },
                ),

              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                    child: buildTextField(
                  controller: controller.variantMaterialControllers[index],
                  label: 'Material',
                  iconColor: Colors.brown,
                )),
                SizedBox(width: 12),

                customDropdown(
                  labelText: 'Gender',
                  value: controller.variantGenderControllers[index].text.isEmpty
                      ? null
                      : controller.variantGenderControllers[index].text,
                  items: GenderOptions,
                  onChanged: (value) {
                    controller.variantGenderControllers[index].text = value!;
                  },
                ),
              ],
            ),
            SizedBox(height: 12),
            buildTextField(
              controller: controller.variantDiscountControllers[index],
              label: 'Discount Price',
              keyboardType: TextInputType.number,
              iconColor: Colors.red,
            ),
            SizedBox(height: 12),
            GestureDetector(
              onTap: () => controller.updateVariantImage('variant_$index'),
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: controller.mediaController
                        .getVariantImage('variant_$index')
                        .isEmpty
                    ? Icon(Icons.add_photo_alternate,
                        size: 32, color: Colors.black54)
                    : Image.memory(base64Decode(image), fit: BoxFit.cover),
              ),
            ),
          ],
        ),
      );
    });
  }

  void _handleCreateProduct() {
    handleApiCallButton(
      controller.createProduct,
      successMessage: 'Product created successfully!',
      errorMessage: 'Failed to create product. Please try again & Check your text fields',
      onSuccess: () {
        Get.back();
        controller.onClose();
      },
      onError: (error) {},
    );
  }
}
