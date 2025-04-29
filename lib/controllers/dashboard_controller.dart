import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// class DashboardController extends GetxController with GetSingleTickerProviderStateMixin {
//   final Rxn<AnimationController> _animationController = Rxn<AnimationController>();
//   AnimationController? get animationController => _animationController.value;
//
//   final Rxn<Animation<double>> _scaleAnimation = Rxn<Animation<double>>();
//   Animation<double>? get scaleAnimation => _scaleAnimation.value;
//
//   final Rxn<Animation<double>> _opacityAnimation = Rxn<Animation<double>>();
//   Animation<double>? get opacityAnimation => _opacityAnimation.value;
//
//   @override
//   void onInit() {
//     super.onInit();
//     const duration = Duration(milliseconds: 1500);
//     _animationController.value = AnimationController(
//       vsync: this,
//       duration: duration,
//     );
//
//     _scaleAnimation.value = Tween<double>(begin: 0.5, end: 1.0)
//         .chain(CurveTween(curve: Curves.easeOutBack))
//         .animate(_animationController.value!)
//       ..addListener(() {
//         update();
//       });
//
//     _opacityAnimation.value = Tween<double>(begin: 0.0, end: 1.0)
//         .chain(CurveTween(curve: Curves.easeIn))
//         .animate(_animationController.value!)
//       ..addListener(() {
//         update();
//       });
//
//     _animationController.value?.forward();
//   }
//
//   @override
//   void onClose() {
//     _animationController.value?.dispose();
//     super.onClose();
//   }
// }
class DashboardController extends GetxController with GetSingleTickerProviderStateMixin {

  final Rxn<AnimationController> _animationController = Rxn<AnimationController>();
  AnimationController? get animationController => _animationController.value;

  final Rxn<Animation<double>> _widthAnimation = Rxn<Animation<double>>();
  Animation<double>? get widthAnimation => _widthAnimation.value;

  final Rxn<Animation<Color?>> _colorAnimation = Rxn<Animation<Color?>>();
  Animation<Color?>? get colorAnimation => _colorAnimation.value;

  final Rxn<Animation<double>> _opacityAnimation = Rxn<Animation<double>>();
  Animation<double>? get opacityAnimation => _opacityAnimation.value;

  @override
  void onInit() {
    super.onInit();
    const duration = Duration(milliseconds: 1500);
    _animationController.value = AnimationController(
      vsync: this, duration: duration,
    );


    _widthAnimation.value = (Tween<double>(begin: 50, end: 400)
        .chain(CurveTween(curve: Curves.ease))
        .animate(_animationController.value!)
      ..addListener(() { log(_widthAnimation.value.toString()); update();
      }));


    _colorAnimation.value = (ColorTween(
        begin: Colors.white, end: Colors.lightGreenAccent)
        .chain(CurveTween(curve: Curves.ease))
        .animate(_animationController.value!)
      ..addListener(() { log(_colorAnimation.value.toString()); update();
      }));


    _opacityAnimation.value = (Tween<double>(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: Curves.ease))
        .animate(_animationController.value!)
      ..addListener(() { update();
      }));
    _animationController.value?.forward();
  }


  @override
  void onClose() {
    _animationController.value?.dispose();
    super.onClose();

  }
}