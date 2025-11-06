import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import '../../../../../../../core/helper/other_helper.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_url.dart';
import '../../../../utils/styles.dart';
import '../../../custom_text_field.dart';

class BusinessSpecificSection extends StatefulWidget {
  final TextEditingController facebookController;
  final TextEditingController instagramController;
  final TextEditingController twitterController;
  final TextEditingController tiktokController;
  final List<bool> selectedDays;
  final List<String> dayNames;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final Function(BuildContext, bool) selectTime;
  final TextEditingController addressSearchController;
  final List<bool> selectedEventTypes;
  final List<bool> selectedAdditionalServices;
  final String selectedPriceRange;
  final int selectedGuestCapacity;
  final Function(int, bool?) handleEventTypeChange;
  final Function(int, bool?) handleAdditionalServiceChange;
  final Function(String) handlePriceRangeChange;
  final Function(int?) handleGuestCapacityChange;

  const BusinessSpecificSection({
    super.key,
    required this.facebookController,
    required this.instagramController,
    required this.tiktokController,
    required this.selectedDays,
    required this.dayNames,
    required this.twitterController,
    required this.startTime,
    required this.endTime,
    required this.selectTime,
    required this.addressSearchController,
    required this.selectedEventTypes,
    required this.selectedAdditionalServices,
    required this.selectedPriceRange,
    required this.selectedGuestCapacity,
    required this.handleEventTypeChange,
    required this.handleAdditionalServiceChange,
    required this.handlePriceRangeChange,
    required this.handleGuestCapacityChange,
  });

  @override
  State<BusinessSpecificSection> createState() => _BusinessSpecificSectionState();
}

class _BusinessSpecificSectionState extends State<BusinessSpecificSection> {

  TimeOfDay? startTime;
  TimeOfDay? endTime;
  String selectedPriceRange = '';
  int? selectedEventTypeIndex;
  int? selectedAdditionalServiceIndex;
  int guestCount = 3;
  final TextEditingController maxCountController = TextEditingController(text: '200');
  TextEditingController addressSearchController = TextEditingController();

  void handlePriceRangeChange(String value) {
    setState(() {
      selectedPriceRange = value;
    });
  }

  void incrementGuestCount() {
    setState(() {
      guestCount++;
      maxCountController.text = guestCount.toString();
    });
  }

