import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karmalab_assignment/models/onboarding_model.dart';

class OnboardingController extends GetxController {
  final _selectedIndex = 0.obs;
  late AnimationController _animationController;
  final PageController _pageController = PageController();

  final List<OnboardingModel> _onboardingList = [
    OnboardingModel(
      title: "Manage Your Store Effortlessly",
      description:
      "Take control of your business with our easy-to-use dashboard. Track orders, manage inventory, and analyze sales performance all in one place.",
      imageURL: "assets/images/png/onboarding-images/onboarding-3.png",
      bgColor: const Color(0xFFFFFFFF), // Pure white
    ),
    OnboardingModel(
      title: "Real-time Order Management",
      description:
      "Track deliveries, and manage customer communications seamlessly. Never miss a sale opportunity!",
      imageURL: "assets/images/png/onboarding-images/onboarding-1.png",
      bgColor: const Color(0xFFFFFFFF), // Pure white
    ),
    OnboardingModel(
      title: "Boost Your Sales with Analytics",
      description:
      "Make data-driven decisions with detailed insights into your best-selling products, peak hours, and customer preferences. Watch your business grow!",
      imageURL: "assets/images/png/onboarding-images/onboarding-2.png",
      bgColor: const Color(0xFFFFFFFF), // Pure white
    ),
  ];
  //getters
  List<OnboardingModel> get onboardingList => _onboardingList;
  int get selectedIndex => _selectedIndex.value;
  AnimationController get animationController => _animationController;
  PageController get pageController => _pageController;
  //setters
  set setAnimationController(AnimationController controller) =>
      _animationController = controller;

  void onPageChanged(int index) {
    _selectedIndex.value = index;
    if (index == onboardingList.length - 1) {
      if (_animationController.isCompleted) {

        _animationController.reset();
        _animationController.forward();
        _animationController.reverse();
      }
      _animationController.reset();
      _animationController.forward();
    }
  }

  void next() {
    _pageController.animateToPage(_selectedIndex.value + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutQuint);
  }
}
