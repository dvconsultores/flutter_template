import 'dart:io';

import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VideoView extends StatefulWidget {
  const VideoView({
    super.key,
    required this.uri,
    this.onClose,
  });
  final String uri;
  final VoidCallback? onClose;

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  late VideoPlayerController previewVideoPlayerControler;
  late CustomVideoPlayerController _customVideoPlayerController;

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(ThemeApp.systemUiOverlayStyle.copyWith(
      systemNavigationBarColor: Colors.black,
    ));

    previewVideoPlayerControler = widget.uri.hasNetworkPath
        ? VideoPlayerController.networkUrl(Uri.parse(widget.uri))
        : VideoPlayerController.file(File.fromUri(Uri.parse(widget.uri)));

    previewVideoPlayerControler.initialize().then((value) {
      previewVideoPlayerControler.play();
      setState(() {});
    });

    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: previewVideoPlayerControler,
    );

    super.initState();
  }

  @override
  void dispose() {
    _customVideoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          iconSize: 25,
          splashRadius: 25,
          icon: const Icon(Icons.arrow_back_rounded),
          color: Colors.white,
          onPressed: () => widget.onClose ?? Navigator.pop(context),
        ),
        backgroundColor: Colors.white10,
        centerTitle: true,
        title: Text(
          "Previsualizar Video",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 17,
                color: Colors.white,
              ),
        ),
      ),
      body: Center(
        child: !previewVideoPlayerControler.value.isInitialized
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : CustomVideoPlayer(
                customVideoPlayerController: _customVideoPlayerController,
              ),
      ),
    );
  }
}
