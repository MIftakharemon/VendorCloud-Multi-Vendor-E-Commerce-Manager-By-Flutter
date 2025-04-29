import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karmalab_assignment/screens/mainScreen/mainscreen.dart';
import 'package:karmalab_assignment/screens/onboarding/onboarding_view.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../initialization_screen.dart';
import '../../utils/constants/colors.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  static const String routeName = "/splash";

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to ensure the widget is mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleNavigation();
    });
  }

  void _handleNavigation() {
    final bool isLoggedIn = InitializationScreen.isLoggedIn;
    // Use Future.microtask to avoid navigator lock issues
    Future.microtask(() {
      Get.offAllNamed(
        isLoggedIn ? MainScreen.routeName : OnboardingView.routeName,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body:
      Center(
        child: LoadingAnimationWidget.staggeredDotsWave(
          color: AppColors.primary,
          size: 60,
        ),
      ),
    );
  }
}