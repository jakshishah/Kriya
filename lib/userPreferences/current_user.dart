import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:kriya/userPreferences/user_preferences.dart';

import '../model/user_model.dart';

class CurrentUser extends GetxController
{
  //Rx<User> _currentUser = User(0, '','','').obs;
  Rx<User> _currentUser = User(0, '','').obs;

  User? get user => _currentUser.value;

  // getUserInfo() async{
  //   User? getUserInfoFromLocalStorage = await RememberUserPrefs.readUserInfo();
  //   _currentUser.value = getUserInfoFromLocalStorage!;
  // }
}