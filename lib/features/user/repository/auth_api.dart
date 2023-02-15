import 'package:flutter_platzi_trips/features/user/model/user_model.dart';

class AuthApi {
  static Stream<UserModel> authApiEndpoint() async* {
    yield UserModel(
      name: "name",
      email: "email",
      photoURL: "photoURL",
      uid: "uid",
    );
  }
}
