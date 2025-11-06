import 'package:event_ease/features/auth/presentation/utils/app_url.dart';

String getFullImagePath(String imagePath) {
  if (imagePath.startsWith('http')) {
    return imagePath;
  }
  if (imagePath.startsWith('/')) {
    return '${AppUrl.baseImageUrl}$imagePath';
  }
  return '${AppUrl.baseImageUrl}/$imagePath';
}
