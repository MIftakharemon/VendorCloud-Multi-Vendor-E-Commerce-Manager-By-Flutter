import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:karmalab_assignment/controllers/product_controller.dart';
import 'package:karmalab_assignment/screens/product/widgets/textField.dart';

class packaging extends StatelessWidget {
  const packaging({
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
          'Packaging',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: buildTextField(
                controller: controller.weightController,
                label: 'Weight',
                icon: FontAwesomeIcons.weightHanging,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: buildTextField(
                controller: controller.heightController,
                label: 'Height',
                icon: FontAwesomeIcons.arrowsAltV,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: buildTextField(
                controller: controller.widthController,
                label: 'Width',
                icon: FontAwesomeIcons.arrowsAltH,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: buildTextField(
                controller: controller.dimensionController,
                label: 'Dimension',
                icon: FontAwesomeIcons.cube,
              ),
            ),
          ],
        ),
      ],
    );
  }
}