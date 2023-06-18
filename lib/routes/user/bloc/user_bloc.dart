import 'dart:async';

import 'package:flutter_detextre4/routes/user/model/user_model.dart';
import 'package:flutter_detextre4/utils/services/local_data/secure_storage.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc implements Bloc {
  // * user data
  UserModel? dataUser;
  final StreamController<UserModel?> _dataUserController = BehaviorSubject();

  Stream<UserModel?> get dataUserStream => _dataUserController.stream;
  set add(UserModel? event) => _dataUserController.sink.add(event);

  void get closeSesion => add = null;

  bool get isLogged => dataUser != null;

  void listen() => dataUserStream.listen((event) async {
        //? when log in
        if (event != null) {
          await SecureStorage.write(
            SecureStorageCollection.dataUser,
            event.toJson(),
          );
          return await init(setDataUser: true);
        }

        //? when log out
        await SecureStorage.delete(SecureStorageCollection.dataUser);
        await init(setDataUser: true);
      });

  Future<void> init({bool setDataUser = false}) async {
    final localData =
        await SecureStorage.read(SecureStorageCollection.dataUser);
    setDataUser
        ? dataUser = UserModel.fromJsonNullable(localData)
        : add = UserModel.fromJsonNullable(localData);
  }

  // ------------------------------------------------------------------------ //

  // * test web socket
  String dataTestWebSocket = "";
  String getterOfTestWebSocket(dynamic event) {
    if (event != null) dataTestWebSocket = event;
    return dataTestWebSocket;
  }

  // ------------------------------------------------------------------------ //

  @override
  void dispose() => _dataUserController.sink.close();
}
