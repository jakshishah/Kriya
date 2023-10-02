import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kriya/screens/splash_screen/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/user_model.dart';
import '../../userPreferences/user_preferences.dart';
import '../dashboard/dashboard_screen1.dart';
import '../dashboard/dashboard_screen2.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  // final isObscure = ValueNotifier<bool>(true);
  var isObsecure = true.obs;

  loginUserNow() async {
    try {
      var response = await http.post(
          Uri.parse(
              "https://www.kriyaadvertisement.com/WebServices/WS.php?type=login"),
          // Uri.parse(
          //     "http://192.168.1.25:8056/kriya/WebServices/WS.php?type=login"),
          body: {
            "username": _usernameController.text.trim(),
            "password": _passwordController.text.trim(),
          });

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print("Response Data: $responseData");
        // final appUser = responseData['app_user'];
        // print("App User: $appUser");
        //  Map<String, dynamic> jsonObject = jsonDecode(responseData);
        //  //Map<String, dynamic> jsonObject = responseData as Map<String, dynamic>;
        //  print(jsonObject);
        //  String?  appUser = jsonObject['app_user'];
        // print("App User :$appUser");

        //Map<String, dynamic> data = responseData["DATA"];
        Map<String, dynamic> user = jsonDecode(response.body);
        String? appUser = user['DATA']['app_user'];
        String? session = user['DATA']['user_id'];
        print(session);
        print(appUser);

        RememberUserPrefs prefs = RememberUserPrefs();
        prefs.saveRememberUser(session!);
        prefs.saveRememberUser(appUser!);

        String? storedUserId = await prefs.readUserInfo();
        //int? storedUserId = await prefs.readUserInfo();
        print("Stored User ID: $storedUserId");


        if (appUser == "Admin") {

          // To store the value of user that is login or not
          var sharedPref = await SharedPreferences.getInstance();
          sharedPref.setBool(SplashScreenState.KeyLogin, true);

          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => DashboardScreen1()));
          Fluttertoast.showToast(msg: "Login Successfully");

        } else if (appUser == "User") {

          // To store the value of user that is login or not
          var sharedPref = await SharedPreferences.getInstance();
          sharedPref.setBool(SplashScreenState.KeyLogin, true);
          sharedPref.setString('app_user', appUser);
          // Navigator.pushReplacement(context,
          //     MaterialPageRoute(builder: (context) => DashboardScreen2()));
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => DashboardScreen2(storedUserId: storedUserId,)));

          Fluttertoast.showToast(msg: "Login Successfully");

        } else {
          Fluttertoast.showToast(msg: "Incorrect Username or Password");
        }
      } else {
        Fluttertoast.showToast(msg: 'HTTP Request Failed');
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: 'An error occurred: $e');
    }
  }

  // Future<void> loginUserNow() async {
  //   try {
  //     //final url = Uri.https("https://www.kriyaadvertisement.com/WebServices/WS.php?type=login");
  //     final response = await https.post(
  //      // Uri.parse("http://192.168.1.25:8056/kriya/WebServices/WS.php?type=login"),
  //       //Uri.parse("https://www.kriyaadvertisement.com/WebServices/WS.php?type=login"),
  //       Uri.parse("https://www.kriyaadvertisement.com/WebServices/WS.php?type=login"),
  //       //url,
  //       body: {
  //         "username": _usernameController.text.trim(),
  //         "password": _passwordController.text.trim(),
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final responseData = jsonDecode(response.body);
  //       //print(responseData);
  //
  //       //print("responseData['DATA']: ${responseData['DATA']}");
  //
  //       // Removed the if condition and proceeding directly
  //       // Fluttertoast.showToast(msg: "Login Successfully");
  //
  //       //print("UserName : "+_usernameController.text.toLowerCase());
  //      // print("Password : "+_passwordController.text);
  //       // Redirect to the appropriate dashboard screen
  //       // User userInfo =User.fromJson(responseData["UserData"]);
  //       //
  //       // await RememberUserPrefs.storeUserInfo(userInfo);
  //       // For local server
  //       // if (_usernameController.text.toLowerCase() == "admin" &&
  //       //     _passwordController.text == "admin123") {
  //         // Website live webservice
  //       if (_usernameController.text.toLowerCase() == "optimatrix" &&
  //             _passwordController.text == "optiinfo.com") {
  //           Navigator.pushReplacement(
  //             context,
  //             MaterialPageRoute(builder: (context) => DashboardScreen1()),
  //           );
  //           Fluttertoast.showToast(msg: "Login Successfully");
  //         } else {
  //           Navigator.pushReplacement(
  //             context,
  //             MaterialPageRoute(builder: (context) => DashboardScreen2()),
  //           );
  //           Fluttertoast.showToast(msg: "Login Successfully");
  //         }
  //       }
  //     else {
  //       Fluttertoast.showToast(msg: 'HTTP Request Failed');
  //     }
  //   } catch (e) {
  //     Fluttertoast.showToast(msg: 'An error occurred: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: LayoutBuilder(builder: (context, cons) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: cons.maxHeight,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 40),
                  Padding(
                    //padding: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Center(
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.fitWidth,
                        height: 300,
                        width: 300,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.all(Radius.circular(60)),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black12,
                            offset: Offset(0, -3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
                        child: Column(
                          children: [
                            Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _usernameController,
                                    validator: (val) => val!.isEmpty
                                        ? "Please enter User Name"
                                        : null,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.person,
                                        color: Colors.grey,
                                      ),
                                      hintText: "User Name...",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide:
                                            BorderSide(color: Colors.black12),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide:
                                            BorderSide(color: Colors.black12),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide:
                                            BorderSide(color: Colors.black12),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 6),
                                      fillColor: Colors.black12,
                                    ),
                                  ),
                                  SizedBox(height: 18),
                                  Obx(
                                    () => TextFormField(
                                      controller: _passwordController,
                                      obscureText: isObsecure.value,
                                      validator: (val) => val!.isEmpty
                                          ? "Please enter Password"
                                          : null,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.vpn_key_sharp,
                                          color: Colors.grey,
                                        ),
                                        suffixIcon: Obx(
                                          () => GestureDetector(
                                            onTap: () {
                                              isObsecure.value =
                                                  !isObsecure.value;
                                            },
                                            child: Icon(
                                              isObsecure.value
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        hintText: "Password",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          borderSide:
                                              BorderSide(color: Colors.black12),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          borderSide:
                                              BorderSide(color: Colors.black12),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          borderSide:
                                              BorderSide(color: Colors.black12),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 6),
                                        fillColor: Colors.black12,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Material(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(30),
                                    child: InkWell(
                                      onTap: () {
                                        if (formKey.currentState!.validate()) {
                                          loginUserNow();
                                        } else {
                                          print("Data is not entered");
                                        }
                                      },
                                      borderRadius: BorderRadius.circular(30),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 28,
                                        ),
                                        child: Text(
                                          'Login',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
//
// import '../../model/user_model.dart';
// import '../dashboard/dashboard_screen1.dart';
// import '../dashboard/dashboard_screen2.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);
//
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final formKey = GlobalKey<FormState>();
//   final _usernameController = TextEditingController();
//   final _passwordController = TextEditingController();
//   //final isObscure = ValueNotifier<bool>(true);
//   final isObscure = ValueNotifier<bool>(true);
//
//   Future<void> loginUserNow() async {
//     try {
//       final response = await http.post(
//         Uri.parse("http://192.168.1.25:8056/kriya/WebServices/WS.php?type=login"),
//         body: {
//           "username": _usernameController.text.trim(),
//           "password": _passwordController.text.trim(),
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         print(responseData);
//
//         print("responseData['DATA']: ${responseData['DATA']}");
//         if (responseData['DATA'] == true || responseData['DATA'] == "true") {
//           print("responseData['DATA']: ${responseData['DATA']}");
//           //Fluttertoast.showToast(msg: "Login Successfully");
//
//           //final userInfo = User.fromJson(responseData["UserData"]);
//
//           print("UserName : "+_usernameController.text.toLowerCase());
//           print("Password : "+_passwordController.text);
//           // Redirect to the appropriate dashboard screen
//           if (_usernameController.text.toLowerCase() == "admin" &&
//               _passwordController.text == "admin123") {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => DashboardScreen1()),
//             );
//           } else {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => DashboardScreen2()),
//             );
//           }
//         } else {
//           Fluttertoast.showToast(msg: 'Try Again');
//         }
//       } else {
//         Fluttertoast.showToast(msg: 'HTTP Request Failed');
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: 'An error occurred: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       body: Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         child: LayoutBuilder(builder: (context, cons) {
//           return ConstrainedBox(
//             constraints: BoxConstraints(
//               minHeight: cons.maxHeight,
//             ),
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   SizedBox(height: 40),
//                   SizedBox(
//                     width: MediaQuery.of(context).size.width,
//                     child: Image.asset(
//                       'assets/images/logo.png',
//                       fit: BoxFit.fitWidth,
//                       height: 300,
//                       width: 300,
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.all(16.0),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white12,
//                         borderRadius: BorderRadius.all(Radius.circular(60)),
//                         boxShadow: [
//                           BoxShadow(
//                             blurRadius: 8,
//                             color: Colors.black12,
//                             offset: Offset(0, -3),
//                           ),
//                         ],
//                       ),
//                       child: Padding(
//                         padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
//                         child: Column(
//                           children: [
//                             Form(
//                               key: formKey,
//                               child: Column(
//                                 children: [
//                                   TextFormField(
//                                     controller: _usernameController,
//                                     validator: (val) =>
//                                     val!.isEmpty ? "Please enter User Name" : null,
//                                     decoration: InputDecoration(
//                                       prefixIcon: Icon(
//                                         Icons.person,
//                                         color: Colors.grey,
//                                       ),
//                                       hintText: "User Name...",
//                                       hintStyle: TextStyle(color: Colors.grey),
//                                       border: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(30),
//                                         borderSide: BorderSide(color: Colors.black12),
//                                       ),
//                                       focusedBorder: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(30),
//                                         borderSide: BorderSide(color: Colors.black12),
//                                       ),
//                                       disabledBorder: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(30),
//                                         borderSide: BorderSide(color: Colors.black12),
//                                       ),
//                                       contentPadding:
//                                       EdgeInsets.symmetric(horizontal: 14, vertical: 6),
//                                       fillColor: Colors.black12,
//                                     ),
//                                   ),
//                                   SizedBox(height: 18),
//                                   ValueListenableBuilder<bool>(
//                                     valueListenable: isObscure,
//                                     builder: (context, obscure, child) {
//                                       return TextFormField(
//                                         controller: _passwordController,
//                                         obscureText: obscure,
//                                         validator: (val) =>
//                                         val!.isEmpty ? "Please enter Password" : null,
//                                         decoration: InputDecoration(
//                                           prefixIcon: Icon(
//                                             Icons.vpn_key_sharp,
//                                             color: Colors.grey,
//                                           ),
//                                           suffixIcon: GestureDetector(
//                                             onTap: () {
//                                               isObscure.value = !obscure;
//                                             },
//                                             child: Icon(
//                                               obscure
//                                                   ? Icons.visibility_off
//                                                   : Icons.visibility,
//                                               color: Colors.grey,
//                                             ),
//                                           ),
//                                           hintText: "Password",
//                                           hintStyle: TextStyle(color: Colors.grey),
//                                           border: OutlineInputBorder(
//                                             borderRadius: BorderRadius.circular(30),
//                                             borderSide: BorderSide(color: Colors.black12),
//                                           ),
//                                           enabledBorder: OutlineInputBorder(
//                                             borderRadius: BorderRadius.circular(30),
//                                             borderSide: BorderSide(color: Colors.black12),
//                                           ),
//                                           focusedBorder: OutlineInputBorder(
//                                             borderRadius: BorderRadius.circular(30),
//                                             borderSide: BorderSide(color: Colors.grey),
//                                           ),
//                                           disabledBorder: OutlineInputBorder(
//                                             borderRadius: BorderRadius.circular(30),
//                                             borderSide: BorderSide(color: Colors.black12),
//                                           ),
//                                           contentPadding:
//                                           EdgeInsets.symmetric(horizontal: 14, vertical: 6),
//                                           fillColor: Colors.black12,
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                   SizedBox(height: 20),
//                                   Material(
//                                     color: Colors.black12,
//                                     borderRadius: BorderRadius.circular(30),
//                                     child: InkWell(
//                                       onTap: () {
//                                         if (formKey.currentState!.validate()) {
//                                           loginUserNow();
//                                         } else {
//                                           print("Data is not entered");
//                                         }
//                                       },
//                                       borderRadius: BorderRadius.circular(30),
//                                       child: Padding(
//                                         padding: EdgeInsets.symmetric(
//                                           vertical: 10,
//                                           horizontal: 28,
//                                         ),
//                                         child: Text(
//                                           'Login',
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 20,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }

// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
//
// import '../../model/user_model.dart';
// import '../dashboard/dashboard_screen1.dart';
// import '../dashboard/dashboard_screen2.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   var formKey = GlobalKey<FormState>();
//   var _usernameController = TextEditingController();
//   var _passwordController = TextEditingController();
//   var isObsecure = true.obs;
//
//   // login function
//   loginUserNow() async {
//     try {
//       var res = await http.post(
//           Uri.parse(
//               //"http://192.168.1.25:8056/kriya/WebServices/WS.php?type=login&username=admin&password=admin123"),
//               "http://192.168.1.25:8056/kriya/WebServices/WS.php?type=login"),
//           body: {
//             "username": _usernameController.text.trim(),
//             "password": _passwordController.text.trim(),
//           });
//
//       if (res.statusCode == 200) {
//         var resBodyOfLogin = jsonDecode(res.body);
//         if (resBodyOfLogin['DATA'] == true) {
//           Fluttertoast.showToast(msg: "Login Successfully");
//
//           User userinfo = User.fromJson(resBodyOfLogin["UserData"]);
//
//           //Save the data of user
//           // await RememberUserPrefs.storeUserInfo(userInfo);
//
//           // Go to the dashboard for 2 user
//           //Get.to(()=>DashboardScreen1());
//           if(_usernameController.text.toLowerCase()  == "admin" && _passwordController.text == "admin123"){
//           // if ('username' == "Admin" ||
//           //     'username' == "admin" &&
//           //     'password' == "admin123" ||
//           //     'password' == "admin123") {
//             //print("Data is not store");
//             //Get.to(() => DashboardScreen1());
//             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>DashboardScreen1()));
//           } else {
//             // print("Data is store");
//             // Get.to(() => DashboardScreen2());
//             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>DashboardScreen2()));
//           }
//         } else {
//           print("Data is not transform");
//           Fluttertoast.showToast(msg: 'Try Again');
//         }
//       }else{
//         Fluttertoast.showToast(msg: 'HTTP Request Failed');
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: e.toString());
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       body: Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         // decoration: BoxDecoration(
//         //     gradient: LinearGradient(
//         //   colors: [
//         //     Color(0xffffffff),
//         //     Color(0xff000000),
//         //   ],
//         //   begin: Alignment.topCenter,
//         //   end: Alignment.bottomCenter,
//         // )),
//         child: LayoutBuilder(builder: (context, cons) {
//           return ConstrainedBox(
//             constraints: BoxConstraints(
//               minHeight: cons.maxHeight,
//             ),
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   SizedBox(
//                     height: 40,
//                   ),
//
//                   SizedBox(
//                     width: MediaQuery.of(context).size.width,
//                     // height: 10,
//                     child: Image.asset(
//                       'assets/images/logo.png',
//                       fit: BoxFit.fitWidth,
//                       height: 300,
//                       width: 300,
//                       //color: Color(0xFF000033),
//                     ),
//                   ),
//
//                   // login Screen signUp form
//                   Padding(
//                     padding: EdgeInsets.all(16.0),
//                     child: Container(
//                       decoration: BoxDecoration(
//                           color: Colors.white12,
//                           borderRadius: BorderRadius.all(Radius.circular(60)),
//                           boxShadow: [
//                             BoxShadow(
//                                 blurRadius: 8,
//                                 color: Colors.black12,
//                                 offset: Offset(0, -3)),
//                           ]),
//                       child: Padding(
//                         padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
//                         child: Column(
//                           children: [
//                             // UserName login button
//                             Form(
//                               key: formKey,
//                               child: Column(
//                                 children: [
//                                   TextFormField(
//                                     controller: _usernameController,
//                                     validator: (val) => val == "" ? "Please write User Name" : null,
//                                     decoration: InputDecoration(
//                                         prefixIcon: Icon(
//                                       Icons.person,
//                                       color: Colors.grey,
//                                     ),
//                                      hintText: " User Name...",
//                                       hintStyle:TextStyle(
//                                         color: Colors.grey),
//                                       border:OutlineInputBorder(
//                                         borderRadius:BorderRadius.circular(30),
//                                         borderSide:BorderSide(color: Colors.black12)
//                                       ),
//                                       focusedBorder: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(30),
//                                         borderSide: const BorderSide(
//                                           color: Colors.black12,
//                                         ),
//                                       ),
//                                       disabledBorder: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(30),
//                                         borderSide: const BorderSide(
//                                           color: Colors.black12,
//                                         ),
//                                       ),
//                                       contentPadding: const EdgeInsets.symmetric(horizontal: 14,vertical: 6),
//                                       fillColor: Colors.black12,
//                                     ),
//                                   ),
//
//                                   // Set space between two column
//                                   SizedBox(height: 18,),
//
//                                   // Password
//                                   Obx(() => TextFormField(
//                                     controller: _passwordController,
//                                     obscureText: isObsecure.value,
//                                     validator: (val) => val == "" ? "Please write Password" : null,
//                                     decoration: InputDecoration(
//                                       prefixIcon: const Icon(
//                                         Icons.vpn_key_sharp,
//                                         color: Colors.grey,
//                                       ),
//                                       suffixIcon: Obx(
//                                             () => GestureDetector(
//                                           onTap: (){
//                                             isObsecure.value = !isObsecure.value;
//                                           },
//                                           child: Icon(
//                                             isObsecure.value ? Icons.visibility_off : Icons.visibility,
//                                             color: Colors.grey,
//                                           ),
//                                         ),
//                                       ),
//                                       hintText: "Password",
//                                       hintStyle: TextStyle(
//                                         color: Colors.grey
//                                       ),
//                                       border: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(30),
//                                         borderSide: const BorderSide(
//                                           color: Colors.black12,
//                                         ),
//                                       ),
//                                       enabledBorder: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(30),
//                                         borderSide: const BorderSide(
//                                           color: Colors.black12,
//                                         ),
//                                       ),
//                                       focusedBorder: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(30),
//                                         borderSide: const BorderSide(
//                                           color: Colors.grey,
//                                         ),
//                                       ),
//                                       disabledBorder: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(30),
//                                         borderSide: const BorderSide(
//                                           color: Colors.black12,
//                                         ),
//                                       ),
//                                       contentPadding: const EdgeInsets.symmetric(horizontal: 14,vertical: 6),
//                                       fillColor: Colors.black12,
//                                     ),
//                                   )),
//
//                                   SizedBox(height: 20,),
//                                   Material(
//                                     color: Colors.black12,
//                                     borderRadius: BorderRadius.circular(30),
//                                     child: InkWell(
//                                       onTap: (){
//                                         if(formKey.currentState!.validate())
//                                         {
//                                           loginUserNow();
//                                         }
//                                         else{
//                                           print("data is  not enter");
//                                         }
//                                       },
//                                       borderRadius: BorderRadius.circular(30),
//                                       child: const Padding(
//                                         padding: EdgeInsets.symmetric(
//                                           vertical: 10,
//                                           horizontal: 28,
//                                         ),
//                                         child: Text(
//                                           'Login',
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 20,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }
