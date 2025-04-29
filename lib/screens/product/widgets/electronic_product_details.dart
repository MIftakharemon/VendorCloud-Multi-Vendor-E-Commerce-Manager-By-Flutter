import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:karmalab_assignment/controllers/product_controller.dart';
import 'package:karmalab_assignment/screens/product/widgets/textField.dart';

class SpecificationsScreen extends StatelessWidget {
  const SpecificationsScreen({
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
          'Specifications',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: buildTextField(
                controller: controller.screenSizeController,
                label: 'Display Size',
                icon: FontAwesomeIcons.tv,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: buildTextField(
                controller: controller.batteryLifeController,
                label: 'Battery Capacity',
                icon: FontAwesomeIcons.batteryFull,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: buildTextField(
                controller: controller.cameraResolutionController,
                label: 'Camera Resolution',
                icon: FontAwesomeIcons.cameraRetro,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: buildTextField(
                controller: controller.storageCapacityController,
                label: 'Storage',
                icon: FontAwesomeIcons.hdd,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        buildTextField(
          controller: controller.osController,
          label: 'Operating System',
          icon: FontAwesomeIcons.microchip,
        ),
      ],
    );
  }
}
