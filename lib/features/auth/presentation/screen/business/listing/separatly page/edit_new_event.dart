// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:io';

import 'package:event_ease/core/helper/other_helper.dart';
import 'package:event_ease/features/auth/presentation/screen/business/listing/api/create_bussiness_controller.dart';
import 'package:event_ease/features/auth/presentation/screen/business/listing/api/edit_controller.dart';
import 'package:event_ease/features/auth/presentation/screen/business/listing/api/my_events_model.dart';
import 'package:event_ease/features/auth/presentation/screen/business/listing/separatly%20page/widget.dart';
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/utils/app_url.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_button.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:event_ease/features/auth/presentation/widgets/regular/Custom_description_Text_field.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EditEvent extends StatefulWidget {
  EditEvent({super.key, required this.data});
  MyEventModel data;

  @override
  State<EditEvent> createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  final TextEditingController eventTitleController = TextEditingController();
  final TextEditingController eventShortDescriptionController =
      TextEditingController();
  final TextEditingController eventDetailedDescriptionController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController bookingAndPaymentLink = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressSearchController = TextEditingController();
       final EditBusinessEventJobController
                  businessCreateController = Get.put(
                    EditBusinessEventJobController(),
                  );
  bool promotionUploaded = false;
  bool galleryUploaded = false;
  bool coverImage = false;
  bool logoUploaded = false;

  final CreateController eventCreateController = Get.put(CreateController());

  final List<String> dayNames = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  final List<Map<String, String>> faqList = [
    {'question': '', 'answer': ''},
  ];
  final List<TextEditingController> questionControllers = [
    TextEditingController(),
  ];
  final List<TextEditingController> answerControllers = [
    TextEditingController(),
  ];

  TimeOfDay? startTime;
  TimeOfDay? endTime;
  String selectedPriceRange = '';
  int? selectedEventTypeIndex;
  int? selectedAdditionalServiceIndex;
  int guestCount = 3;
  final TextEditingController maxCountController = TextEditingController();

  String? selectedCatagory;

  String logoImagePath = '';
  String coverImagePath = '';
  String promotionImagePath = '';
  List<String> galleryImagePath = [];
  final TextEditingController entranceFee = TextEditingController();
  final TextEditingController additionalNote = TextEditingController();

  TimeOfDay parseTimeOfDay(String timeString) {
    // Clean the string
    final cleanString = (timeString.split(' ').first).split(":");
    int hour = int.tryParse(cleanString.first) ?? 00;
    int minute = int.tryParse(cleanString.last) ?? 00;
    // dateTime.hour already gives 24-hour format, but if you want manual check:
    // if (cleanString.toUpperCase().contains('PM') && hour < 12) hour += 12;
    // if (cleanString.toUpperCase().contains('AM') && hour == 12) hour = 0;
    return TimeOfDay(hour: hour, minute: minute);
  }


List<String> deletedGalleryImages = [];

  @override
  void initState() {
    super.initState();

    eventTitleController.text = widget.data.name;
    eventShortDescriptionController.text = widget.data.description;
    eventDetailedDescriptionController.text = widget.data.detailDescription;
    emailController.text = widget.data.email;
    phoneController.text = widget.data.phoneNumber;
    bookingAndPaymentLink.text = widget.data.bookingAndPaymentLink;

    addressSearchController.text = widget.data.address;

    // Max Guest Count
    maxCountController.text = widget.data.maxParticipants.toString();

    // Gallery
    galleryImagePath = List<String>.from(widget.data.gallery);
    galleryUploaded = galleryImagePath.isNotEmpty;

    // Logo & Cover
    logoImagePath = widget.data.logo;
    logoUploaded = logoImagePath.isNotEmpty;

    coverImagePath = widget.data.coverImage;
    coverImage = coverImagePath.isNotEmpty;

    // Promotions
    promotionImagePath =
        widget.data.promotions.isNotEmpty
            ? widget.data.promotions.first.toString()
            : "";
    promotionUploaded = promotionImagePath.isNotEmpty;

    maxCountController.text = widget.data.maxParticipants.toString();
    entranceFee.text = widget.data.entranceFee.toString();

    additionalNote.text = widget.data.additionalNotes;
    if (widget.data.startTime.isNotEmpty)
      startTime = parseTimeOfDay(widget.data.startTime);
    if (widget.data.endTime.isNotEmpty)
      endTime = parseTimeOfDay(widget.data.endTime);
    // FAQ
    selectedLat = widget.data.location.coordinates[1];
    selectedLng = widget.data.location.coordinates[0];
    faqList.clear();
    questionControllers.clear();
    answerControllers.clear();
    for (var faq in widget.data.faq) {
      faqList.add({'question': faq.question, 'answer': faq.answer});
      questionControllers.add(TextEditingController(text: faq.question));
      answerControllers.add(TextEditingController(text: faq.answer));
    }
  }

  double? selectedLat;
  double? selectedLng;

  String? selectedAddress;

  Future<Map<String, double>?> showLocationPickerDialog(
    BuildContext context,
  ) async {
    LatLng initialPosition = LatLng(
      selectedLat ?? 23.8103,
      selectedLng ?? 90.4125,
    ); // Default location (Dhaka)
    Position? currentPosition;

    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.denied &&
          permission != LocationPermission.deniedForever) {
        currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        initialPosition = LatLng(
          currentPosition.latitude,
          currentPosition.longitude,
        );
      }
    } catch (_) {}

    return await showDialog<Map<String, double>>(
      context: context,
      builder: (BuildContext context) {
        LatLng selectedPosition = initialPosition;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: SizedBox(
                width: double.maxFinite,
                height: 400,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: initialPosition,
                    zoom: 14,
                  ),
                  onTap: (LatLng pos) {
                    setState(() {
                      selectedPosition = pos;
                    });
                  },
                  markers: {
                    Marker(
                      markerId: const MarkerId("selected"),
                      position: selectedPosition,
                      draggable: true,
                      onDragEnd: (pos) {
                        setState(() {
                          selectedPosition = pos;
                        });
                      },
                    ),
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, {
                      "lat": selectedPosition.latitude,
                      "lng": selectedPosition.longitude,
                    });
                  },
                  child: const Text("Select"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<String?> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      return pickedFile.path;
    } else {
      return null; // User cancelled
    }
  }

  void pickLogoImage() async {
    final path = await pickImageFromGallery();
    if (path != null) {
      logoImagePath = path;
      setState(() {
        logoUploaded = true;
      });
      print('Logo path: $logoImagePath');
    }
  }

  void pickPromotionalImage() async {
    final path = await pickImageFromGallery();
    if (path != null) {
      promotionImagePath = path;
      setState(() {
        promotionUploaded = true;
      });
      print('Logo path: $promotionImagePath');
    }
  }

  void pickCoverImage() async {
    final path = await pickImageFromGallery();
    if (path != null) {
      coverImagePath = path;
      coverImage = true;
      setState(() {});
      print('Cover path: $coverImagePath');
    }
  }

