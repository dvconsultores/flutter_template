import 'package:flutter_detextre4/main_provider.dart';
import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';
import 'package:flutter_detextre4/utils/general/context_utility.dart';
import 'package:provider/provider.dart';

class ProfileModel implements DefaultModel {
  ProfileModel({
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

  static ProfileModel get() =>
      ContextUtility.context!.read<MainProvider>().profile as ProfileModel;

  @override
  ProfileModel copyWith({
    int? uid,
    String? name,
    String? email,
    String? photoURL,
  }) =>
      ProfileModel(
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

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        uid: json["id"],
        name: json["name"] ?? "",
        email: json["email"] ?? "",
        photoURL: json["photo_url"] ?? "",
      );

  static ProfileModel? fromJsonNullable(Map<String, dynamic>? json) =>
      json != null ? ProfileModel.fromJson(json) : null;
}
