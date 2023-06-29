import 'package:flutter_detextre4/utils/config/extensions_config.dart';

class UserModel implements DefaultModel {
  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.photoURL,
  });
  final int? uid;
  final String name;
  final String email;
  final String photoURL;

  @override
  Iterable get values => toJson().values;

  @override
  UserModel copyWith({
    int? uid,
    String? name,
    String? email,
    String? photoURL,
  }) =>
      UserModel(
        uid: uid ?? this.uid,
        name: name ?? this.name,
        email: email ?? this.email,
        photoURL: photoURL ?? this.photoURL,
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": uid,
        "name": name,
        "email": email,
        "photo_url": photoURL,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        uid: json["id"],
        name: json["name"] ?? "",
        email: json["email"] ?? "",
        photoURL: json["photo_url"] ?? "",
      );

  static UserModel? fromJsonNullable(Map<String, dynamic>? json) =>
      json != null ? UserModel.fromJson(json) : null;
}
