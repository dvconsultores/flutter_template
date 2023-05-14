class UserModel {
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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json["id"],
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      photoURL: json["photo_url"] ?? "",
    );
  }

  Map<String, dynamic> toMap() => {
        "id": uid,
        "name": name,
        "email": email,
        "photo_url": photoURL,
      };
}
