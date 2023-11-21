import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FullScreenVideoPlayer extends StatefulWidget {
  final String? videoUrl;
  final String? videoPath;

  const FullScreenVideoPlayer(
      {super.key, this.videoUrl, this.videoPath});

  @override
  State<FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    if (widget.videoUrl != null) {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl!),
      )..initialize().then(
          (_) {
            setState(() {});
          },
        );
    } else {
      _controller = VideoPlayerController.file(File(widget.videoPath!))
        ..initialize().then(
          (_) {
            setState(() {});
          },
        );
    }
  }

  void _playPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  void _forward() {
    _controller.seekTo(
      _controller.value.position + const Duration(seconds: 10),
    );
  }

  void _rewind() {
    _controller.seekTo(
      _controller.value.position - const Duration(seconds: 10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          ),
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              iconSize: 35,
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: VideoProgressIndicator(
              _controller,
              allowScrubbing: true,
              padding: const EdgeInsets.all(10),
              colors: VideoProgressColors(
                playedColor: Colors.amber,
                bufferedColor: Colors.amber.withOpacity(0.3),
                backgroundColor: Colors.white70,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 50,
                  icon: const Icon(Icons.replay_10, color: Colors.white),
                  onPressed: _rewind,
                ),
                IconButton(
                  iconSize: 60,
                  icon: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  onPressed: _playPause,
                ),
                IconButton(
                  iconSize: 50,
                  icon: const Icon(Icons.forward_10, color: Colors.white),
                  onPressed: _forward,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
