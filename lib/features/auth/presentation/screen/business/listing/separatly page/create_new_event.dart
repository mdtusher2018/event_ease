import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:event_ease/core/helper/other_helper.dart';
import 'package:event_ease/features/auth/presentation/screen/business/listing/api/create_bussiness_controller.dart';
import 'package:event_ease/features/auth/presentation/screen/business/listing/api/service_controller.dart';
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

class CreateNewEvent extends StatefulWidget {
  const CreateNewEvent({super.key});

  @override
  State<CreateNewEvent> createState() => _CreateNewEventState();
}

class _CreateNewEventState extends State<CreateNewEvent> {
  final TextEditingController eventTitleController = TextEditingController();
  final TextEditingController eventShortDescriptionController =
      TextEditingController();
  final TextEditingController eventDetailedDescriptionController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController book_and_payment_link_controller =
      TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressSearchController = TextEditingController();
  final TextEditingController instagramController = TextEditingController();
  final TextEditingController facebookController = TextEditingController();
  final TextEditingController tiktokController = TextEditingController();
  final TextEditingController twitterController = TextEditingController();
  final List<bool> selectedDays = List.filled(7, false);
  bool promotionUploaded = false;
  bool galleryUploaded = false;
  bool coverImage = false;
  bool logoUploaded = false;
  final TextEditingController maxParticipants = TextEditingController();
  final TextEditingController entranceFee = TextEditingController();
  final TextEditingController additionalNote = TextEditingController();
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
  String? selectedCatagory;
  String? selectedBusiness;
  int? selectedAdditionalServiceIndex;
  int guestCount = 3;

  double? selectedLat;
  double? selectedLng;

  String logoImagePath = '';
  String coverImagePath = '';
  String promotionImagePath = '';
  List<String> galleryImagePath = [];

  final SupportedServicesController controller = Get.put(
    SupportedServicesController(),
  );

  bool _isExpanded = false;
  bool _isAdditionalExpanded = false;

  final CreateController eventCreateController = Get.put(CreateController());

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

  String? selectedAddress;

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

  Future<Map<String, double>?> showLocationPickerDialog(
    BuildContext context,
  ) async {
    LatLng initialPosition = LatLng(
      selectedLat ?? 23.8103,
      selectedLng ?? 90.4125,
    ); // Default location (Dhaka)
    Position? currentPosition;
    GoogleMapController? mapController;
    TextEditingController searchController = TextEditingController();

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
                height: 450,
                child: Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: initialPosition,
                        zoom: 14,
                      ),
                      onMapCreated: (controller) {
                        mapController = controller;
                      },
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

