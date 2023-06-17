// import 'dart:convert';

// import 'package:flutter/material.dart';
import 'package:flutter_detextre4/routes/user/model/user_model.dart';
// import 'package:flutter_detextre4/utils/config/extensions_config.dart';
// import 'package:flutter_detextre4/utils/config/fetch_config.dart';
// import 'package:flutter_detextre4/utils/services/local_data/secure_storage.dart';
// import 'package:http/http.dart' as http;

class AuthApi {
  // * authentication api
  static Future<UserModel> authEndpoint() async {
    // ? just for showcase - when go work uncomment other lines and delete this
    return UserModel.fromJson({
      "uid": 1,
      "name": "herian",
      "email": "detextre4@gmail.com",
      "photoURL": "unafotoahi"
    });

    // final response = await http.get(
    //   Uri.parse('${FetchConfig.baseUrl}/endpoint/'),
    //   headers: FetchConfig.headersWithoutAuth,
    // );

    // if (response.statusCode == 200 || response.statusCode == 201) {
    //   await SecureStorage.write(
    //     SecureStorageCollection.dataUser,
    //     jsonDecode(response.body),
    //   );

    //   debugPrint("login: ${jsonDecode(response.body)} ⭐");
    //   return UserModel.fromJson(jsonDecode(response.body));
    // }

    // throw response.catchErrorMessage(fallback: "error to load data");
  }
}
