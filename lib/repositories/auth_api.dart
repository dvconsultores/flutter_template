import 'package:flutter/material.dart';
import 'package:flutter_detextre4/repositories/auth_api_interface.dart';

import 'package:flutter_detextre4/models/profile_model.dart';
import 'package:flutter_detextre4/utils/services/local_data/hive_data_service.dart';
import 'package:flutter_detextre4/utils/services/local_data/secure_storage_service.dart';
import 'package:go_router/go_router.dart';

class AuthApi implements AuthApiInterface {
  AuthApi(this.context);
  final BuildContext context;

  @override
  Future<void> signIn() async {
    // ? just for showcase - when go work uncomment other lines and delete this
    final value = (
      "token AUTHENTICATION_TOKEN",
      ProfileModel.fromJson({
        "uid": 1,
        "name": "herian",
        "email": "detextre4@gmail.com",
        "photoURL": "unafotoahi"
      }).toJson()
    );

    // final response = await FetchConfig.post(
    //   Uri.parse('${FetchConfig.baseUrl}endpoint/'),
    //   headers: FetchConfig.headersWithoutAuth,
    //   showRequest: true,
    //   showResponse: true,
    //   requestRef: "endpoint",
    // );

    HiveData.write(HiveDataCollection.profile, value.$2);

    await SecureStorage.write(
      SecureCollection.tokenAuth,
      value.$1,
    ).then((value) => context.goNamed('home'));
  }

  @override
  Future<ProfileModel> signUp() {
    throw UnimplementedError();
  }

  @override
  void signOut() => SecureStorage.delete(SecureCollection.tokenAuth)
      .then((_) => context.goNamed("login"));

  @override
  Future<void> clearTokenAuth() async {
    if ((await SecureStorage.read(SecureCollection.tokenAuth)) == null) return;
    await SecureStorage.delete(SecureCollection.tokenAuth);
  }
}
