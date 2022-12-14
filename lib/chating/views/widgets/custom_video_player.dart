import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';

class CustomVideoPlayer extends StatefulWidget {
  const CustomVideoPlayer({
    super.key,
    required this.videoUrl,
  });
  final String videoUrl;

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late CachedVideoPlayerController videoPlayerController;
  bool isPlaying = false;
  bool isEnded = false;

  @override
  void initState() {
    super.initState();
    videoPlayerController = CachedVideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) {
        videoPlayerController.setVolume(1);
      });
    videoPlayerController.addListener(() {
      if (videoPlayerController.value.position ==
          videoPlayerController.value.duration) {
        isPlaying = false;
        isEnded = true;
        setState(() {});
      } else if (videoPlayerController.value.isPlaying) {
        isPlaying = true;
        isEnded = false;
        setState(() {});
      } else if (videoPlayerController.value.position <
          videoPlayerController.value.duration) {
        isPlaying = false;
        isEnded = false;
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          CachedVideoPlayer(videoPlayerController),
          Align(
            child: IconButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
                shape: MaterialStateProperty.all(
                  const CircleBorder(),
                ),
              ),
              onPressed: () {
                if (isEnded) {
                  videoPlayerController
                    ..seekTo(Duration.zero)
                    ..play();
                  isPlaying = true;
                  isEnded = false;
                } else if (videoPlayerController.value.isPlaying) {
                  videoPlayerController.pause();
                  isPlaying = false;
                } else {
                  videoPlayerController.play();
                  isPlaying = true;
                  isEnded = false;
                }
                setState(() {});
              },
              icon: Icon(
                isEnded
                    ? Icons.replay_outlined
                    : isPlaying
                        ? Icons.pause_circle
                        : Icons.play_circle,
                size: 65,
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
