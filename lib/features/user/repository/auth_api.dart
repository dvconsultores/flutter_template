import 'dart:convert';

import 'package:flutter_detextre4/features/user/model/user_model.dart';
import 'package:flutter_detextre4/utils/config/fetch_config.dart';
import 'package:http/http.dart' as http;

class AuthApi {
  // * authentication api
  static Future<UserModel> authEndpoint() async {
    try {
      final response = await http.get(
        Uri.parse('${FetchConfig.baseUrl}/endpoint/'),
        headers: FetchConfig.headersWithoutAuth,
      );

      return UserModel.fromJson(jsonDecode(response.body));
    } catch (error) {
      // ? commented just for showcase
      // throw Exception(error);
      // ? just for showcase
      return UserModel(
        uid: 1,
        name: "herian",
        email: "detextre4@gmail.com",
        photoURL: "unafotoahi",
      );
    }
  }

  // * logout api
  static Future<void> logoutEndpoint() async {
    try {
      await http.post(
        Uri.parse('${FetchConfig.baseUrl}/endpoint/'),
        headers: FetchConfig.headersWithoutAuth,
      );

      // ignore: avoid_print
      print("Sesion is closed");
    } catch (error) {
      // ? commented just for showcase
      // throw Exception(error);
    }
  }
}
