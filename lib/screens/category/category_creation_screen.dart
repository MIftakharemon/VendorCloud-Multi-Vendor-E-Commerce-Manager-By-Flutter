import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../controllers/category_controller.dart';

class CategoryCreationScreen extends GetView<CategoryController> {
  static const routeName = "/categoryCreateScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Category', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Obx(() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Category Image Upload Section
                  Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await controller.imageController.imagePickerAndBase64Conversion();
                          },
                          onDoubleTap: () {
                            controller.imageController.removeCoverPhoto();
                          },
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(color: Colors.deepPurple, width: 2),
                              image: controller.imageController.imageBase64.isNotEmpty
                                  ? DecorationImage(
                                image: MemoryImage(base64Decode(
                                    controller.imageController.imageBase64.split(',').last)),
                                fit: BoxFit.cover,
                              )
                                  : null,
                            ),
                            child: controller.imageController.imageBase64.isEmpty
                                ? const Icon(FontAwesomeIcons.image, color: Colors.deepPurple, size: 40)
                                : null,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(FontAwesomeIcons.camera, color: Colors.white, size: 20),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Category Image',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                  ),
                  const SizedBox(height: 32),

                  // Category Details Input Section
                  const Text(
                    'Category Details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                  ),
                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: controller.nameController,
                    label: 'Category Name',
                    icon: FontAwesomeIcons.tag,
                  ),
                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: controller.shippingChargeController,
                    label: 'Shipping Charge',
                    icon: FontAwesomeIcons.shippingFast,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: controller.vatController,
                    label: 'VAT (%)',
                    icon: FontAwesomeIcons.percentage,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: controller.commissionController,
                    label: 'Commission (%)',
                    icon: FontAwesomeIcons.moneyBill,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: controller.statusController,
                    label: 'Status',
                    icon: FontAwesomeIcons.toggleOn,
                  ),
                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: controller.iconController,
                    label: 'Icon',
                    icon: FontAwesomeIcons.icons,
                  ),
                  const SizedBox(height: 32),

                  // Create Category Button
                  ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () async {
                      await controller.createCategory((category, {errorMessage}) {
                        if (category != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Category created successfully!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: $errorMessage'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: controller.isLoading.value
                          ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                          strokeWidth: 2.0,
                        ),
                      )
                          : const Text(
                        'Create Category',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.deepPurple,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: const BorderSide(color: Colors.deepPurple),
                      ),
                      elevation: 0,
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.deepPurple.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.deepPurple, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      ),
    );
  }
}
