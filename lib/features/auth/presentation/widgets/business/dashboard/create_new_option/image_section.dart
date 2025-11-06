import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:flutter/material.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/styles.dart';

class ImagesSection extends StatelessWidget {
  final bool logoUploaded;
  final bool coverImage;
  final bool galleryUploaded;
  final String title;
  final Function(String) uploadImage;

  const ImagesSection({
    super.key,
    required this.logoUploaded,
    required this.title,
    required this.coverImage,
    required this.galleryUploaded,
    required this.uploadImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: styleForBoldText),
        const SizedBox(height: 10),
        // Logo
        Row(
          children: [
            Text(AppString.logo, style: styleForBoldText.copyWith(fontSize: 18)),
            const SizedBox(width: 5),
          ],
        ),
        const SizedBox(height: 5),
        InkWell(
          onTap: () => uploadImage('logo'),
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
                  logoUploaded ? AppString.changeImage : AppString.uploadImage,
                  style: styleForBoldText.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Cover Image
        Row(
          children: [
            Text("${AppString.coverImage} *", style: styleForBoldText.copyWith(fontSize: 18)),
            const SizedBox(width: 5),
            if (coverImage) const Icon(Icons.check_circle, color: Colors.green),
          ],
        ),
        const SizedBox(height: 5),
        InkWell(
          onTap: () => uploadImage('cover'),
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
                  coverImage ? AppString.changeImage : AppString.uploadImage,
                  style: styleForBoldText.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Image Gallery
        Row(
          children: [
            Text(AppString.imageGallery, style: styleForBoldText.copyWith(fontSize: 18)),
            const SizedBox(width: 5),
            if (galleryUploaded) const Icon(Icons.check_circle, color: Colors.green),
          ],
        ),
        const SizedBox(height: 5),
        InkWell(
          onTap: () => uploadImage('gallery'),
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
                  galleryUploaded ? AppString.changeImage : AppString.uploadImage,
                  style: styleForBoldText.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}