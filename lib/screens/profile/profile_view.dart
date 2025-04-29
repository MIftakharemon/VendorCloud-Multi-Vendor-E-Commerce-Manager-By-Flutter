import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:karmalab_assignment/constants/size_constants.dart';
import 'package:karmalab_assignment/controllers/user_controller.dart';
import 'dart:math' as math;

import 'package:karmalab_assignment/screens/profile/profile_update_screen.dart';
import 'package:karmalab_assignment/screens/profile/settings_screens/setting_screen.dart';
import 'package:karmalab_assignment/screens/profile/settings_screens/verification_details_bottom_sheet.dart';
import 'package:karmalab_assignment/services/auth_service.dart';

import '../../controllers/image_controller.dart';
import '../../controllers/profile_update_controller.dart';
import '../authentication/login/login_view.dart';

class Profile extends StatelessWidget {
  Profile({Key? key}) : super(key: key);
  static const routeName = "/profile";
  final UserController userController = Get.find<UserController>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        final user = userController.user.value;
        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final avatarUrl = user.avatar;
        final status = userController.getProfileCompletionStatus();
        final completionPercentage = status['percentage'];
        final missingFields = status['missingFields'] as List<String>;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 35),
                if(missingFields.isNotEmpty) Text(
                  'Please Update ${missingFields.join(', ')} to complete your Profile',
                  style: TextStyle(fontSize: 9, color: Colors.grey),
                ).animate()
                    .fadeIn(duration: Duration(milliseconds: 600))
                    .slideY(begin: -0.2, end: 0),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: CustomPaint(
                            painter: ProfileCompletionPainter(completionPercentage),
                          ),
                        ).animate()
                            .scale(duration: Duration(milliseconds: 800)),
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(avatarUrl),
                        ).animate()
                            .fadeIn(duration: Duration(milliseconds: 600))
                            .scale(begin: Offset(0.8, 0.8))
                      ],
                    ),
                    const SizedBox(width: 20),
                    Column(
                      children: [
                        const Text(
                          'Your Profile Data',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ).animate()
                            .fadeIn(duration: Duration(milliseconds: 600))
                            .slideX(begin: 0.2, end: 0),
                        Text(
                          '${completionPercentage.toStringAsFixed(0)}% Completed',
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.red
                          ),
                        ).animate()
                            .fadeIn(
                            duration: Duration(milliseconds: 600),
                            delay: Duration(milliseconds: 200)
                        ),
                        Text(
                          user.name,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ).animate()
                            .fadeIn(
                            duration: Duration(milliseconds: 600),
                            delay: Duration(milliseconds: 400)
                        ),
                        Text(
                          user.email ?? '',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ).animate()
                            .fadeIn(
                            duration: Duration(milliseconds: 600),
                            delay: Duration(milliseconds: 600)
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: Get.height * 0.03),
                _buildImageCarousel().animate()
                    .fadeIn(
                    duration: Duration(milliseconds: 800),
                    delay: Duration(milliseconds: 400)
                )
                    .slideY(begin: 0.2, end: 0),
                SizedBox(height: Get.height * 0.05),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: _buildMenuList(),
                ).animate()
                    .fadeIn(
                    duration: Duration(milliseconds: 800),
                    delay: Duration(milliseconds: 600)
                )
                    .slideY(begin: 0.2, end: 0),
              ],
            ),
          ),
        );
      }),
    );
  }




  Widget _buildImageCarousel() {
    final List<String> imgList = [
      'https://static.vecteezy.com/system/resources/previews/002/006/774/non_2x/paper-art-shopping-online-on-smartphone-and-new-buy-sale-promotion-backgroud-for-banner-market-ecommerce-free-vector.jpg',
      'https://www.shutterstock.com/image-vector/ecommerce-web-banner-3d-smartphone-260nw-2069305328.jpg',
      'https://static.vecteezy.com/system/resources/thumbnails/002/006/605/small/paper-art-shopping-online-on-smartphone-and-new-buy-sale-promotion-pink-backgroud-for-banner-market-ecommerce-free-vector.jpg',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Center(
            child: Text(
              'Events Coming Soon',
              style: TextStyle(
                fontSize: 18,
                //fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ),
        CarouselSlider(
          options: CarouselOptions(
            height: 150.0,
            enlargeCenterPage: false,
            autoPlay: true,
            aspectRatio: 16 / 9,
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: true,
            autoPlayAnimationDuration: const Duration(milliseconds: 1500),
            viewportFraction: 1,
          ),
          items: imgList
              .map((item) => Container(
                    margin: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      image: DecorationImage(
                        image: NetworkImage(item),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildMenuList() {
    return Column(
      children: [
        const SizedBox(
          height: 25,
        ),


        _buildMenuItem(Icons.people, 'User Management',
            onTap: () => Get.to(() => const ProfileScreen())),
        const SizedBox(
          height: 25,
        ),


        _buildMenuItem(
          Icons.verified_user,
          'Verification Details',
          onTap: () {
            Get.bottomSheet(
              VerificationBottomSheet(
                mediaController: Get.find<MediaController>(),
                updateProfileController: Get.find<UpdateUserDataController>(),
              ),
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              enterBottomSheetDuration: const Duration(milliseconds: 300),
              exitBottomSheetDuration: const Duration(milliseconds: 300),
            );
          },
        ),



        const SizedBox(
          height: 25,
        ),



        _buildMenuItem(Icons.settings, 'Help & Support', onTap: () {Get.bottomSheet(SettingsBottomSheet(), isScrollControlled: true, backgroundColor: Colors.transparent, enterBottomSheetDuration: Duration(milliseconds: 250), exitBottomSheetDuration: Duration(milliseconds: 300),);
        }),
        const SizedBox(
          height: 25,
        ),




        _buildMenuItem(Icons.logout, 'Log out',
            onTap: () => _confirmLogout(Get.context!)),
        const SizedBox(
          height: 25,
        ),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {VoidCallback? onTap}) {
    return InkWell(
      splashColor: Colors.grey.shade50,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(width: 16),
            Expanded(child: Text(title)),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
              child: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
            ),
          ],
        ),
      ),
    ).animate()
        .fadeIn(
        duration: Duration(milliseconds: 600),
        delay: Duration(milliseconds: 200)
    )
        .slideX(begin: 0.2, end: 0);
  }
  void _confirmLogout(BuildContext context) {
    Get.defaultDialog(
      title: 'Logout',
      middleText: 'Are you sure you want to logout?',
      textCancel: 'Cancel',
      textConfirm: 'Logout',
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.find<AuthService>().logout();
        userController.clearUser();

        Get.offAllNamed(LoginView.routeName);
      },
    );
  }}

class ProfileCompletionPainter extends CustomPainter {
  final double completionPercentage;

  ProfileCompletionPainter(this.completionPercentage);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round;

    // Draw background circle
    paint.color = Colors.grey[300]!;
    canvas.drawCircle(center, radius, paint);

    // Draw completion arc
    paint.color = Colors.blue;
    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(
      rect,
      -math.pi / 2,
      2 * math.pi * (completionPercentage / 100),
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
