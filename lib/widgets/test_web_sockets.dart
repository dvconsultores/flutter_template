import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// TODO web socket test - just for testing

class TestWebSockets extends StatelessWidget {
  TestWebSockets({super.key});

  // * channel controller
  final testChannel = WebSocketChannel.connect(
    Uri.parse('wss://echo.websocket.events'),
  );
  // * channel stream
  Stream get testChannelStream => testChannel.stream;
  // * channel sink
  set testChannelSink(event) => testChannel.sink.add(event);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: StreamBuilder(
            stream: testChannelStream,
            builder: (BuildContext context, snapshot) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${snapshot.data}",
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    TextButton(
                      child: const Text(
                        "press button",
                        style: TextStyle(fontSize: 18),
                      ),
                      onPressed: () {
                        testChannelSink = "texto nuevo";
                      },
                    ),
                    TextButton(
                      child: const Text(
                        "press button 2",
                        style: TextStyle(fontSize: 18),
                      ),
                      onPressed: () {
                        testChannelSink = null;
                      },
                    )
                  ]),
                ],
              );
            }));
  }
}
