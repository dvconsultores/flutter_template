import 'dart:async';

import 'package:flutter_detextre4/features/user/model/user_model.dart';
import 'package:flutter_detextre4/features/user/repository/auth_api.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc implements Bloc {
  // * user data
  final StreamController<UserModel?> dataUserController = BehaviorSubject();

  Stream<UserModel?> get getDataUserStream => dataUserController.stream;
  set setDataUserSink(event) => dataUserController.sink.add(event);
  void closeSesion() {
    AuthApi.logoutEndpoint();
    setDataUserSink = null;
  }

  // ------------------------------------------------------------------------ //

  @override
  void dispose() {}
}
