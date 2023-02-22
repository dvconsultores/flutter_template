import 'dart:async';

import 'package:flutter_detextre4/features/user/model/user_model.dart';
import 'package:flutter_detextre4/features/user/repository/auth_api.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

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
  final channel =
      WebSocketChannel.connect(Uri.parse('wss://echo.websocket.events'));
  // final StreamController channelController = BehaviorSubject();

  Stream get getChannelStream {
    return channel.stream;
    // channelController.sink.addStream(channel.stream);
    // return channelController.stream;
  }

  set setChannelSink(event) {
    channel.sink.add(event);
  }

  void closeChannel() {
    channel.sink.close();
    // channelController.sink.close();
  }

  // ------------------------------------------------------------------------ //

  @override
  void dispose() {}
}
