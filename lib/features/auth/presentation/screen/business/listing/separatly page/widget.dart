import 'dart:io';

import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ReusableImagePicker extends StatelessWidget {
  final String title;
  final bool isUploaded;
  final List<String>? filePaths; // List of image paths (local or network)
  final VoidCallback onTap;
  final Function(String path)? onRemove; // Only for gallery
  final bool isGallery; // True if this is for gallery

  const ReusableImagePicker({
    Key? key,
    required this.title,
    required this.isUploaded,
    required this.filePaths,
    required this.onTap,
    this.onRemove,
    this.isGallery = false, // default false for logo/cover
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final styleForBoldText = const TextStyle(fontWeight: FontWeight.bold, fontSize: 16);

    String buttonText() {
      if (isGallery) {
        return isUploaded ? "Update Images" : "Add Images";
      } else {
        return isUploaded ? "Change Image" : "Upload Image";
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: styleForBoldText.copyWith(fontSize: 18)),
        const SizedBox(height: 5),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.primary,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.upload, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  buttonText(),
                  style: styleForBoldText.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        if (filePaths != null && filePaths!.isNotEmpty) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: filePaths!.map((path) {
              if (path.isEmpty) return const SizedBox();

              bool isNetwork = path.startsWith('http://') || path.startsWith('https://');

              return Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: isNetwork
                        ? Image.network(
                            path,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => SizedBox(
                              height: 80,
                              width: 80,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.broken_image, color: Colors.grey),
                                  SizedBox(height: 4),
                                  Text(
                                    "Image could not load",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Image.file(
                            File(path),
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                  ),
                  // if (isGallery) // Only show cancel for gallery images
                    Positioned(
                      top: -5,
                      right: -5,
                      child: IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.red, size: 20),
                        onPressed: () {
                          if (onRemove != null) onRemove!(path);
                        },
                      ),
                    ),
                ],
              );
            }).toList(),
          ),
        ],
        const SizedBox(height: 10),
      ],
    );
  }
}
