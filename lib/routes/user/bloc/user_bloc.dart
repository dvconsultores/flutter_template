import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_detextre4/routes/user/model/user_model.dart';
import 'package:flutter_detextre4/main_router.dart';
import 'package:flutter_detextre4/utils/services/local_data/secure_storage.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class UserBloc implements Bloc {
  // * user data
  UserModel? dataUser;

  bool get isLogged => dataUser != null;

  set addData(UserModel? event) =>
      SecureStorage.write(SecureStorageCollection.dataUser, event?.toJson())
          .then((_) {
        dataUser = event;
        if (routerConfig.location == "/login") routerConfig.go("/login");
      });

  get closeSession =>
      SecureStorage.delete(SecureStorageCollection.dataUser).then((_) {
        dataUser = null;
        routerConfig.go("/login");
      });

  Future<void> init() async => addData = UserModel.fromJsonNullable(
      await SecureStorage.read(SecureStorageCollection.dataUser));

  // ------------------------------------------------------------------------ //

  // * test web socket
  String dataTestWebSocket = "";
  String getterOfTestWebSocket(dynamic event) {
    if (event != null) dataTestWebSocket = event;
    return dataTestWebSocket;
  }

  // ------------------------------------------------------------------------ //

  static UserBloc of(BuildContext context) =>
      BlocProvider.of<UserBloc>(context);

  @override
  void dispose() {}
}
