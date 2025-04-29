import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../controllers/product_controller.dart';

class AdditionalImagesSection extends StatelessWidget {
  const AdditionalImagesSection({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final ProductController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Additional Images',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        Obx(() {
          final int maxImages = 3;
          final int totalUrlImages = controller.mediaController.additionalImagesUrls.length;
          final int totalBase64Images = controller.mediaController.additionalImagesBase64.length;
          final int totalImages = totalUrlImages + totalBase64Images;

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(maxImages, (index) {
              if (index < totalUrlImages) {
                return _buildUrlImageContainer(index);
              } else if (index < totalImages) {
                return _buildBase64ImageContainer(index - totalUrlImages);
              } else {
                return _buildAddImageContainer();
              }
            }),
          );
        }),
      ],
    );
  }

  Widget _buildUrlImageContainer(int index) {
    final String imageUrl = controller.mediaController.additionalImagesUrls[index];
    return GestureDetector(
      onLongPress: () {
          controller.mediaController.removeUrlImage(index);
      },
      onTap: () => _handleImageTap(),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.blue.shade200, width: 2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.error);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBase64ImageContainer(int index) {
    final String imageBase64 = controller.mediaController.additionalImagesBase64[index];
    return GestureDetector(
      onLongPress: (()=>controller.mediaController.removeImage(index)),
      onTap: () => _handleImageTap(),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.green.shade200, width: 2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.memory(
            base64Decode(imageBase64.split(',').last),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.error);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAddImageContainer() {
    return GestureDetector(
      onTap: () => _handleImageTap(),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: const Icon(FontAwesomeIcons.plus, color: Colors.blueGrey, size: 30),
      ),
    );
  }

  void _handleImageTap() async {
    final int totalImages = controller.mediaController.additionalImagesUrls.length +
        controller.mediaController.additionalImagesBase64.length;
    if (totalImages < 3) {
      await controller.mediaController.pickAdditionalImages();
    } else {
      Get.snackbar(
        'Maximum Images Reached',
        'Please press and hold to remove an image before adding a new one.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.transparent,
        colorText: Colors.black,
      );
    }
  }
}