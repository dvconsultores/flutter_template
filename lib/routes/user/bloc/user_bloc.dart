import 'dart:async';

import 'package:flutterDetextre4/routes/user/model/user_model.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc implements Bloc {
  // * user data
  final StreamController<UserModel?> _dataUserController = BehaviorSubject();

  Stream<UserModel?> get dataUserStream => _dataUserController.stream;
  set dataUserSink(event) => _dataUserController.sink.add(event);
  void get closeSesion => dataUserSink = null;
  Future<bool> get isLogged async => !(await dataUserStream.isEmpty);
  void get closeStream => _dataUserController.sink.close();

  // ------------------------------------------------------------------------ //

  // * test web socket
  late String dataTestWebSocket = "";
  String getterOfTestWebSocket(event) {
    if (event != null) dataTestWebSocket = event;
    return dataTestWebSocket;
  }

  // ------------------------------------------------------------------------ //

  @override
  void dispose() {}
}
