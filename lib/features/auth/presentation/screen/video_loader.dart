import 'package:event_ease/core/helper/prefs_helper.dart';
import 'package:event_ease/core/routers/routes_name.dart';
import 'package:event_ease/features/auth/presentation/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerView extends StatefulWidget {
  const VideoPlayerView({super.key});

  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

// class _VideoPlayerViewState extends State<VideoPlayerView> {
//   late VideoPlayerController _controller;
//   bool _hasCompleted = false; // track if already returned

//   @override
//   void initState() {
//     super.initState();
//     _controller =
//         VideoPlayerController.asset("assets/images/splash.mp4")
//           ..initialize().then((_) {
//             setState(() {});
//             _controller.play();
//           })
//           ..addListener(_videoListener);
//   }

//   void _videoListener() {
//     final isInitialized = _controller.value.isInitialized;
//     if (!isInitialized) return;

//     final position = _controller.value.position;
//     final duration = _controller.value.duration;

//     // Detect video completion
//     if (duration != Duration.zero && position >= duration && !_hasCompleted) {
//       _hasCompleted = true;
//       Get.offAll(SplashScreen());
//       Get.toNamed(
//         PrefsHelper.isLogIn && PrefsHelper.token.isNotEmpty
//             ? RoutesName.nav
//             : RoutesName.onboarding,
//       );
//     }
//     setState(() {}); // update UI
//   }

//   @override
//   void dispose() {
//     _controller.removeListener(_videoListener);
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isInitialized = _controller.value.isInitialized;
//     final aspect =
//         MediaQuery.sizeOf(context).width / MediaQuery.sizeOf(context).height;

//     return Scaffold(
//       body: Column(
//         children: [
//           // Video area
//           if (isInitialized)
//             AspectRatio(
//               aspectRatio: aspect,
//               child: Stack(children: [VideoPlayer(_controller)]),
//             ),
//         ],
//       ),
//     );
//   }
// }


class _VideoPlayerViewState extends State<VideoPlayerView> {
  late VideoPlayerController _controller;
  bool _hasCompleted = false; // track if already navigated

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    _controller = VideoPlayerController.asset("assets/images/splash.mp4");

    try {
      // Try initializing with a timeout (e.g. 5 sec)
      await _controller.initialize().timeout(const Duration(seconds: 5));

      // If initialized, start playing
      _controller.play();
      _controller.addListener(_videoListener);
      setState(() {});
    } catch (e) {
      // If initialization fails or times out, fallback
      _goNext();
    }
  }

  void _videoListener() {
    final isInitialized = _controller.value.isInitialized;
    if (!isInitialized) return;

    final position = _controller.value.position;
    final duration = _controller.value.duration;

    // Detect video completion
    if (duration != Duration.zero && position >= duration && !_hasCompleted) {
      _goNext();
    }

    // Handle video errors
    if (_controller.value.hasError && !_hasCompleted) {
      _goNext();
    }

    setState(() {}); // update UI
  }

  void _goNext() {
    if (_hasCompleted) return;
    _hasCompleted = true;

    Get.offAll(() => const SplashScreen());
    Get.toNamed(
      PrefsHelper.isLogIn && PrefsHelper.token.isNotEmpty
          ? RoutesName.nav
          : RoutesName.onboarding,
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_videoListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isInitialized = _controller.value.isInitialized;
    final aspect =
        MediaQuery.sizeOf(context).width / MediaQuery.sizeOf(context).height;

    return Scaffold(
      body: Center(
        child: isInitialized
            ? AspectRatio(
                aspectRatio: aspect,
                child: VideoPlayer(_controller),
              )
            : const CircularProgressIndicator(), // show loader before fallback
      ),
    );
  }
}