                    /// Search Bar on Top
                    Positioned(
                      top: 10,
                      left: 10,
                      right: 10,
                      child: Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(8),
                        child: GooglePlaceAutoCompleteTextField(
                          textEditingController: searchController,
                          googleAPIKey: AppUrl.googleMapPlaceKey,
                          debounceTime: 800,
                          isLatLngRequired: true,
                          inputDecoration: const InputDecoration(
                            hintText: "Search location...",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                          ),
                          getPlaceDetailWithLatLng: (prediction) async {
                            final lat = double.parse(prediction.lat!);
                            final lng = double.parse(prediction.lng!);

                            setState(() {
                              selectedPosition = LatLng(lat, lng);
                            });

                            // Move map to searched position
                            if (mapController != null) {
                              mapController!.animateCamera(
                                CameraUpdate.newLatLngZoom(
                                  LatLng(lat, lng),
                                  15,
                                ),
                              );
                            }
                          },
                          itemClick: (prediction) {
                            FocusScope.of(context).unfocus();
                            searchController.text = prediction.description!;
                          },
                        ),
                      ),
                    ),
                  ],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Create New Event",
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

              
                         ReusableImagePicker(
                      title: "${AppString.logo} *",
                      isUploaded: logoUploaded,
                      filePaths: [logoImagePath],
                      onTap: () async {
                        final path = await pickImageFromGallery();
                        if (path != null) {
                          setState(() { 
                          logoImagePath = path;
                        logoUploaded = true;
                        }
                        );
                        }

                      },
                      onRemove: (path) {
                        logoImagePath="";
                        setState(() {
                          logoUploaded=false;
                        });
                      },
                    ),

                    ReusableImagePicker(
                      title: "${AppString.coverImage} *",
                      isUploaded: coverImage,
                      filePaths: [coverImagePath],
                      onTap: () async {
                        final path = await pickImageFromGallery();
                        if (path != null) {
                          setState(() { coverImagePath = path;
                        coverImage = true;
                        });
                        }
                      },
                      onRemove: (path) {
                        coverImagePath="";
                        setState(() {
                          coverImage=false;
                        });
                      },
                    ),


                    
         ReusableImagePicker(
  title: AppString.imageGallery,
  isUploaded: galleryUploaded,
  isGallery: true,
  filePaths: galleryImagePath,
  onTap: pickGalleryImage, // call the method below
  onRemove: (path) {
    setState(() {
      galleryImagePath.remove(path);
      galleryUploaded = galleryImagePath.isNotEmpty;

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
                    AppString.email,
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
                    AppString.phoneNumber,
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
                    "Booking & Payment Link",
                    style: styleForBoldText.copyWith(
                      fontSize: 16,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 5),
                  CustomTextField(
                    hintText: AppString.link,
                    isSuffix: false,
                    controller: book_and_payment_link_controller,
                  ),
                ],
              ),
              const SizedBox(height: 10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Address & Map
                  Text("4. ${AppString.location}", style: styleForBoldText),
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
                    focusNode: FocusNode(),
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
                      log("${selectedLat}................selected lat");
                      log("${selectedLng}................selected lng");
                    },
                    itemClick: (prediction) {
                      addressSearchController.text = prediction.description!;
                      addressSearchController
                          .selection = TextSelection.fromPosition(
                        TextPosition(offset: prediction.description!.length),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("5. ${AppString.eventDetails}", style: styleForBoldText),

                  Obx(() {
                    if (eventCreateController.eventCategories.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Event Category".tr,
                          style: styleForBoldText.copyWith(
                            fontSize: 16,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: AppString.category,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: AppColors.primary),
                            ),
                          ),
                          value: selectedCatagory,
                          items:
                              eventCreateController.eventCategories
                                  .map(
                                    (category) => DropdownMenuItem<String>(
                                      value: category.id,
                                      child: Text(
                                        category.name.replaceAll(
                                          RegExp(r'\s+'),
                                          ' ',
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCatagory = value;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  }),

                  Obx(() {
                    if (eventCreateController.myBusinesses.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Select Business".tr,
                          style: styleForBoldText.copyWith(
                            fontSize: 16,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: "Business",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: AppColors.primary),
                            ),
                          ),
                          value:
                              selectedBusiness, // <- make sure to declare `String? selectedBusiness;`
                          items:
                              eventCreateController.myBusinesses
                                  .map(
                                    (business) => DropdownMenuItem<String>(
                                      value: business.id,
                                      child: Text(
                                        business.name.replaceAll(
                                          RegExp(r'\s+'),
                                          ' ',
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedBusiness = value;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  }),

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

              Obx(() {
                if (controller.services.isNotEmpty ||
                    controller.additionalServices.isNotEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      Text(
                        "Supported Events",
                        style: styleForBoldText.copyWith(fontSize: 20),
                      ),
                      if (controller.services.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Theme(
                              data: Theme.of(
                                context,
                              ).copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                tilePadding: EdgeInsets.zero,
                                title: Text(
                                  AppString.supportedEventTypes,
                                  style: styleForBoldText.copyWith(
                                    fontSize: 18,
                                    color: AppColors.primary,
                                  ),
                                ),
                                initiallyExpanded: _isExpanded,
                                onExpansionChanged: (expanded) {
                                  setState(() {
                                    _isExpanded = expanded;
                                  });
                                },
                                children:
                                    controller.services.map((service) {
                                      return Obx(() {
                                        return Row(
                                          children: [
                                            Checkbox(
                                              value: controller.selectedIds
                                                  .contains(service.id),
                                              onChanged: (val) {
                                                controller.toggleSelection(
                                                  service.id,
                                                );
                                              },
                                            ),
                                            Expanded(child: Text(service.name)),
                                          ],
                                        );
                                      });
                                    }).toList(),
                              ),
                            ),
                          ],
                        ),

                      if (controller.additionalServices.isNotEmpty)
                        Theme(
                          data: Theme.of(
                            context,
                          ).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            tilePadding: EdgeInsets.zero,
                            title: Text(
                              AppString.additionalServices,
                              style: styleForBoldText.copyWith(
                                fontSize: 18,
                                color: AppColors.primary,
                              ),
                            ),
                            initiallyExpanded: _isAdditionalExpanded,
                            onExpansionChanged: (expanded) {
                              setState(() {
                                _isAdditionalExpanded = expanded;
                              });
                            },
                            children:
                                controller.additionalServices.map((service) {
                                  return Obx(() {
                                    return Row(
                                      children: [
                                        Checkbox(
                                          value: controller
                                              .selectedAdditionalIds
                                              .contains(service.id),
                                          onChanged: (_) {
                                            controller
                                                .toggleAdditionalSelection(
                                                  service.id,
                                                );
                                          },
                                        ),
                                        Expanded(
                                          child: Text(
                                            service.name.replaceAll("\n", " "),
                                          ),
                                        ),
                                      ],
                                    );
                                  });
                                }).toList(),
                          ),
                        ),
                    ],
                  );
                } else {
                  return SizedBox();
                }
              }),

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
                    controller: maxParticipants,
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

              const SizedBox(height: 20),

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
                      isUploaded: promotionUploaded,
                      filePaths: [promotionImagePath],
                      onTap: pickPromotionalImage,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              // Publish Button
              Obx(() {
                return CustomButton(
                  text: "Publish Event".tr,
                  isLoading: eventCreateController.isLoading.value,
                  borderRadius: 16,
                  onTap: () async {
                    void showMissingField(String message) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(message),
                          backgroundColor: Colors.redAccent,
                          behavior:
                              SnackBarBehavior
                                  .floating, // makes it float instead of attaching at bottom
                        ),
                      );
                    }

                    // Step 1: Validate required fields one by one
                    if (eventTitleController.text.trim().isEmpty) {
                      showMissingField('Please enter the event title.');
                      return;
                    }

                    if (eventShortDescriptionController.text.trim().isEmpty) {
                      showMissingField('Please enter a short description.');
                      return;
                    }

                    if (eventDetailedDescriptionController.text
                        .trim()
                        .isEmpty) {
                      showMissingField('Please enter a detailed description.');
                      return;
                    }
                    if (coverImagePath.isEmpty) {
                      showMissingField("Please add a cover image");
                      return;
                    }

                    if (logoImagePath.isEmpty) {
                      showMissingField("Please add a business logo");
                      return;
                    }

                    if (galleryImagePath.isEmpty) {
                      showMissingField("Please add at least one gallery image");
                      return;
                    }

                    if (addressSearchController.text.trim().isEmpty) {
                      showMissingField('Please enter the event address.');
                      return;
                    }

                    if (emailController.text.trim().isEmpty) {
                      showMissingField('Please enter your email.');
                      return;
                    }
                    if (phoneController.text.trim().isEmpty) {
                      showMissingField('Please enter your phone number.');
                      return;
                    }
                    if (selectedCatagory == null) {
                      showMissingField('Please select a Category.');
                      return;
                    }
                    if (startDate == null) {
                      showMissingField('Please select a start date.');
                      return;
                    }

                    if (endDate == null) {
                      showMissingField('Please select an end date.');
                      return;
                    }

                    if (startTime == null) {
                      showMissingField('Please select a start time.');
                      return;
                    }

                    if (endTime == null) {
                      showMissingField('Please select an end time.');
                      return;
                    }

                    if (maxParticipants.text.trim().isEmpty) {
                      showMissingField(
                        'Please enter the maximum number of participants.',
                      );
                      return;
                    }
                    if (entranceFee.text.isEmpty) {
                      showMissingField('Please enter Entrance Fee.');
                      return;
                    }

                    final faqs =
                        List.generate(
                              questionControllers.length,
                              (index) => {
                                "question":
                                    questionControllers[index].text.trim(),
                                "answer": answerControllers[index].text.trim(),
                              },
                            )
                            .where(
                              (faq) =>
                                  faq["question"]!.isNotEmpty &&
                                  faq["answer"]!.isNotEmpty,
                            )
                            .toList();

                    if (faqs.isEmpty) {
                      showMissingField(
                        "Please add at least one question & answer.",
                      );
                      return;
                    }

                    final Map<String, String> body = {
                      "data": jsonEncode({
                        "name": eventTitleController.text.trim(),
                        "description":
                            eventShortDescriptionController.text.trim(),
                        "detailDescription":
                            eventDetailedDescriptionController.text.trim(),
                        "phoneNumber": phoneController.text.trim(),
                        "email": emailController.text.trim(),
                        "bookingAndPaymentLink":
                            book_and_payment_link_controller.text.trim(),
                        "address": addressSearchController.text.trim(),
                        "location": {
                          "type": "Point",
                          "coordinates": [selectedLng, selectedLat],
                        },
                        "category":
                            eventCreateController.eventCategories
                                .firstWhere(
                                  (element) => element.id == selectedCatagory,
                                )
                                .name,
                        "businessId":
                            eventCreateController.myBusinesses
                                .firstWhere(
                                  (element) => element.id == selectedBusiness,
                                )
                                .id,

                        "additionalNotes": additionalNote.text.trim(),
                        "type":
                            selectedEventTypeIndex == 0
                                ? "public event"
                                : "private event", // Replace dynamically if needed
                        "startDate": startDate?.toIso8601String(),
                        "endDate": endDate?.toIso8601String(),
                        "startTime": _formatTime(startTime),
                        "endTime": _formatTime(endTime),
                        "maxParticipants": maxParticipants.text.trim(),
                        "additionalServices":
                            controller.selectedAdditionalIds
                                .map(
                                  (id) =>
                                      controller.additionalServices
                                          .firstWhere(
                                            (service) => service.id == id,
                                          )
                                          .name,
                                )
                                .toList(),
                        "supportedServices":
                            controller.selectedIds
                                .map(
                                  (id) =>
                                      controller.services
                                          .firstWhere(
                                            (service) => service.id == id,
                                          )
                                          .name,
                                )
                                .toList(),

                        "entranceFee": entranceFee.text,

                        "faq": List.generate(
                          questionControllers.length,
                          (index) => {
                            "question": questionControllers[index].text.trim(),
                            "answer": answerControllers[index].text.trim(),
                          },
                        ),
                      }),
                    };

                    await eventCreateController.createEvent(
                      body,
                      coverLogo: coverImagePath,
                      businessLogo: logoImagePath,
                      promotionLogo: promotionImagePath, // if you have a path
                      galleryLogo:
                          galleryImagePath.map((e) => File(e)).toList(),
                    );
                  },
                );
              }),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
