import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_url.dart';
import '../../../../utils/styles.dart';
class JobSpecificSection extends StatelessWidget {
  final TextEditingController addressSearchController;

  const JobSpecificSection({
    super.key,
    required this.addressSearchController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppString.addressMap, style: styleForBoldText),
        const SizedBox(height: 4),
        Text(
          AppString.fullAddress,
          style: styleForBoldText.copyWith(fontSize: 16, color: AppColors.primary),
        ),
        const SizedBox(height: 5),
        GooglePlaceAutoCompleteTextField(
          textEditingController: addressSearchController,
          googleAPIKey: AppUrl.googleMapPlaceKey,focusNode: FocusNode(),
          inputDecoration: InputDecoration(
            hintText: AppString.searchLocation,
            border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          ),
          debounceTime: 800,
          
          isLatLngRequired: true,
          getPlaceDetailWithLatLng: (prediction) {},
          itemClick: (prediction) {
            addressSearchController.text = prediction.description!;
            addressSearchController.selection = TextSelection.fromPosition(
              TextPosition(offset: prediction.description!.length),
            );
          },
        ),
      ],
    );
  }
}