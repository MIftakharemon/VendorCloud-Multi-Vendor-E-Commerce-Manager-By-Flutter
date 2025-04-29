import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:karmalab_assignment/constants/size_constants.dart';
import 'package:karmalab_assignment/controllers/onboarding_controller.dart';
import 'package:karmalab_assignment/screens/onboarding/widgets/content_area.dart';
import 'package:karmalab_assignment/screens/onboarding/widgets/onboarding_action.dart';
import 'package:karmalab_assignment/screens/onboarding/widgets/onboarding_banner.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({Key? key}) : super(key: key);
  static const routeName = "/onboarding";
  static final OnboardingController _onboardingController =
      Get.put(OnboardingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        var bgColor = _onboardingController
            .onboardingList[_onboardingController.selectedIndex].bgColor;
        var itemCount = _onboardingController.onboardingList.length;

        return AnimatedContainer(
          duration:
              const Duration(milliseconds: AppSizes.defaultAnimationDuration),
          color: bgColor!.withOpacity(.4),
          height: double.infinity,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              children: [
                Expanded(
                  flex: 4,
                  child: PageView.builder(
                    physics: const BouncingScrollPhysics(),
                    controller: _onboardingController.pageController,
                    itemBuilder: (context, index) {
                      var item = _onboardingController.onboardingList[index];
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          OnboardingBanner(
                            bgColor: bgColor,
                            index: index,
                          )
                              .animate()
                              .fadeIn(duration: Duration(milliseconds: 800))
                              .scale(begin: Offset(0.8, 0.8)),
                          const SizedBox(height: 80),
                          contentArea(item, context)
                              .animate()
                              .fadeIn(
                                  duration: Duration(milliseconds: 800),
                                  delay: Duration(milliseconds: 200))
                              .slideY(begin: 0.2, end: 0),
                        ],
                      );
                    },
                    onPageChanged: _onboardingController.onPageChanged,
                    itemCount: itemCount,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: OnboardingAction(itemCount: itemCount)
                      .animate()
                      .fadeIn(
                          duration: Duration(milliseconds: 800),
                          delay: Duration(milliseconds: 400))
                      .slideY(begin: 0.2, end: 0),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(duration: Duration(milliseconds: 1000));
      }),
    );
  }
}
