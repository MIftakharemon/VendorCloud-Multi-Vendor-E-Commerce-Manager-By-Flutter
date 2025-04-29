import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karmalab_assignment/screens/splash/splash_view.dart';
import 'package:karmalab_assignment/theme/theme.dart';
import 'package:karmalab_assignment/utils/route_util.dart';
import 'initialization_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await InitializationScreen.init();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'AnyhowVendor',
      initialRoute: SplashView.routeName,
      getPages: RouteUtil.routes,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme(),
    );
  }
}
