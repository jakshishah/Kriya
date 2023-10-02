import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:kriya/screens/dashboard/dashboard_screen2.dart';
import 'package:kriya/screens/splash_screen/splash_screen.dart';
import 'package:kriya/userPreferences/current_user.dart';
import 'package:kriya/userPreferences/user_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kriya',
      debugShowCheckedModeBanner: false,
      // home: FutureBuilder(
      //     future: RememberUserPrefs.readUserInfo(),
      //     builder: (context, dataSnapShot) {
      //       if (dataSnapShot.data == null) {
      //         return SplashScreen();
      //       } else {
      //         return DashboardScreen2();
      //       }
      //     }),
      home: SplashScreen(),
    );
  }
}
