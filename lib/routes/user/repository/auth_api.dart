import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_detextre4/routes/user/model/user_model.dart';
import 'package:flutter_detextre4/utils/config/fetch_config.dart';
import 'package:flutter_detextre4/utils/services/local_data/secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthApi {
  // * authentication api
  static Future<UserModel> authEndpoint() async {
    try {
      final response = await http.get(
        Uri.parse('${FetchConfig.baseUrl}/endpoint/'),
        headers: await FetchConfig.headersWithAuth(),
      );
      await SecureStorage.write(
          SecureStorageCollection.dataSession, jsonDecode(response.body));

      debugPrint("login: ${jsonDecode(response.body)} ⭐");
      return UserModel.fromJson(jsonDecode(response.body));
    } catch (error) {
      // ? commented just for showcase
      // rethrow;
      // ? just for showcase
      final fakeUser = {
        "uid": 1,
        "name": "herian",
        "email": "detextre4@gmail.com",
        "photoURL": "unafotoahi"
      };

      await SecureStorage.write(SecureStorageCollection.dataSession, fakeUser);
      return UserModel.fromJson(fakeUser);
    }
  }
}
