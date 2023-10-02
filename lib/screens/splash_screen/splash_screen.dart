import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kriya/screens/dashboard/dashboard_screen2.dart';
import 'package:kriya/userPreferences/user_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/user_model.dart';
import '../dashboard/dashboard_screen1.dart';
import '../login_screen/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {

  static const String KeyLogin = "login";
  String? storedUserId;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTime();
  }

  startTime() async {
    var duration = Duration(seconds: 3);
    return Timer(duration, loginRoute);
  }

  loginRoute() async{
    var sharedPref = await SharedPreferences.getInstance();
    var isLoggedIn = await sharedPref.getBool(KeyLogin);

    RememberUserPrefs pref = await RememberUserPrefs();
    String? userType = await pref.getUserType();
    print(userType);

    if(isLoggedIn!=null){
      if(isLoggedIn){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>DashboardScreen2(storedUserId:storedUserId )));
        // if(userType == "Admin"){
        //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>DashboardScreen1()));
        // }
        // else if(userType == "User"){
        //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>DashboardScreen2(storedUserId:storedUserId )));
        // }
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
      }
    }else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
    }
    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
  }

  // loginRoute(){
  //   return FutureBuilder(
  //       future: RememberUserPrefs.readUserInfo(),
  //       builder: (context,dataSnapshot){
  //         if(dataSnapshot.data == null){
  //           return LoginScreen();
  //         }
  //         else{
  //           return DashboardScreen2();
  //         }
  //       }
  //   );
  // }
  //
  // final _usernameController = TextEditingController();
  // final _passwordController = TextEditingController();
  // loginUserNow() async {
  //   try {
  //     var response = await http.post(
  //         Uri.parse(
  //             "https://www.kriyaadvertisement.com/WebServices/WS.php?type=login"),
  //         // Uri.parse(
  //         //     "http://192.168.1.25:8056/kriya/WebServices/WS.php?type=login"),
  //         body: {
  //           "username": _usernameController.text.trim(),
  //           "password": _passwordController.text.trim(),
  //         });
  //
  //     if (response.statusCode == 200) {
  //       final responseData = jsonDecode(response.body);
  //       print("Response Data: $responseData");
  //       // final appUser = responseData['app_user'];
  //       // print("App User: $appUser");
  //       //  Map<String, dynamic> jsonObject = jsonDecode(responseData);
  //       //  //Map<String, dynamic> jsonObject = responseData as Map<String, dynamic>;
  //       //  print(jsonObject);
  //       //  String?  appUser = jsonObject['app_user'];
  //       // print("App User :$appUser");
  //
  //       Map<String, dynamic> user = jsonDecode(response.body);
  //       String appUser = user['DATA']['app_user'];
  //       print(appUser);
  //
  //       if (appUser == "Admin") {
  //         Navigator.pushReplacement(context,
  //             MaterialPageRoute(builder: (context) => DashboardScreen1()));
  //         Fluttertoast.showToast(msg: "Login Successfully");
  //         User userInfo = User.fromJson(responseData["DATA"]);
  //
  //         // Save user info for local storage using shared Perfrences
  //         await RememberUserPrefs.storeUserInfo(userInfo);
  //       } else if (appUser == "User") {
  //         Navigator.pushReplacement(context,
  //             MaterialPageRoute(builder: (context) => DashboardScreen2()));
  //
  //         Fluttertoast.showToast(msg: "Login Successfully");
  //         User userInfo = User.fromJson(responseData["DATA"]);
  //
  //         // Save user info for local storage using shared Perfrences
  //         await RememberUserPrefs.storeUserInfo(userInfo);
  //       } else {
  //         Fluttertoast.showToast(msg: "Incorrect Username or Password");
  //       }
  //     } else {
  //       Fluttertoast.showToast(msg: 'HTTP Request Failed');
  //     }
  //   } catch (e) {
  //     print(e);
  //     Fluttertoast.showToast(msg: 'An error occurred: $e');
  //   }
  // }
  


  // final _usernameController = TextEditingController();
  // final _passwordController = TextEditingController();
  // loginRoute() async {
  //   final userInfo = await RememberUserPrefs.readUserInfo();
  //   var response = await http.post(
  //       Uri.parse(
  //           "https://www.kriyaadvertisement.com/WebServices/WS.php?type=login"),
  //       // Uri.parse(
  //       //     "http://192.168.1.25:8056/kriya/WebServices/WS.php?type=login"),
  //       body: {
  //         "username": _usernameController.text.trim(),
  //         "password": _passwordController.text.trim(),
  //       });
  //   Map<String, dynamic> user = jsonDecode(response.body);
  //   String appUser = user['DATA']['app_user'].toString();
  //   print(appUser);
  //   if (userInfo == null) {
  //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
  //   } else {
  //     // Depending on user data, navigate to DashboardScreen1 or DashboardScreen2
  //     if (appUser == "Admin") {
  //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardScreen1()));
  //     } else if (appUser == "User") {
  //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardScreen2()));
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return initWidget();
  }

  // Splash Screen
  Widget initWidget() {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 200,left: 20),
        child: Center(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                Image.asset(
                  "assets/images/logo.png",
                  fit: BoxFit.fill,
                  // height: 240,
                  // width: 300,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
