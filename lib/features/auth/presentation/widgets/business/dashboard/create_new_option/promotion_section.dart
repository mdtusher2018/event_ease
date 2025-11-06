import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:flutter/material.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/styles.dart';

class PromotionSection extends StatelessWidget {
  final bool promotionUploaded;
  final Function(String) uploadImage;

  const PromotionSection({
    super.key,
    required this.promotionUploaded,
    required this.uploadImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppString.promotions, style: styleForBoldText),
        const SizedBox(height: 16),
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
                  promotionUploaded ? AppString.changeImage : AppString.uploadImage,
                  style: styleForBoldText.copyWith(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}