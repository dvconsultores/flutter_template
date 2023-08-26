import 'package:flutter_detextre4/models/profile_model.dart';

abstract class AuthApiInterface {
  Future<void> signIn();
  Future<ProfileModel> signUp();
  void signOut();
  void clearTokenAuth();
}
