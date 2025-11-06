import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:intl/intl.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_url.dart';
import '../../../../utils/styles.dart';

class EventSpecificSection extends StatelessWidget {
  final TextEditingController addressSearchController;
  final DateTime? startDate;
  final DateTime? endDate;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final String title;
  final Function(BuildContext, bool) selectDate;
  final Function(BuildContext, bool) selectTime;

  const EventSpecificSection({
    super.key,
    required this.addressSearchController,
    required this.startDate,
    required this.title,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.selectDate,
    required this.selectTime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Address & Map
        Text(title, style: styleForBoldText),
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
            border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primary), borderRadius: BorderRadius.circular(12)),
            hintStyle: styleForNormalText,
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primary), borderRadius: BorderRadius.circular(12)),
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
        const SizedBox(height: 10),
        Text(
    AppString.geolocation,
          style: styleForBoldText.copyWith(fontSize: 16, color: AppColors.primary),
        ),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: () async {
            // Placeholder for geolocation logic
          },
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xffeff0f1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary)
            ),
            child: ListTile(
              leading: Icon(Icons.location_on, color: AppColors.primary),
              trailing: const Icon(Icons.keyboard_arrow_right),
              title:  Text(AppString.location),
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Event Details
        Text(AppString.eventDetails, style: styleForBoldText),
        const SizedBox(height: 10),
        Text(
          AppString.eventType,
          style: styleForBoldText.copyWith(fontSize: 16, color: AppColors.primary),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: AppString.publicEvent,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.primary)
            ),
          ),
          items: ['Public Event', 'Private Event']
              .map((item) => DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          ))
              .toList(),
          onChanged: (value) {},
        ),
        const SizedBox(height: 10),

        // Start Date
        Text(
          AppString.startDate,
          style: styleForBoldText.copyWith(fontSize: 16, color: AppColors.primary),
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: () => selectDate(context, true),

          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  startDate != null
                      ? DateFormat('yyyy-MM-dd').format(startDate!)
                      : AppString.selectDate,
                  style: styleForNormalText,
                ),
                const Icon(Icons.timer_outlined),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),

        // End Date
        Text(
          AppString.endDate,
          style: styleForBoldText.copyWith(fontSize: 16, color: AppColors.primary),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => selectDate(context, false),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  endDate != null
                      ? DateFormat('yyyy-MM-dd').format(endDate!)
                      : AppString.selectDate,
                  style: styleForNormalText,
                ),
                const Icon(Icons.timer_outlined),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Start Time
        Text(
          AppString.startTime,
          style: styleForBoldText.copyWith(fontSize: 16, color: AppColors.primary),
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: () => selectTime(context, true),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  startTime != null ? startTime!.format(context) : AppString.selectTime,
                  style: styleForNormalText,
                ),
                const Icon(Icons.timer_outlined),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),

        // End Time
        Text(
          AppString.endTime,
          style: styleForBoldText.copyWith(fontSize: 16, color: AppColors.primary),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => selectTime(context, false),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  endTime != null ? endTime!.format(context) : AppString.selectTime,
                  style: styleForNormalText,
                ),
                const Icon(Icons.timer_outlined),
              ],
            ),
          ),
        ),
      ],
    );
  }
}