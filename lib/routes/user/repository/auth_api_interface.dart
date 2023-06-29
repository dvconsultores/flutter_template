import 'package:flutter_detextre4/routes/user/model/user_model.dart';

abstract class AuthApiInterface {
  Future<void> signIn();
  Future<UserModel> signUp();
  Future<void> signOut();
}
