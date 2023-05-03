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

  UserModel copyWith({
    required int uid,
    required String name,
    required String email,
    required String photoURL,
  }) =>
      UserModel(
        uid: uid,
        name: name,
        email: email,
        photoURL: photoURL,
      );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json["id"] ?? 0,
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      photoURL: json["photo_url"] ?? "",
    );
  }
}
