import 'dart:convert';

User userFromJson(String str) {
  final jsonData = json.decode(str);
  return User.fromMap(jsonData);
}

String userToJson(User data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class User {
  String userEmail;
  String userApi;

  User({
    this.userApi,
    this.userEmail,
  });

  factory User.fromMap(Map<String, dynamic> json) => new User(
    userApi: json["userApi"],
    userEmail: json["userEmail"],
  );

  Map<String, dynamic> toMap() => {
    "userApi": userApi,
    "userEmail": userEmail,
  };

  String get _userApi=>userApi;
  String get _userEmail=>userEmail;
}