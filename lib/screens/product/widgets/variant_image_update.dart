import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../controllers/product_controller.dart';

class VariantImageSection extends StatelessWidget {
  final ProductController controller;
  final int index;
  final String? existingImageUrl;

  const VariantImageSection({
    Key? key,
    required this.controller,
    required this.index,
    this.existingImageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Variant Image',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              GestureDetector(
                onTap: () async {
                  await controller.mediaController.imagePickerAndBase64Conversion(
                    variantId: 'variant_$index',
                  );
                },
                onDoubleTap: () {
                  controller.mediaController.setVariantImage('variant_$index', '');
                  controller.mediaController.setVariantImageUrl('variant_$index', '');
                },
                child: Obx(() {
                  final imageKey = 'variant_$index';
                  final variantImage = controller.mediaController.getVariantImage(imageKey);
                  final variantUrl = controller.mediaController.getVariantImageUrl(imageKey);

                  return Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                      image: variantImage.isNotEmpty
                          ? DecorationImage(
                        image: MemoryImage(
                          base64Decode(variantImage.split(',').last),
                        ),
                        fit: BoxFit.cover,
                      )
                          : variantUrl.isNotEmpty
                          ? DecorationImage(
                        image: NetworkImage(variantUrl),
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                    child: variantImage.isEmpty && variantUrl.isEmpty
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          FontAwesomeIcons.image,
                          color: Colors.grey,
                          size: 24,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Add Image',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    )
                        : null,
                  );
                }),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: const Icon(
                  FontAwesomeIcons.camera,
                  color: Colors.blue,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
