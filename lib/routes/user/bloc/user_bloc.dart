import 'dart:async';

import 'package:flutter_detextre4/routes/user/model/user_model.dart';
import 'package:flutter_detextre4/utils/config/router_config.dart';
import 'package:flutter_detextre4/utils/services/local_data/secure_storage_service.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class UserBloc implements Bloc {
  // * user data
  Future<UserModel?> get dataUser async => UserModel.fromJsonNullable(
      await SecureStorage.read(SecureStorageCollection.dataUser));

  Future<bool> get isLogged async =>
      await SecureStorage.read(SecureStorageCollection.dataUser) != null;

  set addData(UserModel? event) => SecureStorage.write(
        SecureStorageCollection.dataUser,
        event?.toJson(),
      ).then((_) {
        if (event == null) {
          closeSession;
        } else if (router.location == "/login") {
          router.go("/");
        }
      });

  get closeSession => SecureStorage.delete(SecureStorageCollection.dataUser)
      .then((_) => router.go("/login"));

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

  @override
  void dispose() {}
}
