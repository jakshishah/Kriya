import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/user_model.dart';

class RememberUserPrefs
{
  final String auth_token_key = "user_id";
  late final SharedPreferences prefs;

  // save data into shred preferences
  Future<void> saveRememberUser(String auth_tokan) async{
    prefs = await SharedPreferences.getInstance();
    prefs.setString(auth_token_key, auth_tokan);
  }


  // get the value into shred preferences
  Future<String?> readUserInfo() async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? auth_token;
    auth_token = (pref.getString(auth_token_key) ?? null);
    return auth_token;
  }

  // to get the value of App-User
  Future<void> saveUserType(String userType) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('user_type', userType);
  }

  // get the value of App-User
  Future<String?> getUserType() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_type');
  }

  // Future<int?> readUserInfo() async{
  //   final SharedPreferences pref = await SharedPreferences.getInstance();
  //   int? auth_token;
  //   auth_token = (pref.getString(auth_token_key) ?? null) as int?;
  //   return auth_token;
  // }

  // To clear the user
  clearAll() async{
    prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

// Save-remember User-Info
// static Future<void> saveRememberUser(User userInfo) async{
//   SharedPreferences preferences = await SharedPreferences.getInstance();
//   String userJsonData = jsonEncode(userInfo.toJson());
//   await preferences.setString("currentUser", userJsonData);
// }
//
// // get-read User-Info
// static Future<User?> readUserInfo() async{
//   User? currentUserInfo;
//   SharedPreferences preferences = await SharedPreferences.getInstance();
//   String? userInfo = preferences.getString("currentUser");
//
//   if(userInfo != null){
//     Map<String,dynamic> userDataMap = jsonDecode(userInfo);
//     currentUserInfo = User.fromJson(userDataMap);
//   }
//   return currentUserInfo;
// }
//
// static Future<void> removeUserInfo() async {
//   SharedPreferences preferences = await SharedPreferences.getInstance();
//   await preferences.remove("currentUser");
// }

// static Future<void> storeUserInfo(User userInfo) async
// {
// SharedPreferences preferences = await SharedPreferences.getInstance();
// String userJsonData = jsonEncode(userInfo.toJson());
// await preferences.setString("currentUser", userJsonData);
// }
//static Future<User?> readUserInfo() async{
//   User? currentUserInfo;
//   SharedPreferences preferences = await SharedPreferences.getInstance();
//   String? userInfo = preferences.getString("currentUser");
//
//   if(userInfo != null){
//     Map<String,dynamic> userDataMap = jsonDecode(userInfo);
//     currentUserInfo = User.fromJson(userDataMap);
//   }
//   return currentUserInfo;
// }
//
// static Future<void> removeUserInfo() async {
//   SharedPreferences preferences = await SharedPreferences.getInstance();
//   await preferences.remove("currentUser");
// }