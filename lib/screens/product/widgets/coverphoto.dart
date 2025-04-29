import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../controllers/product_controller.dart';

class coverPhotoSection  extends StatelessWidget {
  const coverPhotoSection ({
    super.key,
    required this.controller,
  });

  final ProductController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              GestureDetector(
                onTap: () async {
                  await controller.mediaController.imagePickerAndBase64Conversion();
                },
                onDoubleTap: () {
                  controller.mediaController.removeCoverPhoto();
                },
                child: Obx(() {
                  String imageBase64 = controller.mediaController.imageBase64;
                  String imageUrl = controller.mediaController.imageUrl;

                  return Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 2),
                      image: imageBase64.isNotEmpty ? DecorationImage(image: MemoryImage(base64Decode(imageBase64.split(',').last)), fit: BoxFit.cover,) : imageUrl.isNotEmpty ? DecorationImage(
                        image: Image.network(imageUrl).image,
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                    child: imageBase64.isEmpty && imageUrl.isEmpty
                        ? const Icon(
                      FontAwesomeIcons.image,
                      color: Colors.lightBlue,
                      size: 40,
                    )
                        : null,
                  );
                }),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.black12,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  FontAwesomeIcons.camera,
                  color: Colors.blue,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Cover Photo',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
      ]
    );
  }
}