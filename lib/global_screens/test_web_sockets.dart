import 'package:flutter/material.dart';
import 'package:flutter_detextre4/routes/user/bloc/user_bloc.dart';
import 'package:flutter_detextre4/global_widgets/app_scaffold.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class TestWebSockets extends StatefulWidget {
  const TestWebSockets({super.key});
  @override
  State<TestWebSockets> createState() => _TestWebSocketsState();
}

class _TestWebSocketsState extends State<TestWebSockets> {
  final channel =
      WebSocketChannel.connect(Uri.parse('wss://echo.websocket.events'));
  Stream get getChannelStream => channel.stream;
  set setChannelSink(event) => channel.sink.add(event);
  void closeChannel() => channel.sink.close();

  @override
  void dispose() {
    closeChannel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold.responsive(
        appBar: AppBar(),
        tablet: (context, constraints) => StreamBuilder(
            stream: getChannelStream,
            builder: (BuildContext context, snapshot) {
              final dataTestWebSocket = BlocProvider.of<UserBloc>(context)
                  .getterOfTestWebSocket(snapshot.data);

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Web socket test example",
                    style: TextStyle(fontSize: 17),
                  ),
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: TextField(
                      onChanged: (value) => setChannelSink = value,
                    ),
                  ),
                  Text(
                    "database showcase: \n\n $dataTestWebSocket",
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ],
              );
            }));
  }
}