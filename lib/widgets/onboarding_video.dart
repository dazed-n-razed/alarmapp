import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class OnboardingVideo extends StatefulWidget {
  final String videoAsset;
  final double width;
  final double height;

  const OnboardingVideo({
    Key? key,
    required this.videoAsset,
    this.width = 426,
    this.height = 321,
  }) : super(key: key);

  @override
  State<OnboardingVideo> createState() => _OnboardingVideoState();
}

class _OnboardingVideoState extends State<OnboardingVideo> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  // New method to handle initialization
  void _initializeVideoPlayer() {
    // 1. Set initialized to false immediately to show loading/black screen
    setState(() {
      _isInitialized = false;
    });

    // 2. Initialize the controller with the current asset
    _controller = VideoPlayerController.asset(widget.videoAsset);

    _controller.initialize().then((_) {
      // 3. Play the video and set initialized state once ready
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
        _controller.setLooping(true);
        _controller.play();
      }
    }).catchError((error) {
      debugPrint("Video initialization error: $error");
    });
  }

  // --- FIX: Handle widget updates for new video asset ---
  @override
  void didUpdateWidget(covariant OnboardingVideo oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Check if the video asset has changed
    if (widget.videoAsset != oldWidget.videoAsset) {
      // 1. Dispose the old controller to free up resources
      _controller.dispose();
      
      // 2. Initialize the new video player
      _initializeVideoPlayer();
    }
  }
  // ------------------------------------------------------


  @override
  void dispose() {
    // Ensure the controller is paused before disposing to prevent potential resource issues
    if (_controller.value.isPlaying) {
      _controller.pause();
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      // The video player should not clip the top, as it's meant to overlap
      // the status bar and be flush with the top of the screen (or the safe area boundary).
      // The borderRadius(16) should be removed to match the full-width, non-rounded
      // top part of the media in your design image.
      child: _isInitialized
          ? VideoPlayer(_controller) // Removed ClipRRect
          : Container(
              color: Colors.black,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
    );
  }
}