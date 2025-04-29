import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:karmalab_assignment/constants/size_constants.dart';
import 'package:karmalab_assignment/models/onboarding_model.dart';

Widget contentArea(OnboardingModel item, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: AppSizes.defaultPadding),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          item.title!,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ).animate()
            .fadeIn(duration: Duration(milliseconds: 600))
            .slideY(begin: 0.2, end: 0),

        const SizedBox(height: 12),

        Text(
          item.description!,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
          ),
        ).animate()
            .fadeIn(
            duration: Duration(milliseconds: 600),
            delay: Duration(milliseconds: 200)
        )
            .slideY(begin: 0.2, end: 0),
      ],
    ),
  );
}
