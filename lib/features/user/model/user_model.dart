import 'package:flutter/material.dart';

class UserModel {
  UserModel({
    Key? key,
    required this.uid,
    required this.name,
    required this.email,
    required this.photoURL,
  });

  final int uid;
  final String name;
  final String email;
  final String photoURL;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json["id"] ?? 0,
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      photoURL: json["photo_url"] ?? "",
    );
  }
}