  void decrementGuestCount() {
    setState(() {
      if (guestCount > 0) {
        guestCount--;
        maxCountController.text = guestCount.toString();
      }
    });
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {

    final TimeOfDay picked = await OtherHelper.pickTime(
      context,
      TimeOfDay.now(),
    );
    setState(() {
      if (isStartTime) {
        startTime = picked;
      } else {
        endTime = picked;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Social Networks
        Text(AppString.socialNetworks, style: styleForBoldText),
        const SizedBox(height: 10),
        Text(
          AppString.facebook,
          style: styleForBoldText.copyWith(fontSize: 16, color: AppColors.primary),
        ),
        const SizedBox(height: 5),
        CustomTextField(
          hintText: AppString.facebook,
          isSuffix: false,
          controller: widget.facebookController,
        ),
        const SizedBox(height: 10),
        Text(
          AppString.instagram,
          style: styleForBoldText.copyWith(fontSize: 16, color: AppColors.primary),
        ),
        const SizedBox(height: 5),
        CustomTextField(
          hintText: AppString.instagram,
          isSuffix: false,
          controller: widget.instagramController,
        ),     const SizedBox(height: 10),
        Text(
          AppString.twitter,
          style: styleForBoldText.copyWith(fontSize: 16, color: AppColors.primary),
        ),
        const SizedBox(height: 5),
        CustomTextField(
          hintText: AppString.twitter,
          isSuffix: false,
          controller: widget.twitterController,
        ),
   
        const SizedBox(height: 10),
        Text(
          AppString.tikTok,
          style: styleForBoldText.copyWith(fontSize: 16, color: AppColors.primary),
        ),
        const SizedBox(height: 5),
        CustomTextField(
          hintText: AppString.tikTok,
          isSuffix: false,
          controller: widget.tiktokController,
        ),
        const SizedBox(height: 10),

        // Business Hours
        Text(AppString.businessHours, style: styleForBoldText),
        const SizedBox(height: 16),
        Text(
          AppString.daysOfWeek,
          style: styleForBoldText.copyWith(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Column(
          children: List.generate(widget.dayNames.length, (index) {
            return CheckboxListTile(
              title: Text(
                widget.dayNames[index],
                style: styleForBoldText.copyWith(fontSize: 14, color: AppColors.darkGrey),
              ),
              value: widget.selectedDays[index],
              onChanged: (value) {
                setState(() {
                  widget.selectedDays[index] = value!;
                });
              },
            );
          }),
        ),
        const SizedBox(height: 16),
        Text(
          AppString.startTime,
          style: styleForBoldText.copyWith(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectTime(context, true),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary),
              borderRadius: BorderRadius.circular(12),
              color: AppColors.textFieldBg,
            ),
            child: Text(
              startTime != null
                  ? startTime!.format(context)
                  : AppString.selectTime,
              style: styleForNormalText.copyWith(
                fontSize: 14,
                color: AppColors.grey,
              ),
            ),
          ),
        ),

        SizedBox(height: 15),
        Text(
          AppString.endTime,
          style: styleForBoldText.copyWith(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectTime(context, false),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary),
              borderRadius: BorderRadius.circular(12),
              color: AppColors.textFieldBg,
            ),
            child: Text(
              endTime != null
                  ? endTime!.format(context)
                  : AppString.selectTime,
              style: styleForNormalText.copyWith(
                fontSize: 14,
                color: AppColors.grey,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Address & Map
        Text(AppString.addressMap, style: styleForBoldText),
        const SizedBox(height: 4),
        Text(
          AppString.address,
          style: styleForBoldText.copyWith(
            fontSize: 16,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 10),
        GooglePlaceAutoCompleteTextField(
          textEditingController: addressSearchController,
          googleAPIKey: AppUrl.googleMapPlaceKey,
          containerVerticalPadding: 4,
focusNode: FocusNode(),
          inputDecoration: InputDecoration(
            border: OutlineInputBorder(borderSide: BorderSide.none),
            hintText: AppString.searchLocation,
            fillColor: AppColors.textFieldBg,
            filled: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 15),
          ),
          debounceTime: 800,
          boxDecoration: BoxDecoration(
              border: Border.all(color: AppColors.primary),
              borderRadius: BorderRadius.circular(12),
              color: AppColors.textFieldBg
          ),
          
          isLatLngRequired: true,
          getPlaceDetailWithLatLng: (prediction) {},
          itemClick: (prediction) {
            addressSearchController.text = prediction.description!;
            // searchController.text = prediction.description!;
            addressSearchController.selection = TextSelection.fromPosition(
              TextPosition(offset: prediction.description!.length),
            );
          },
        ),
        const SizedBox(height: 15),
        // Short Description Field
        Text(
          AppString.geolocation,
          style: styleForBoldText.copyWith(
            fontSize: 16,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 10),
        GestureDetector(
          onTap: () async {
            // Map data = await Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) =>
            //         CreateEventScreenMap(), // Show the LocationScreen
            //   ),
            // );
            // controller.selectedAddress = data['address'];
            // setState(() {});
            // controller.latitude.value = data['lat'];
            // controller.longitude.value = data['lng'];
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.textFieldBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary),
            ),
            child: ListTile(
              leading: Icon(Icons.location_on, color: AppColors.primary),
              trailing: Icon(Icons.keyboard_arrow_right),
              // title: controller.selectedAddress.isEmpty
              //     ? Text("Location")
              //     : CommonText(text: controller.selectedAddress, textAlign: TextAlign.start,),
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Services & Details
        Text(AppString.servicesDetails, style: styleForBoldText),
        const SizedBox(height: 10),
        Text(AppString.providerType,
            style: styleForBoldText.copyWith(fontSize: 16, color: AppColors.primary)),
        const SizedBox(height: 10),

        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            fillColor: AppColors.textFieldBg,
            filled: true,
            hintText: AppString.providerType,
            hintStyle: styleForNormalText.copyWith(fontSize: 14),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.primary)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.primary),
            ),
          ),
          items: ['Agriculture', 'Technology', 'Services', 'Retail']
              .map((item) => DropdownMenuItem<String>(
            value: item,
            child: Text(item, style: styleForNormalText.copyWith(fontSize: 14),),
          ))
              .toList(),
          onChanged: (value) {},
        ),

        const SizedBox(height: 20),
        Text(AppString.supportedEventTypes,
            style: styleForBoldText.copyWith(fontSize: 18, color: AppColors.primary)),
        ...List.generate(8, (index) {
          return RadioListTile<int>(
            title: Text('Service ${index + 1}', style: styleForNormalText.copyWith(fontSize: 14)),
            value: index,
            groupValue: selectedEventTypeIndex,
            onChanged: (int? value) {
              setState(() {
                selectedEventTypeIndex = value;
              });
            },
          );
        }),
        const SizedBox(height: 10),


        Text(AppString.additionalServices,
            style: styleForBoldText.copyWith(fontSize: 18, color: AppColors.primary)),

        ...List.generate(8, (index) {
          return RadioListTile<int>(
            title: Text('Service ${index + 1}', style: styleForNormalText.copyWith(fontSize: 14)),
            value: index,
            groupValue: selectedAdditionalServiceIndex,
            onChanged: (int? value) {
              setState(() {
                selectedAdditionalServiceIndex = value;
              });
            },
          );
        }),



        const SizedBox(height: 10),

        Text(AppString.priceRange,
            style: styleForBoldText.copyWith(fontSize: 18, color: AppColors.primary)),
        SizedBox(
          height: 10,
        ),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ChoiceChip(
                label: Text('€ - Budget'),
                selected: selectedPriceRange == '€ - Budget',
                onSelected: (selected) {
                  handlePriceRangeChange(selected ? '€ - Budget' : '');
                },
                checkmarkColor: Colors.white,
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(
                    color: selectedPriceRange == '€ - Budget' ? Colors.white : Colors.black),
                backgroundColor: Colors.white,
              ),
              SizedBox(width: 5),
              ChoiceChip(
                label: Text('€€ - Medium'),
                selected: selectedPriceRange == '€€ - Medium',
                onSelected: (selected) {
                  handlePriceRangeChange(selected ? '€€ - Medium' : '');
                },
                checkmarkColor: Colors.white,
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(
                    color: selectedPriceRange == '€€ - Medium' ? Colors.white : Colors.black),
                backgroundColor: Colors.white,
              ),
              SizedBox(width: 5),
              ChoiceChip(
                label: Text('€€€ - High'),
                selected: selectedPriceRange == '€€€ - High',
                onSelected: (selected) {
                  handlePriceRangeChange(selected ? '€€€ - High' : '');
                },
                selectedColor: AppColors.primary,
                checkmarkColor: Colors.white,
                labelStyle: TextStyle(
                    color: selectedPriceRange == '€€€ - High' ? Colors.white : Colors.black),
                backgroundColor: Colors.white,
              ),
              SizedBox(width: 5),
              ChoiceChip(
                label: Text('€€€€ - Luxury'),
                selected: selectedPriceRange == '€€€€ - Luxury',
                onSelected: (selected) {
                  handlePriceRangeChange(selected ? '€€€€ - Luxury' : '');
                },
                checkmarkColor: Colors.white,
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(
                    color: selectedPriceRange == '€€€€ - Luxury' ? Colors.white : Colors.black),
                backgroundColor: Colors.white,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(AppString.maximumGuestCapacity,
            style: styleForBoldText.copyWith(fontSize: 18, color: AppColors.primary)),
        SizedBox(
          height: 10,
        ),
        const SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary),
              borderRadius: BorderRadius.circular(12),
              color: AppColors.textFieldBg
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                guestCount.toString(),
                style: styleForNormalText,
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: decrementGuestCount,
                    icon: Icon(
                      Icons.remove_circle,
                      color: AppColors.primary,
                    ),
                  ),
                  IconButton(
                    onPressed: incrementGuestCount,
                    icon: Icon(
                      Icons.add_circle_outlined,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}