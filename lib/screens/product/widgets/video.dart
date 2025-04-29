import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:karmalab_assignment/controllers/product_controller.dart';
import 'package:karmalab_assignment/screens/product/widgets/textField.dart';

class videoSection extends StatelessWidget {
  const videoSection({
    super.key,
    required this.controller,
  });

  final ProductController controller;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Video',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),

        const SizedBox(height: 16),

        buildTextField(
          controller: controller.videoController,
          label: 'Add Video URL',
          icon: FontAwesomeIcons.link,
        ),

        const SizedBox(height: 6),

        const Center(
            child: Text('OR',
                style: TextStyle(color: Colors.black))),
        const SizedBox(height: 6),

        Obx(() {
          final videoBase64 = controller.mediaController.videoBase64;
          final thumbnail = controller.mediaController.videoThumnail;
          return GestureDetector(
            onTap: () async {
              await controller.mediaController.videoPickerAndBase64Conversion();
            },
            onLongPress: () {
              controller.mediaController.removeVideo();
            },
            child: Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: Colors.black.withOpacity(0.5)),
                color: Colors.white,
              ),
              child: thumbnail.isNotEmpty
                  ? Obx(() {
                if (controller.mediaController
                    .videoThumnail.isNotEmpty) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        Image.memory(
                          base64Decode(controller
                              .mediaController
                              .videoThumnail),
                          fit: BoxFit.cover,
                        ),
                        const Center(
                            child: Icon(
                                FontAwesomeIcons.play,
                                color: Colors.white70,
                                size: 80)),
                      ],
                    ),
                  );
                } else {
                  return const Center(
                      child:
                      Text('No thumbnail available'));
                }
              })
                  : const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment:
                CrossAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.video,
                    color: Colors.blue,
                    size: 50,
                  ),
                  Text('Tap to upload video',
                      style: TextStyle(
                          color: Colors.black)),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 6),
      ],
    );
  }
}