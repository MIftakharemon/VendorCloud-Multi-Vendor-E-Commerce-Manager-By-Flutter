import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:karmalab_assignment/constants/size_constants.dart';
import 'package:karmalab_assignment/controllers/onboarding_controller.dart';
import 'package:karmalab_assignment/widgets/custom_animated_button.dart';

import '../../../utils/constants/colors.dart';
import '../../authentication/login/login_view.dart';

class OnboardingAction extends StatelessWidget {
  const OnboardingAction({
    Key? key,
    required this.itemCount,
  }) : super(key: key);

  static final OnboardingController _onboardingController =
      Get.put(OnboardingController());
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    var selectedIndex = _onboardingController.selectedIndex;
    var color = _onboardingController.onboardingList[selectedIndex].bgColor;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.defaultPadding),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: List.generate(
                itemCount,
                (index) {
                  return AnimatedContainer(
                    duration: const Duration(
                        milliseconds: AppSizes.defaultAnimationDuration),
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    width: selectedIndex == index ? 20 : 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: index == selectedIndex
                          ? AppColors.deepOrange
                          : AppColors.grey,
                      borderRadius: BorderRadius.circular(7),
                    ),
                  )
                      .animate()
                      .fadeIn(
                          duration: Duration(milliseconds: 600),
                          delay: Duration(milliseconds: 100 * index))
                      .scale(begin: Offset(0.5, 0.5));
                },
              ),
            ),
          ),
          AnimatedButton(
            selectedIndex: selectedIndex,
            color: color,
            length: _onboardingController.onboardingList.length,
            onTap: () {
              if (_onboardingController.selectedIndex ==
                  _onboardingController.onboardingList.length - 1) {
                Navigator.pushNamed(context, LoginView.routeName);
              } else {
                _onboardingController.next();
              }
            },
          )
              .animate()
              .fadeIn(duration: Duration(milliseconds: 600))
              .slideX(begin: 0.2, end: 0),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: Duration(milliseconds: 800))
        .slideY(begin: 0.2, end: 0);
  }
}
