import 'dart:convert';

class LoginResModel {
  String id;
  String userName;
  String email;
  String token;
  String message;

  LoginResModel({
    required this.id,
    required this.userName,
    required this.email,
    required this.token,
    required this.message,
  });

  factory LoginResModel.fromRawJson(String str) =>
      LoginResModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoginResModel.fromJson(Map<String, dynamic> json) => LoginResModel(
        id: json["_id"],
        userName: json["userName"],
        email: json["email"],
        token: json["token"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userName": userName,
        "email": email,
        "token": token,
        "message": message,
      };
}
