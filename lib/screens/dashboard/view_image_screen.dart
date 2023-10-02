import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kriya/screens/dashboard/dashboard_screen2.dart';

class ViewImageScreen extends StatefulWidget {
  const ViewImageScreen({super.key});

  @override
  State<ViewImageScreen> createState() => _ViewImageScreenState();
}

class _ViewImageScreenState extends State<ViewImageScreen> {

  List imageList = [];
  String? storedUserId;
  Future getAllImages() async{
    try{
      String url = "https://www.kriyaadvertisement.com/WebServices/WS.php?type=photo_list";
      // String url = "http://192.168.1.25:8056/kriya/WebServices/WS.php?type=photo_list";
      var response = await http.get(Uri.parse(url));
      print('Response Body: ${response.body}');
      print('Response Status Code: ${response.statusCode}');


      if (response.statusCode == 200) {

        Map<String, dynamic> user = jsonDecode(response.body);
        print(user);
        List? photos = user['DATA']['upload_photo'];
        print(photos);
        // List<String> urls = photos
        //     .map((photo) => "http://192.168.1.25:8056/kriya/uploads/hoarding_image/" + photo['photo'].toString())
        //     .toList();
        if(photos != null){
        List? urls = photos
            .map((photo) => "https://www.kriyaadvertisement.com/uploads/hoarding_image/" + photo['photo'].toString())
            .toList();
        imageList = urls;
        print("Images: $imageList");
        }
      } else {
        //Fluttertoast.showToast(msg: "Images Not Show");
      }
    } catch (e) {
      print("Error fetching images: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getAllImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Photo'),
        centerTitle: true,
        leading: IconButton(onPressed: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>DashboardScreen2(storedUserId: storedUserId,)));
        },
          icon: Icon(Icons.arrow_back_ios,
          ),
        ),
      ),
      //backgroundColor: Colors.transparent,
      body: imageList.isEmpty // Check if imageList is empty or null
          ? Center(child: Text("No image Found")) // Show a loading indicator
          : ListView.builder(
        itemCount: imageList.length,
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              children: [
                Container(
                  child: Image.network(imageList[index]),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// setState(() {
//   // imageList = jsonDecode(response.body);
//   // print(imageList);
//   // Map<String, dynamic> user = jsonDecode(response.body);
//   // print(user);
//   // List<dynamic> photos = user['DATA']['upload_photo'];
//   // print(photos);
//   // List<String> urls = photos.map((photo) => photo['photo'].toString()).toList();
//  // Fluttertoast.showToast(msg: "Images Shown");
//
// });

// imageList = jsonDecode(response.body);
// print(imageList);
// Map<String, dynamic> user = jsonDecode(response.body);
// print(user);
// List photo = user['DATA']['upload_photo'];
// print(photo);