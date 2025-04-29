// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:karmalab_assignment/constants/color_constants.dart';
// import 'package:remixicon/remixicon.dart';
// import 'package:get/get.dart';
// import 'package:karmalab_assignment/services/auth_service.dart';
//
// class SocialMediaAuthArea extends StatelessWidget {
//   SocialMediaAuthArea({
//     Key? key,
//   }) : super(key: key);
//
//   final List<Map<String, dynamic>> _media = [
//     {
//       "bg": Colors.blue,
//       "icon": Remix.google_fill,
//       "onTap": () async {
//         final AuthService authService = AuthService();
//
//         try {
//           final user = await authService.signInWithGoogle();
//
//           if (user != null) {
//             // Navigate to home screen or perform any other action
//             Get.offAllNamed('/mainScreen');
//           } else {
//             Get.snackbar('Error', 'Google Sign In failed');
//           }
//         } catch (e) {
//           Get.snackbar('Error', 'An error occurred during Google Sign In $e');
//         }
//       },
//     },
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 18.0),
//       child: Column(
//         children: [
//           Stack(
//             children: [
//               const Divider(),
//               Align(
//                 alignment: Alignment.topCenter,
//                 child: Text(
//                   "   Or Sign In with    ",
//                   style: GoogleFonts.openSans(
//                     backgroundColor: AppColors.white,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w400,
//                     color: AppColors.smallText,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 28),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: List.generate(
//               _media.length,
//                   (index) => GestureDetector(
//                 onTap: _media[index]["onTap"],
//                 child: CircleAvatar(
//                   backgroundColor: _media[index]["bg"],
//                   radius: 25,
//                   child: Icon(
//                     _media[index]["icon"] as IconData,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
