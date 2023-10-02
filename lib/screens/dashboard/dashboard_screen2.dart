import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kriya/screens/dashboard/view_image_screen.dart';
import 'package:kriya/userPreferences/current_user.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant/permission_screen.dart';
import '../../userPreferences/user_preferences.dart';
import '../login_screen/login_screen.dart';

class DashboardScreen2 extends StatefulWidget {

  final String? storedUserId;
  const DashboardScreen2({required this.storedUserId,super.key});

  @override
  State<DashboardScreen2> createState() => _DashboardScreen2State();
}

class _DashboardScreen2State extends State<DashboardScreen2> {
  // To store the current User in local
  //final CurrentUser _rememberCurrentUser = Get.put(CurrentUser());

  @override
  void initState() {
    super.initState();
    // requestLocationPermission();
    // PermissionScreen();
    // permission().then((value) {
    //   latitude = '${value.latitude}' ;
    //   longitude = '${value.longitude}';
    // });
    permission();
  }

  Future<void> permission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location Service are disable');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location Permissions are Denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location Permissions are permanently Denied");
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      latitude = '${position.latitude}' ;
      longitude = '${position.longitude}';
    });

   // return await Geolocator.getCurrentPosition();
  }



  // Function To capture image
  late File _imagePath;
  late String longitude;
  late String latitude;
  String? user_id;
  final ImagePicker _picker = ImagePicker();
  //File?  _imagePath = File(XFile!.path) ;
  // Future choice() async {
  //   XFile? pickedImage = await _picker.pickImage(source: ImageSource.camera);
  //   setState(() {
  //     if(pickedImage!= null){
  //       _imagePath = File(pickedImage.path);
  //       uploadPhoto(user_id,latitude,longitude,datetime);
  //     }else{
  //       Fluttertoast.showToast(msg: "No image Clicked");
  //     }
  //   });
  //   //uploadPhoto(longitude,latitude,_imagePath,datetime);
  //  // uploadPhoto(user_id,latitude,longitude,datetime);
  // }

  //https://www.kriyaadvertisement.com/WebServices/WS.php?type=app_upload_photo&user_id=9&latitude=23.238053181873546&longitude=69.68091833708029

  var datetime = DateTime.now();
  Future uploadPhoto(String? storedId, String latitude, String longitude, DateTime datetime) async {

    RememberUserPrefs prefs = RememberUserPrefs();
    final user_id = await prefs.readUserInfo();
    //print("User Id: $storedUserId");
    // String? id = prefs.getString("id");
    try{
      final uri = Uri.parse(
          //"http://192.168.1.25:8056/kriya/WebServices/WS.php?type=app_upload_photo"
          "https://www.kriyaadvertisement.com/WebServices/WS.php?type=app_upload_photo"
          );
      var request = http.MultipartRequest('POST', uri);
      //request.fields['user_id'] = user_id.toString();
      request.fields['user_id'] = storedId.toString();
      request.fields['latitude'] = latitude;
      request.fields['longitude'] = longitude;
      request.fields['date_time'] = datetime.toIso8601String();
      var pic = await http.MultipartFile.fromPath("photo", _imagePath.path);
      // print(pic);
      request.files.add(pic);
      var response = await request.send();
      var responseString = await response.stream.bytesToString();
      Map<String,dynamic> parsedResponse = json.decode(responseString);
      String? result = parsedResponse['DATA']['result'];
      String? msg = parsedResponse['DATA']['msg'];
      // String? session = parsedResponse['DATA']['user_id'];
      // print(session);
      print(result);
      print(responseString);
      print(latitude);
      print(longitude);
      print(datetime);
      //print(responseString);

      if (response.statusCode == 200) {



        if(result == "success" || result == "Success"){
        Fluttertoast.showToast(
            msg:
                "Image Upload to the data base $longitude $longitude $datetime");
        print("Image upload");}
        else{
          Fluttertoast.showToast(
            msg:
            "Image Not Upload to Database");
        print("Image Not upload $user_id");}
        // print("Longitude $longitude");
        // print("Latitude $latitude");
        // print("Date Time $datetime");
      } else {
        Fluttertoast.showToast(msg: 'HTTP Request Failed');
        print("HTTP Request Failed");
      }
    }catch(e){
      print(e);
      Fluttertoast.showToast(msg: 'An error occurred: $e');
    }
  }


  Future choice() async {
    XFile? pickedImage = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      if(pickedImage!= null){
        _imagePath = File(pickedImage.path);
        uploadPhoto(user_id,latitude,longitude,datetime);
      }else{
        Fluttertoast.showToast(msg: "No image Clicked");
      }
    });
    //uploadPhoto(longitude,latitude,_imagePath,datetime);
    // uploadPhoto(user_id,latitude,longitude,datetime);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Upload Photo'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            child: Center(
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.all(70)),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                    ),
                    onPressed: () {
                      choice();
                      //uploadPhoto();
                      // permission();
                    },
                    icon: Icon(
                      Icons.upload,
                      size: 24.0,
                    ),
                    label: Text('Upload'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                    ),
                    onPressed: () {
                      RememberUserPrefs pref = RememberUserPrefs();
                      pref.clearAll();
                      // To see all the images of user
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ViewImageScreen()));
                    },
                    icon: Icon(
                      Icons.post_add,
                      size: 24.0,
                    ),
                    label: Text('All Post'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                    ),
                    onPressed: () {
                      // Handle "LogOut" button press
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    icon: Icon(
                      Icons.logout_outlined,
                      size: 24.0,
                    ),
                    label: Text('LogOut'),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

// Future<void> requestLocationPermission() async {
//   // final status = await Permission.location.status;
//   //
//   // if (status.isGranted) {
//   //   final grantedStatus = await Permission.location.request();
//   //
//   //   if (grantedStatus.isGranted) {
//   //     final pickedFile = await picker.pickImage(source: ImageSource.camera);
//   //
//   //     if (pickedFile != null) {
//   //       //final photo = pickedFile.path;
//   //       final photo = pickedFile.path;
//   //       final url = Uri.parse("http://192.168.1.25:8056/kriya/WebServices/WS.php?type=app_upload_photo");
//   //       final response = await http.post(
//   //         url,
//   //         body: {
//   //           "photo": photo,
//   //         },
//   //       );
//   //
//   //       if (response.statusCode == 200) {
//   //         setState(() {
//   //           photoURL = response.body;
//   //         });
//   //       } else {
//   //         ScaffoldMessenger.of(context).showSnackBar(
//   //           SnackBar(content: Text("Failed to upload the photo")),
//   //         );
//   //       }
//   //     }
//   //   } else {
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(content: Text("Location permission is required to take a photo.")),
//   //     );
//   //   }
//   //  }
//   // else if (status.isDenied) {
//   //   ScaffoldMessenger.of(context).showSnackBar(
//   //     SnackBar(content: Text("Location permission is required to take a photo.")),
//   //   );
//   // } else if (status.isPermanentlyDenied) {
//   //   ScaffoldMessenger.of(context).showSnackBar(
//   //     SnackBar(
//   //       content: Text('Please enable location permission in settings to take a photo.'),
//   //       action: SnackBarAction(
//   //         label: 'Open Settings',
//   //         onPressed: () {
//   //           openAppSettings();
//   //         },
//   //       ),
//   //     ),
//   //   );
//   // }
// }

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// import '../login_screen/login_screen.dart';
//
// class DashboardScreen2 extends StatefulWidget {
//   const DashboardScreen2({super.key});
//
//   @override
//   State<DashboardScreen2> createState() => _DashboardScreen2State();
// }
//
// class _DashboardScreen2State extends State<DashboardScreen2> {
//
//   //final picker = ImagePicker();
//
//   // location permission
//   late PermissionStatus  _status;
//   @override
//   void initState() {
//     super.initState();
//     //WidgetsBinding.instance.addObserver(this);
//     // Permission().
//   }
//
//   // for camera Permission
//   _getFromCamera() async{
//     try{
//       XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
//       //final status = await Permission.location.status;
//       var status = await Permission.camera.request();
//       var status1 = await Permission.location.request();
//       if(status.isGranted){
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Permission Alloewd")));
//       }
//     }catch (e){
//       var status = await Permission.camera.status;
//       if(status.isDenied){
//         print("Access Denied");
//         showAlertDialog();
//       }else{
//         print("Exception occurred!");
//       }
//     }
//   }
//
//   showAlertDialog() => showCupertinoDialog(
//       context: context,
//       builder: (BuildContext context) => CupertinoAlertDialog(
//         title: Text("Permission Denied"),
//         content: Text("Allow access to camera permission"),
//         actions: <CupertinoDialogAction>[
//           CupertinoDialogAction(child: Text("Cancel")),
//           CupertinoDialogAction(
//             isDefaultAction: true,
//               onPressed: ()=> openAppSettings(),
//               child: Text("Setting")
//           ),
//         ],
//       )
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         title: Text("Photo Upload"),
//         centerTitle: true,
//       ),
//       body: Padding(padding: EdgeInsets.all(30),child: Column(
//         children: [
//         ElevatedButton.icon(
//                   style: ElevatedButton.styleFrom(
//                     primary: Colors.black, // Background color
//                   ),
//                   onPressed: () {
//                     _getFromCamera();
//                     // requestLocationPermission();
//                   },
//                   icon: Icon( // <-- Icon
//                     Icons.upload,
//                     size: 24.0,
//                   ),
//                   label: Text('Upload'), // <-- Text
//                 ),
//                 SizedBox(height: 20,),
//                 ElevatedButton.icon(
//                   style: ElevatedButton.styleFrom(
//                     primary: Colors.black, // Background color
//                   ),
//                   onPressed: () {
//                   },
//                   icon: Icon( // <-- Icon
//                     Icons.post_add,
//                     size: 24.0,
//                   ),
//                   label: Text('All Post'), // <-- Text
//                 ),
//                 SizedBox(height: 20,),
//                 ElevatedButton.icon(
//                   style: ElevatedButton.styleFrom(
//                     primary: Colors.black, // Background color
//                   ),
//                   onPressed: () {
//                     LoginScreen();
//                   },
//                   icon: Icon( // <-- Icon
//                     Icons.logout_outlined,
//                     size: 24.0,
//                   ),
//                   label: Text('LogOut'), // <-- Text
//                 ),
//         ],
//       ),),
//     );
//   }
// }
//
//
//
// // import 'package:flutter/material.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:kriya/screens/login_screen/login_screen.dart';
// // import 'package:permission_handler/permission_handler.dart';
// // import 'package:http/http.dart' as http;
// //
// // class DashboardScreen2 extends StatefulWidget {
// //   const DashboardScreen2({super.key});
// //
// //   @override
// //   State<DashboardScreen2> createState() => _DashboardScreen2State();
// // }
// //
// // class _DashboardScreen2State extends State<DashboardScreen2> {
// //
// //   final picker = ImagePicker();
// //   String photoURL = '';
// //
// //
// //   // @override
// //   // void initState() {
// //   //   // TODO: implement initState
// //   //   super.initState();
// //   //   requestLocationPermission();
// //   // }
// //
// //   // Location Permission
// //   Future<void> requestLocationPermission() async {
// //     //final status = await Permission.location.request();
// //     final status = await Permission.location.status;
// //
// //     if(status.isGranted){
// //       // Upload the Photo
// //       final pickedFile = await picker.pickImage(source: ImageSource.camera);
// //
// //       if(pickedFile != null){
// //         // A photo is Picked
// //         final photo = pickedFile.path;
// //
// //         // Upload the photo to the webservice or database
// //         final response = await http.post(
// //           Uri.parse("http://192.168.1.25:8056/kriya/WebServices/WS.php?type=app_upload_photo"),
// //           body: {
// //             "photo": photo,
// //           },
// //         );
// //
// //         if(response.statusCode == 200){
// //           setState(() {
// //             photoURL = response.body;
// //           });
// //         }else{
// //           // Http Error
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             SnackBar(content: Text("Faild to upload the photo"))
// //           );
// //         }
// //       }
// //     }else if(status.isDenied){
// //       // Location id denied by user
// //       ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text("Location permission is required to take a photo."))
// //       );
// //     }else if(status.isPermanentlyDenied){
// //       // Location permission is permanently denied
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text('Please enable location permission in settings to take a photo.'),
// //           action: SnackBarAction(
// //             label: 'Open Settings',
// //             onPressed: () {
// //               openAppSettings(); // Open app settings
// //             },
// //           ),
// //         ),
// //       );
// //       // openAppSettings();
// //     }
// //   }
// //
// //
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return  Scaffold(
// //       appBar: AppBar(
// //         backgroundColor: Colors.transparent,
// //         title: Text('Upload Photo'),
// //         centerTitle: true,
// //       ),
// //       body: Column(
// //       children: [
// //         Container(
// //           child: Center(
// //             child: Column(
// //               children: [
// //                 Padding(padding: EdgeInsets.all(70)),
// //                 ElevatedButton.icon(
// //                   style: ElevatedButton.styleFrom(
// //                     primary: Colors.black, // Background color
// //                   ),
// //                   onPressed: () {
// //                     requestLocationPermission();
// //                     // requestLocationPermission();
// //                   },
// //                   icon: Icon( // <-- Icon
// //                     Icons.upload,
// //                     size: 24.0,
// //                   ),
// //                   label: Text('Upload'), // <-- Text
// //                 ),
// //                 SizedBox(height: 20,),
// //                 ElevatedButton.icon(
// //                   style: ElevatedButton.styleFrom(
// //                     primary: Colors.black, // Background color
// //                   ),
// //                   onPressed: () {
// //                   },
// //                   icon: Icon( // <-- Icon
// //                     Icons.post_add,
// //                     size: 24.0,
// //                   ),
// //                   label: Text('All Post'), // <-- Text
// //                 ),
// //                 SizedBox(height: 20,),
// //                 ElevatedButton.icon(
// //                   style: ElevatedButton.styleFrom(
// //                     primary: Colors.black, // Background color
// //                   ),
// //                   onPressed: () {
// //                     LoginScreen();
// //                   },
// //                   icon: Icon( // <-- Icon
// //                     Icons.logout_outlined,
// //                     size: 24.0,
// //                   ),
// //                   label: Text('LogOut'), // <-- Text
// //                 ),
// //               ],
// //             ),
// //           ),
// //         )
// //       ],
// //       ),
// //     );
// //   }
// // }
