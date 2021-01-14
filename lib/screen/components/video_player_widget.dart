import 'package:fans/r.g.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWideget extends StatefulWidget {
  final String url;

  const VideoPlayerWideget({Key key, this.url}) : super(key: key);

  @override
  _VideoPlayerWidegetState createState() => _VideoPlayerWidegetState();
}

class _VideoPlayerWidegetState extends State<VideoPlayerWideget> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  double initialVolume;

  @override
  void initState() {
    _controller = VideoPlayerController.network(widget.url);
    _controller.addListener(() {
      setState(() {});
    });
    initialVolume = _controller.value.volume;
    _controller.setLooping(true);
    _controller.setVolume(0);
    _initializeVideoPlayerFuture = _controller.initialize()
      ..then((value) => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If the VideoPlayerController has finished initialization, use
          // the data it provides to limit the aspect ratio of the video.
          return Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                // Use the VideoPlayer widget to display the video.
                child: VideoPlayer(_controller),
              ),
              _PlayPauseOverlay(
                controller: _controller,
              ),
              Positioned(
                top: 0,
                right: 0,
                height: 30,
                width: 30,
                child: GestureDetector(
                  child: Image(
                    image: _controller.value.volume == 0
                        ? R.image.voice_mute()
                        : R.image.voice_unmute(),
                  ),
                  onTap: () {
                    var currentVolume = _controller.value.volume;
                    if (currentVolume == 0) {
                      _controller.setVolume(initialVolume);
                    } else {
                      _controller.setVolume(0);
                    }
                  },
                ),
              ),
            ],
          );
        } else {
          // If the VideoPlayerController is still initializing, show a
          // loading spinner.
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _PlayPauseOverlay extends StatelessWidget {
  const _PlayPauseOverlay({Key key, this.controller}) : super(key: key);

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? SizedBox.shrink()
              : Center(
                  child: Image(
                    image: R.image.play(),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            var playing = controller.value.isPlaying;
            print('click play: $playing');
            if (controller.value.isPlaying) {
              controller.pause();
            } else {
              // If the video is paused, play it.
              controller.play();
            }
          },
        ),
      ],
    );
  }
}
