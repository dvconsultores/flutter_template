import 'package:flutter/material.dart';
import 'package:flutter_detextre4/features/user/bloc/user_bloc.dart';
import 'package:flutter_detextre4/widgets/app_scaffold.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

// TODO web socket test - just for testing
class TestWebSockets extends StatefulWidget {
  const TestWebSockets({super.key});
  @override
  State<TestWebSockets> createState() => _TestWebSocketsState();
}

class _TestWebSocketsState extends State<TestWebSockets> {
  // final channel =
  //     WebSocketChannel.connect(Uri.parse('wss://echo.websocket.events'));

  @override
  void dispose() {
    // final globalKey =
    // Provider.of<MainProvider>(context, listen: false).globalKey;
    // BlocProvider.of<UserBloc>(context).closeChannel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userBloc = BlocProvider.of<UserBloc>(context);

    return AppScaffold(
        appBar: AppBar(),
        body: StreamBuilder(
            stream: userBloc.getChannelStream,
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
                      onChanged: (value) => userBloc.setChannelSink = value,
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
