import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class CVImageView extends StatelessWidget {
  final String imageUrl;

  const CVImageView({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Preview"),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18),
        elevation: 0,
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: PhotoView(
            imageProvider: NetworkImage(imageUrl),
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2.5,
            loadingBuilder: (context, progress) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorBuilder: (context, error, stackTrace) => const Center(
              child: Icon(Icons.error, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
