import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// TODO web socket test - just for testing
class TestWebSockets extends StatefulWidget {
  const TestWebSockets({super.key});
  @override
  State<TestWebSockets> createState() => _TestWebSocketsState();
}

class _TestWebSocketsState extends State<TestWebSockets> {
  final channel =
      WebSocketChannel.connect(Uri.parse('wss://echo.websocket.events'));

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: StreamBuilder(
            stream: channel.stream,
            builder: (BuildContext context, snapshot) {
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
                      onChanged: (value) => channel.sink.add(value),
                    ),
                  ),
                  Text(
                    "database showcase: \n\n ${snapshot.data}",
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ],
              );
            }));
  }
}
