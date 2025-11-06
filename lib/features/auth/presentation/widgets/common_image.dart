import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

enum ImageType { png, svg, network, file, asset,networkSvg}

class CommonImage extends StatelessWidget {
  final String imageSrc;
  final String defaultImage;
  final Color? imageColor;
  final double height;
  final double width;
  final double borderRadius;
  final double? size;
  final ImageType imageType;
  final BoxFit fill;
  final BlendMode colorBlendMode;

  CommonImage({
    required this.imageSrc,
    this.imageColor,
    this.height = 100,
    this.width = 200,
    this.borderRadius = 1,
    this.size,
    this.imageType = ImageType.svg,
    this.fill = BoxFit.cover,
    this.defaultImage = "assets/images/noImage.png",
    super.key,
    this.colorBlendMode=BlendMode.srcIn
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    switch (imageType) {
      case ImageType.svg:
        imageWidget = SvgPicture.asset(
          imageSrc,
          color: imageColor,
          height: size ?? height,
          width: size ?? width,
          fit: fill,
        );
        break;

      case ImageType.networkSvg:
        imageWidget = SvgPicture.network(
          imageSrc,
          color: imageColor,
          height: size ?? height,
          width: size ?? width,
          fit: fill,colorBlendMode: colorBlendMode,
        );
        break;

      case ImageType.png:
      case ImageType.asset:
        imageWidget = ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Image.asset(
            imageSrc,
            color: imageColor,
            height: size ?? height,
            width: size ?? width,
            fit: fill,
            errorBuilder: (context, error, stackTrace) {
              if (kDebugMode) {
                print("Asset image load error: $error");
              }
              return _buildFallback();
            },
          ),
        );
        break;

      case ImageType.file:
        imageWidget = ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Image.file(
            File(imageSrc),
            color: imageColor,
            height: size ?? height,
            width: size ?? width,
            fit: fill,
            errorBuilder: (context, error, stackTrace) {
              if (kDebugMode) {
                print("File image load error: $error");
              }
              return _buildFallback();
            },
          ),
        );
        break;

      case ImageType.network:
        if (imageSrc.trim().isEmpty || !Uri.tryParse(imageSrc)!.hasAbsolutePath == true) {
          if (kDebugMode) {
            print("Invalid or empty image URL: '$imageSrc'");
          }
          imageWidget = _buildFallback();
        } else {
          imageWidget = CachedNetworkImage(
            height: size ?? height,
            width: size ?? width,
            imageUrl: imageSrc,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                image: DecorationImage(
                  image: imageProvider,
                  fit: fill,
                ),
              ),
            ),
            progressIndicatorBuilder: (context, url, downloadProgress) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: size ?? height,
                  width: size ?? width,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                ),
              );
            },
            errorWidget: (context, url, error) {
              if (kDebugMode) {
                print("Network image error: $error");
              }
              return _buildFallback();
            },
          );
        }
        break;

    }

    return SizedBox(
      height: size ?? height,
      width: size ?? width,
      child: imageWidget,
    );
  }

  Widget _buildFallback() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.asset(
        defaultImage,
        height: size ?? height,
        width: size ?? width,
        fit: fill,
        errorBuilder: (context, error, stackTrace) {
          if (kDebugMode) {
            print("Fallback image also failed: $error");
          }
          return Container(
            height: size ?? height,
            width: size ?? width,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
          );
        },
      ),
    );
  }
}

