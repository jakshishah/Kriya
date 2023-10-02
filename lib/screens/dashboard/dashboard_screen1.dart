import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../userPreferences/current_user.dart';

class DashboardScreen1 extends StatefulWidget {
  const DashboardScreen1({Key? key}) : super(key: key);

  @override
  State<DashboardScreen1> createState() => _DashboardScreen1State();
}

class _DashboardScreen1State extends State<DashboardScreen1> {
  final CurrentUser _currentUser = Get.put(CurrentUser());
  List? imageList = [];

  Future<void> getAllImages() async {
    try {
      String url = "https://www.kriyaadvertisement.com/WebServices/WS.php?type=photo_list";
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          // imageList = jsonDecode(response.body);
          Map<String,dynamic> user = jsonDecode(response.body);
          imageList = user['DATA']['upload_photo'];
        });
      } else {
        print("Failed to load images: ${response.statusCode}");
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
      //backgroundColor: Colors.transparent,
      body: imageList!.isEmpty // Check if imageList is empty or null
          ? Center(child: CircularProgressIndicator()) // Show a loading indicator
          : GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: imageList?.length,
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              children: [
                Container(
                  child: Image.network(imageList?[index]["upload_photo"]),
                ),
                Container(
                  child: Text(imageList?[index]["user_id"]),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}


// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:http/http.dart' as http;
// import '../../userPreferences/current_user.dart';
//
// class DashboardScreen1 extends StatefulWidget {
//   const DashboardScreen1({super.key});
//
//   @override
//   State<DashboardScreen1> createState() => _DashboardScreen1State();
// }
//
// class _DashboardScreen1State extends State<DashboardScreen1> {
//
//
//   final CurrentUser _currentUser = Get.put(CurrentUser()) ;
//
//   List? imageList = [];
//
//   Future<void> getAllImages() async{
//     try{
//       String url = "https://www.kriyaadvertisement.com/WebServices/WS.php?type=photo_list";
//       var response = await http.get(Uri.parse(url));
//
//       if (response.statusCode == 200) {
//         setState(() {
//           //imageList = jsonDecode(response.body);
//
//         });
//       } else {
//         print("Failed to load images: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("Error fetching images: $e");
//     }
//
//     //   String url = "https://www.kriyaadvertisement.com/WebServices/WS.php?type=photo_list";
//     //   var response = await http.get(Uri.parse(url));
//     //   imageList = jsonDecode(response.body);
//     // }catch(e){
//     //   print(e);
//     // }
//
//     // var url = await Uri.parse("https://www.kriyaadvertisement.com/WebServices/WS.php?type=photo_list");
//     // var response = await http.get(url);
//     // if (response.statusCode == 200) {
//     //   setState(() {
//     //     imageList = json.decode(response.body);
//     //   });
//     //   return imageList;
//     // }
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getAllImages();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: GridView.builder(
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
//         itemCount: imageList?.length,
//           itemBuilder: (context,index){
//         return Card(
//           child: Column(
//             children: [
//               Container(
//                   child: Image.network(imageList?[index]["photo"])
//               ),
//               Container(
//                 child: Text(imageList?[index]["user_id"]),
//               )
//             ],
//           ),
//         );
//       })
//     );
//   }
// }

// Container(
//         child: FutureBuilder(future: allPerson(), builder:(context,snapshot){
//           if(snapshot.hasError) print(snapshot.error);
//           return snapshot.hasData ?ListView.builder(
//             itemCount: snapshot.data.length,
//             itemBuilder: (context,index){
//               List list = snapshot.data;
//               return ListTile(
//                 subtitle: Container(child: Image.network("http://192.168.1.25:8056/kriya/uploads/hording_image/${list[index]['image']}"),),
//                 title: Center(child: Text(list[index]['username'])),
//               );
//             }
//           ):CircularProgressIndicator();
//         } ),
//       ),
// Future allPerson() async{
//   var url = Uri.parse("https://www.kriyaadvertisement.com/WebServices/WS.php?type=photo_list");
//   var response = await http.get(url);
//   return jsonDecode(response.body);
//   // return json.decoder;
// }
//
//
// Widget userInfoItemProfile(String userdata){
//   return Container(
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(12),
//       color: Colors.white10,
//     ),
//     padding: EdgeInsets.symmetric(
//       horizontal: 16,
//       vertical: 8,
//     ),
//     child: Row(
//       children: [
//         Text(userdata,style: TextStyle(fontSize: 15),),
//       ],
//     ),
//   );
// }

//Future<List<Map<String, dynamic>>> fetchPhotos() async {
  //   final response = await http.get(Uri.parse("https://www.kriyaadvertisement.com/WebServices/WS.php?type=photo_list"));
  //
  //   if (response.statusCode == 200) {
  //     List<dynamic> data = json.decode(response.body);
  //     return List<Map<String, dynamic>>.from(data);
  //   } else {
  //     throw Exception('Failed to load photos');
  //   }
  // }
  //
  // @override
  // Widget build(BuildContext context) {
  //   var photos;
  //   return Scaffold(
  //     body: Center(child: ListView.builder(
  //       itemCount: photos.length,
  //       itemBuilder: (context, index) {
  //     Map<String, dynamic> photoData = photos[index];
  //     String userId = photoData['user_id'];
  //     String photoUrl = photoData['photo_url'];
  //
  //     return ListTile(
  //       title: Text('User ID: $userId'),
  //       subtitle: Image.network(photoUrl),
  //     );
  //   },
  //   )
  //   ));
  // }