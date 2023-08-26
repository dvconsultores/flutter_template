import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class MainBloc implements Bloc {
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