void pickGalleryImage() async {
  final ImagePicker picker = ImagePicker();
  final List<XFile>? pickedFiles = await picker.pickMultiImage();

  if (pickedFiles != null && pickedFiles.isNotEmpty) {
    setState(() {
      galleryImagePath.addAll(pickedFiles.map((file) => file.path));
      galleryUploaded = galleryImagePath.isNotEmpty;
    });
    print('Gallery images: $galleryImagePath');
  }
}


  void addFAQField() {
    setState(() {
      faqList.add({'question': '', 'answer': ''});
      questionControllers.add(TextEditingController());
      answerControllers.add(TextEditingController());
    });
  }

  void deleteFAQField(int index) {
    setState(() {
      faqList.removeAt(index);
      questionControllers.removeAt(index);
      answerControllers.removeAt(index);
    });
  }

  DateTime? startDate;
  DateTime? endDate;

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

  Future<void> _selectDate(BuildContext context, bool isStartTime) async {
    final DateTime pickedDate = await OtherHelper.selectDate(
      context,
      DateTime.now(),
    );
    setState(() {
      if (isStartTime) {
        startDate = pickedDate;
      } else {
        endDate = pickedDate;
      }
    });
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return "";
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat.jm().format(dt); // e.g., 10:00 AM
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Edit Event",
          style: styleForBoldText.copyWith(fontSize: 22),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppString.stepGeneralInformation,
                    style: styleForBoldText.copyWith(fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    AppString.eventName,
                    style: styleForBoldText.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  CustomTextField(
                    hintText: AppString.eventTitle,
                    isSuffix: false,
                    controller: eventTitleController,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    AppString.shortDescription,
                    style: styleForBoldText.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  CustomDescriptionTextField(
                    hintText: AppString.shortDescription,
                    controller: eventShortDescriptionController,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    AppString.detailedDescription,
                    style: styleForBoldText.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  CustomDescriptionTextField(
                    hintText: AppString.detailedDescription,
                    controller: eventDetailedDescriptionController,
                  ),
                ],
              ),
              const SizedBox(height: 10),

              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("2. ${AppString.image}", style: styleForBoldText),
                    const SizedBox(height: 10),

              // Logo Picker
                      ReusableImagePicker(
                        title: AppString.logo,
                        isUploaded: logoImagePath.isNotEmpty,

                        filePaths: [logoImagePath],
                        onTap: () async {
                          final path = await pickImageFromGallery();
                          if (path != null)
                            setState(() => logoImagePath = path);
                        },
                        onRemove: (path) {
                          logoImagePath="";
                          setState(() {
                            logoUploaded = false;
                          });
                        },
                      ),

                      // Cover Picker
                      ReusableImagePicker(
                        title: "${AppString.coverImage} *",
                        isUploaded: coverImagePath.isNotEmpty,
                        filePaths: [coverImagePath],
                        onTap: () async {
                          final path = await pickImageFromGallery();
                          if (path != null)
                            setState(() => coverImagePath = path);
                        },
                        onRemove: (path) => setState(() {
                          coverImagePath="";
                          coverImage = false;
                        }),
                      ),

                    // Gallery Picker
                  ReusableImagePicker(
  title: AppString.imageGallery,
  isGallery: true,
  isUploaded: galleryUploaded,
  filePaths: galleryImagePath,
  onTap: pickGalleryImage,
  onRemove: (path) {
    
    setState(() {
      galleryImagePath.remove(path);
      galleryUploaded = galleryImagePath.isNotEmpty; // Keep state in sync
        
        deletedGalleryImages.add(path); // Track deleted images for backend
      
    });
  },
),

                  ],
                ),
              ),

              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "3. ${AppString.contactInformation}",
                    style: styleForBoldText,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${AppString.email}',
                    style: styleForBoldText.copyWith(
                      fontSize: 16,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 5),
                  CustomTextField(
                    hintText: AppString.email,
                    isSuffix: false,
                    controller: emailController,
                    validator: (value) => OtherHelper.validator(value),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${AppString.phoneNumber}',
                    style: styleForBoldText.copyWith(
                      fontSize: 16,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 5),
                  CustomTextField(
                    hintText: AppString.phoneNumber,
                    isSuffix: false,
                    keyboardType: TextInputType.phone,
                    controller: phoneController,
                    validator: (value) => OtherHelper.validator(value),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    AppString.website,
                    style: styleForBoldText.copyWith(
                      fontSize: 16,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 5),
                  CustomTextField(
                    hintText: AppString.website,
                    isSuffix: false,
                    controller: bookingAndPaymentLink,
                  ),
                ],
              ),
              const SizedBox(height: 10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Address & Map
                  Text(AppString.location, style: styleForBoldText),
                  const SizedBox(height: 4),
                  Text(
                    AppString.fullAddress,
                    style: styleForBoldText.copyWith(
                      fontSize: 16,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 5),
                  GooglePlaceAutoCompleteTextField(
                    textEditingController: addressSearchController,
                    googleAPIKey: AppUrl.googleMapPlaceKey,
                    inputDecoration: InputDecoration(
                      hintText: AppString.searchLocation,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primary),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintStyle: styleForNormalText,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primary),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    debounceTime: 800,

                    isLatLngRequired: true,
                    getPlaceDetailWithLatLng: (prediction) {
                      selectedLat = double.tryParse(prediction.lat ?? "0.0");
                      selectedLng = double.tryParse(prediction.lng ?? "0.0");
                    },
                    itemClick: (prediction) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      addressSearchController.text = prediction.description!;
                      addressSearchController
                          .selection = TextSelection.fromPosition(
                        TextPosition(offset: prediction.description!.length),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
        
                  Text(
                    AppString.eventType,
                    style: styleForBoldText.copyWith(
                      fontSize: 16,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: AppString.publicEvent,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                    ),
                    items:
                        ['Public Event', 'Private Event']
                            .map(
                              (item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(item),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedEventTypeIndex =
                            value == 'Public Event' ? 0 : 1; // Example indices
                      });
                    },
                  ),
                  const SizedBox(height: 10),

                  // Start Date
                  Text(
                    AppString.startDate,
                    style: styleForBoldText.copyWith(
                      fontSize: 16,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () => _selectDate(context, true),

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
                    style: styleForBoldText.copyWith(
                      fontSize: 16,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => _selectDate(context, false),
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
                    style: styleForBoldText.copyWith(
                      fontSize: 16,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () => _selectTime(context, true),
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
                            startTime != null
                                ? startTime!.format(context)
                                : AppString.selectTime,
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
                    style: styleForBoldText.copyWith(
                      fontSize: 16,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => _selectTime(context, false),
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
                            endTime != null
                                ? endTime!.format(context)
                                : AppString.selectTime,
                            style: styleForNormalText,
                          ),
                          const Icon(Icons.timer_outlined),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    "7.Additional Options",
                    style: styleForBoldText.copyWith(fontSize: 20),
                  ),
                  Text(
                    "Maximum Participants",
                    style: styleForBoldText.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 5),

                  CustomTextField(
                    hintText: "e,g., 100",
                    isSuffix: false,
                    controller: maxCountController,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Entrance Fee (€)",
                    style: styleForBoldText.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  CustomDescriptionTextField(
                    hintText: "e,g. 25",
                    controller: entranceFee,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Additional Notes",
                    style: styleForBoldText.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  CustomDescriptionTextField(
                    hintText: "Additional Notes",
                    controller: additionalNote,
                  ),
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Step 8: ${AppString.addFaq}", style: styleForBoldText),
                  const SizedBox(height: 10),
                  ...List.generate(faqList.length, (index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Question field
                        Text(
                          'Question ${index + 1}',
                          style: styleForBoldText.copyWith(
                            fontSize: 14,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 10),
                        CustomTextField(
                          hintText: 'Add Question',
                          isSuffix: false,
                          controller: questionControllers[index],
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a question';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Answer field
                        Text(
                          'Answer ${index + 1}',
                          style: styleForBoldText.copyWith(
                            fontSize: 14,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 10),
                        CustomTextField(
                          maxLine: 4,
                          hintText: 'Answer',
                          isSuffix: false,
                          controller: answerControllers[index],
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter an answer';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),

                        // Delete button for each FAQ field
                        if (faqList.length > 1)
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => deleteFAQField(index),
                            ),
                          ),

                        const SizedBox(height: 20),
                      ],
                    );
                  }),

                  InkWell(
                    onTap: addFAQField,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.primary,
                      ),
                      padding: EdgeInsets.all(10),
                      child: Text(
                        AppString.addMore,
                        style: styleForBoldText.copyWith(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    "Setp 9: ${AppString.promotions}",
                    style: styleForBoldText,
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: ReusableImagePicker(
                        title: AppString.promotions,
                        isUploaded: promotionImagePath.isNotEmpty,
                        filePaths: [promotionImagePath],

                        onTap: pickPromotionalImage,
                        onRemove: (path) {
                          promotionImagePath = "";
                          setState(() {
                            promotionUploaded = false;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              // Publish Button
              Obx(
                 () {
                  return CustomButton(
                    text: AppString.save,
                    isLoading: businessCreateController.isLoading.value,
                    borderRadius: 16,
                    onTap: () async {
                            
                  
                               
                  
                      final Map<String, dynamic> data = {};
                  
                      // Helper to add non-empty text fields
                      void addIfNotEmpty(
                        String key,
                        TextEditingController controller,
                      ) {
                        if (controller.text.trim().isNotEmpty) {
                          data[key] = controller.text.trim();
                        }
                      }
                  
                      // Helper to add int values
                      void addIntIfValid(String key, String text) {
                        final parsed = int.tryParse(text.trim());
                        if (parsed != null) {
                          data[key] = parsed;
                        }
                      }
                  
                      // Add fields conditionally
                      addIfNotEmpty("name", eventTitleController);
                      addIfNotEmpty("description", eventShortDescriptionController);
                      addIfNotEmpty(
                        "detailDescription",
                        eventDetailedDescriptionController,
                      );
                      addIfNotEmpty("phoneNumber", phoneController);
                      addIfNotEmpty("email", emailController);
                      addIfNotEmpty("bookingAndPaymentLink", bookingAndPaymentLink);
                      addIfNotEmpty("address", addressSearchController);
                  
                      data["location"] = {
                        "type": "Point",
                        "coordinates": [selectedLng, selectedLat],
                      };
                  
                      // Optional event type
                      data["type"] =
                          selectedEventTypeIndex == 0
                              ? "public event"
                              : "private event";
                  
                      // Dates and time
                      if (startDate != null)
                        data["startDate"] = startDate!.toIso8601String();
                      if (endDate != null)
                        data["endDate"] = endDate!.toIso8601String();
                      if (startTime != null)
                        data["startTime"] = _formatTime(startTime);
                      if (endTime != null) data["endTime"] = _formatTime(endTime);
                  
                      // Add participants and entrance fee
                      addIntIfValid("maxParticipants", maxCountController.text);
                      data["entranceFee"] =
                          entranceFee.text; // Or make dynamic if needed
                  
                      // Add FAQ list if not empty
                      final faqList =
                          List.generate(questionControllers.length, (index) {
                            final q = questionControllers[index].text.trim();
                            final a = answerControllers[index].text.trim();
                            if (q.isNotEmpty && a.isNotEmpty) {
                              return {"question": q, "answer": a};
                            }
                            return null;
                          }).whereType<Map<String, String>>().toList();
                  
                  
                  if (deletedGalleryImages.isNotEmpty) {
                    data["deleteGallery"] = deletedGalleryImages;
                  }
                  
                  
                      if (faqList.isNotEmpty) {
                        data["faq"] = faqList;
                      }
                  
                  
                  
                  
                      // Final body map
                      final Map<String, String> body = {"data": jsonEncode(data)};
                  
                      // 🟢 Make API call
                      await businessCreateController.editEvent(
                        body,
                        id: widget.data.id,
                        coverLogo: coverImagePath,
                        businessLogo: logoImagePath,
                        promotionLogo: promotionImagePath, // optional
                        galleryLogo: galleryImagePath.map((e) => File(e)).toList(),
                      );
                    },
                  );
                }
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
