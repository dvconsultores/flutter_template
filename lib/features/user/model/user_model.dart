import 'package:flutter/material.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String photoURL;

  UserModel({
    Key? key,
    required this.name,
    required this.email,
    required this.photoURL,
    required this.uid,
  });
}
