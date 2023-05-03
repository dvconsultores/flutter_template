import 'dart:async';

import 'package:flutter_detextre4/routes/user/model/user_model.dart';
import 'package:flutter_detextre4/routes/user/repository/auth_api.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc implements Bloc {
  // * user data
  late bool isLoggedIn = false;
  final StreamController<UserModel?> dataUserController = BehaviorSubject();

  Stream<UserModel?> get getDataUserStream => dataUserController.stream;
  set setDataUserSink(event) {
    dataUserController.sink.add(event);
    isLoggedIn = true;
  }

  void closeSesion() {
    AuthApi.logoutEndpoint();
    setDataUserSink = null;
    isLoggedIn = false;
  }

  // ------------------------------------------------------------------------ //

  // * test web socket
  late String dataTestWebSocket = "";
  String getterOfTestWebSocket(event) {
    if (event != null) {
      dataTestWebSocket = event;
    }
    return dataTestWebSocket;
  }

  // ------------------------------------------------------------------------ //

  @override
  void dispose() {}
}
