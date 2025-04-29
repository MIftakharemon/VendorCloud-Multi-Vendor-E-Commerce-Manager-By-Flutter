import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karmalab_assignment/screens/product/widgets/additioal_images.dart';
import 'package:karmalab_assignment/screens/product/widgets/coverphoto.dart';
import 'package:karmalab_assignment/screens/product/widgets/customDropDownButton.dart';
import 'package:karmalab_assignment/screens/product/widgets/dropDownButtonItems.dart';
import 'package:karmalab_assignment/screens/product/widgets/variant_image_update.dart';
import 'package:karmalab_assignment/utils/constants/colors.dart';
import '../../controllers/image_controller.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/product_update_controller.dart';
import '../../models/product_model.dart';

class ProductUpdateScreen extends GetView<ProductUpdateController> {
  static const routeName = "/productUpdateScreen";
  final Product product;

  ProductUpdateScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    controller.initializeProductData(product);
    final ProductController Controller = Get.find<ProductController>();
    //

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        cleanUpMediaController();
      },

      child: Scaffold(
        appBar: AppBar(
          title: Text('Update Product',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600
              )
          ),
          backgroundColor: Colors.white,
          elevation: 0.5,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cover Photo section
                  coverPhotoSection(controller: Controller),
                  const SizedBox(height: 8),
                  AdditionalImagesSection(controller: Controller),
                  const SizedBox(height: 8),

                  _buildSection(
                    title: 'Basic Information',
                    child: Column(
                      children: [
                        _buildTextField(
                          controller: controller.nameController,
                          label: 'Product Name',
                        ),
                        _buildTextField(
                          controller: controller.summaryController,
                          label: 'Summary',
                          maxLines: 2,
                        ),
                        _buildTextField(
                          controller: controller.descriptionController,
                          label: 'Description',
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                  _buildSection(
                    title: 'Product Details',
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: controller.brandController,
                                label: 'Brand',
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _buildTextField(
                                controller: controller.warrantyController,
                                label: 'Warranty',
                              ),
                            ),
                          ],
                        ),
                        _buildPackagingFields(),
                      ],
                    ),
                  ),


                  _buildSection(
                    title: 'Specifications',
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller:  controller.screenSizeController,
                                label: 'Screen Size',
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _buildTextField(
                                controller:  controller.batteryLifeController,
                                label: 'Battery Life',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller:  controller.cameraResolutionController,
                                label: 'Camera Resolution',
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _buildTextField(
                                controller:  controller.storageCapacityController,
                                label: 'Storage Capacity',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        _buildTextField(
                          controller:  controller.osController,
                          label: 'Operating System',
                        ),
                      ],
                    ),
                  ),







                  _buildSection(
                    title: 'Variants',
                    child: _buildVariantsSection(),
                  ),
                  SizedBox(height: 24),
                  _buildUpdateButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildPackagingFields() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: controller.weightController,
                label: 'Weight',
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildTextField(
                controller: controller.heightController,
                label: 'Height',
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: controller.widthController,
                label: 'Width',
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildTextField(
                controller: controller.dimensionController,
                label: 'Dimension',
              ),
            ),
          ],
        ),
      ],
    );
  }





  Widget _buildVariantCard(int index) {
    final ProductController Controller = Get.find<ProductController>();

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Variant ${index + 1}',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: controller.variantPriceControllers[index],
                    label: 'Price',
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    controller: controller.variantQuantityControllers[index],
                    label: 'Quantity',
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Obx(() => customDropdown(
                  labelText: 'Size',
                  value: controller.variantSizeValues[index].value.isEmpty
                      ? null
                      : controller.variantSizeValues[index].value,
                  items: sizeOptions,
                  onChanged: (value) {
                    if (value != null) {
                      controller.variantSizeValues[index].value = value;
                      controller.variantSizeControllers[index].text = value;
                    }
                  },
                )),
                SizedBox(width: 12),
                Obx(() => customDropdown(
                  labelText: 'Color',
                  value: controller.variantColorValues[index].value.isEmpty
                      ? null
                      : controller.variantColorValues[index].value,
                  items: colorOptions,
                  onChanged: (value) {
                    if (value != null) {
                      controller.variantColorValues[index].value = value;
                      controller.variantColorControllers[index].text = value;
                    }
                  },
                )),
              ],
            ),
            SizedBox(height: 12),
            _buildTextField(
              controller: controller.variantDiscountControllers[index],
              label: 'Discount',
            ),
            SizedBox(height: 12),
            VariantImageSection(
              controller: Controller,
              index: index,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12),
        child,
        SizedBox(height: 24),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.black54, fontSize: 14),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }


  Widget _buildVariantsSection() {
    return Obx(() => Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.remove_circle_outline),
              onPressed: () => controller.decrementVariantCount(),
            ),
            Text('${controller.variantCount.value} Variants'),
            IconButton(
              icon: Icon(Icons.add_circle_outline),
              onPressed: () => controller.incrementVariantCount(),
            ),
          ],
        ),
        ...List.generate(
          controller.variantCount.value,
              (index) => _buildVariantCard(index),
        ),
      ],
    ));
  }

  Widget _buildUpdateButton() {
    return Obx(() => Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 16),
      child: ElevatedButton(
        onPressed: controller.isLoading.value
            ? null
            : () => controller.updateProduct(product.id!,(success, {errorMessage}) {
            if (success) {
              Get.back();
              Get.snackbar('Success', 'Product updated successfully');
            } else {
              Get.snackbar('Error', errorMessage ?? 'Failed to update product');
            }
          },
        ),

        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkOrange,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
        child: controller.isLoading.value
            ? SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : Text(
          'Update Product',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ));
  }

  void cleanUpMediaController() {
    // Call all the cleanup functions
    Get.find<MediaController>().removeVideo();
    Get.find<MediaController>().removeThumbnail();
    Get.find<MediaController>().clearAdditionalImageBase64();
    Get.find<MediaController>().clearAllVariantImages();
    Get.find<MediaController>().removeCoverPhoto();
    //Get.delete<MediaController>();
  }


}
