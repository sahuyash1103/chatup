
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatup/chating/data/enums/message_enums.dart';
import 'package:chatup/chating/views/widgets/custom_video_player.dart';
import 'package:flutter/material.dart';

class DisplayTextImageGIF extends StatelessWidget {
  const DisplayTextImageGIF({
    super.key,
    required this.message,
    required this.type,
  });
  final String message;
  final MessageEnum type;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case MessageEnum.text:
        return Padding(
          padding: const EdgeInsets.only(left: 5, top: 2),
          child: Text(
            message,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        );
      case MessageEnum.image:
        return CachedNetworkImage(
          imageUrl: message,
          imageBuilder: (context, imageProvider) {
            return Container(
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        );
      case MessageEnum.video:
        return CustomVideoPlayer(
          videoUrl: message,
        );
      case MessageEnum.gif:
        return CachedNetworkImage(
          imageUrl: message,
          imageBuilder: (context, imageProvider) {
            return Container(
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        );
      case MessageEnum.audio:
        var isPlaying = false;
        var isCompleted = false;
        final audioPlayer = AudioPlayer();
        var audioPosition = Duration.zero;
        var totalLength = Duration.zero;
        audioPlayer.setSourceUrl(message);
        return StatefulBuilder(
          builder: (context, setState) {
            audioPlayer.onDurationChanged.listen((d) {
              totalLength = d;
            });
            audioPlayer.onPositionChanged.listen((p) {
              audioPosition = p;
              if (totalLength == audioPosition) {
                isPlaying = false;
                isCompleted = true;
              }
              setState(() {});
            });
            final size = MediaQuery.of(context).size;
            return Container(
              width: size.width * 0.6,
              margin: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 15,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.mic,
                    size: 30,
                    color: Colors.white70,
                  ),
                  Container(
                    width: size.width * 0.36,
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: ProgressBar(
                      progress: audioPosition,
                      total: totalLength,
                      onSeek: audioPlayer.seek,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isPlaying
                          ? Icons.pause_circle
                          : isCompleted
                              ? Icons.replay_circle_filled
                              : Icons.play_circle,
                      size: 30,
                    ),
                    onPressed: () async {
                      if (isPlaying) {
                        await audioPlayer.pause();
                        setState(() {
                          isPlaying = false;
                        });
                      } else if (isCompleted) {
                        await audioPlayer.seek(Duration.zero);
                        await audioPlayer.play(UrlSource(message));
                        setState(() {
                          isPlaying = true;
                          isCompleted = false;
                        });
                      } else {
                        await audioPlayer.play(UrlSource(message));
                        setState(() {
                          isPlaying = true;
                        });
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      case MessageEnum.file:
        break;
      case MessageEnum.location:
        break;
      case MessageEnum.contact:
        break;
      case MessageEnum.sticker:
        break;
    }
    return Text(type.toString());
  }
}
