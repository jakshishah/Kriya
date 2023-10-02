import 'dart:convert';

class User {
  late int id;
  late String username;
  late String password;
  //late String appUser;

  //User(this.id, this.username, this.password,this._app_user);
  User(this.id, this.username, this.password);

  factory User.fromJson(Map<String, dynamic> json) =>
      //User(int.parse(json["id"]), json["username"], json["password"], json["app_user"]);
      User(int.parse(json["id"]), json["username"], json["password"]);

  Map<String, dynamic> toJson() => {
        'id': id.toString(),
        'username': username,
        'password': password,
        // 'appUser': appUser,
      };
}
