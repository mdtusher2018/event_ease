// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:event_ease/core/helper/other_helper.dart';
import 'package:event_ease/features/auth/presentation/screen/business/listing/api/create_bussiness_controller.dart';

import 'package:event_ease/features/auth/presentation/screen/business/listing/api/edit_controller.dart';
import 'package:event_ease/features/auth/presentation/screen/business/listing/api/my_bussiness_model.dart';
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

class EditNewBusiness extends StatefulWidget {
  EditNewBusiness({super.key, required this.data});
  MyBusinessModel data;

  @override
  State<EditNewBusiness> createState() => _EditNewBusinessState();
}

class _EditNewBusinessState extends State<EditNewBusiness> {
  final TextEditingController businessTitleController = TextEditingController();
  final TextEditingController eventShortDescriptionController =
      TextEditingController();
  final TextEditingController eventDetailedDescriptionController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressSearchController = TextEditingController();
  final TextEditingController instagramController = TextEditingController();
  final TextEditingController facebookController = TextEditingController();
  final TextEditingController tiktokController = TextEditingController();
  final TextEditingController twitterController = TextEditingController();
  final List<bool> selectedDays = List.filled(7, false);
  final EditBusinessEventJobController businessCreateController = Get.put(
    EditBusinessEventJobController(),
  );
  bool promotionUploaded = false;
  bool galleryUploaded = false;
  bool coverImage = false;
  bool logoUploaded = false;
  // final List<String> _eventTypes = [];
  bool _isExpanded = false;
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
  final TextEditingController maxCountController = TextEditingController(
    text: '200',
  );
  bool _isAdditionalExpanded = false;

  final List<String> _additionalServices = [];
  String logoImagePath = '';
  String coverImagePath = '';
  String promotionImagePath = '';
  List<String> galleryImagePath = [];

  double? selectedLat;
  double? selectedLng;
  final SupportedServicesController controller = Get.put(
    SupportedServicesController(),
  );
  String? selectedCatagory;
  TimeOfDay parseTimeOfDay(String timeString) {
    final cleanString = (timeString.split(' ').first).split(":");
    int hour = int.tryParse(cleanString.first) ?? 00;
    int minute = int.tryParse(cleanString.last) ?? 00;
    return TimeOfDay(hour: hour, minute: minute);
  }

  final CreateController eventCreateController = Get.put(CreateController());

  List<String> deletedGalleryImages = [];

  @override
  void initState() {
    super.initState();

    initPostCall();

    businessTitleController.text = widget.data.name;
    eventShortDescriptionController.text = widget.data.description;
    eventDetailedDescriptionController.text = widget.data.detailDescription;
    emailController.text = widget.data.email;
    phoneController.text = widget.data.phoneNumber;
    websiteController.text = widget.data.website;
    phoneController.text = widget.data.phoneNumber;
    facebookController.text = widget.data.socialLinks.facebook;
    instagramController.text = widget.data.socialLinks.instagram;
    twitterController.text = widget.data.socialLinks.twitter;
    tiktokController.text = widget.data.socialLinks.tiktok;
  
    
    addressSearchController.text = widget.data.address;
    if (widget.data.availabilities.startTime.isNotEmpty)
      startTime = parseTimeOfDay(widget.data.availabilities.startTime);
    if (widget.data.availabilities.endTime.isNotEmpty)
      endTime = parseTimeOfDay(widget.data.availabilities.endTime);

    selectedLng = widget.data.location.coordinates.first;
    selectedLat = widget.data.location.coordinates.last;

    // Availability
    selectedDays.setAll(
      0,
      dayNames
          .map((day) => widget.data.availabilities.day.contains(day))
          .toList(),
    );

    log(startTime.toString());

    // Price Range
    selectedPriceRange = widget.data.priceRange;

    // Max Guest Count
    maxCountController.text = widget.data.maxGuest.toString();

    // Gallery
    galleryImagePath = List<String>.from(widget.data.gallery);
    galleryUploaded = galleryImagePath.isNotEmpty;

    // Logo & Cover
    logoImagePath = widget.data.logo;
    logoUploaded = logoImagePath.isNotEmpty;

    coverImagePath = widget.data.coverImage;
    coverImage = coverImagePath.isNotEmpty;

    promotionImagePath =
        widget.data.promotionImage.isNotEmpty
            ? widget.data.promotionImage.first.toString()
            : "";

    _additionalServices.clear();
    _additionalServices.addAll(widget.data.additionalServices);


  selectedCatagory = widget.data.providerType.id;


    faqList.clear();
    questionControllers.clear();
    answerControllers.clear();
    for (var faq in widget.data.faq) {
      faqList.add({'question': faq.question, 'answer': faq.answer});
      questionControllers.add(TextEditingController(text: faq.question));
      answerControllers.add(TextEditingController(text: faq.answer));
    }
  }

void initPostCall() async {
  await controller.fetchServices();
  for (var element in controller.services) {
    if (widget.data.supportedServices.contains(element.name)) {
      controller.selectedIds.add(element.id);
    }
  }

  await controller.fetchAdditionalServices();
  for (var element in controller.additionalServices) {
    if (widget.data.additionalServices.contains(element.name)) {
      controller.selectedAdditionalIds.add(element.id);
    }
  }

  // Force refresh GetX observables if needed
  controller.selectedIds.refresh();
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
                    selectedLat = selectedPosition.latitude;
                    selectedLng = selectedPosition.longitude;
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
          "Edit Business",
          style: styleForBoldText.copyWith(fontSize: 22),
        ),
      ),
      body: Obx(() {
        return SingleChildScrollView(
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
                      AppString.businessName,
                      style: styleForBoldText.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    CustomTextField(
                      hintText: AppString.eventTitle,
                      isSuffix: false,
                      controller: businessTitleController,
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
                          logoImagePath = "";
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
                        onRemove:
                            (path) => setState(() {
                              coverImagePath = "";
                              coverImage = false;
                            }),
                      ),

                      ReusableImagePicker(
                        title: AppString.imageGallery,
                        isUploaded: galleryUploaded,
                        isGallery: true,
                        filePaths: galleryImagePath,
                        onTap: pickGalleryImage,
                        onRemove: (path) {
                          setState(() {
                            galleryImagePath.remove(path);
                            galleryUploaded =
                                galleryImagePath
                                    .isNotEmpty; // Keep state in sync
                            log(path);

                            deletedGalleryImages.add(
                              path,
                            ); // Track deleted images for backend
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
                      controller: websiteController,
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Social Networks
                    Text(
                      "Step 4: ${AppString.socialNetworks}",
                      style: styleForBoldText,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      AppString.facebook,
                      style: styleForBoldText.copyWith(
                        fontSize: 16,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 5),
                    CustomTextField(
                      hintText: AppString.facebook,
                      isSuffix: false,
                      controller: facebookController,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      AppString.instagram,
                      style: styleForBoldText.copyWith(
                        fontSize: 16,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 5),
                    CustomTextField(
                      hintText: AppString.instagram,
                      isSuffix: false,
                      controller: instagramController,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      AppString.twitter,
                      style: styleForBoldText.copyWith(
                        fontSize: 16,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 5),
                    CustomTextField(
                      hintText: AppString.twitter,
                      isSuffix: false,
                      controller: twitterController,
                    ),

                    const SizedBox(height: 10),
                    Text(
                      AppString.tikTok,
                      style: styleForBoldText.copyWith(
                        fontSize: 16,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 5),
                    CustomTextField(
                      hintText: AppString.tikTok,
                      isSuffix: false,
                      controller: tiktokController,
                    ),
                    const SizedBox(height: 10),

                    // Business Hours
                    Text(
                      "Step 5: ${AppString.businessHours}",
                      style: styleForBoldText,
                    ),
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
                      children: List.generate(dayNames.length, (index) {
                        return CheckboxListTile(
                          title: Text(
                            dayNames[index],
                            style: styleForBoldText.copyWith(
                              fontSize: 14,
                              color: AppColors.darkGrey,
                            ),
                          ),
                          value: selectedDays[index],
                          onChanged: (value) {
                            setState(() {
                              selectedDays[index] = value!;
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
                    Text(
                      "Step 6: ${AppString.address}",
                      style: styleForBoldText,
                    ),
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
                        color: AppColors.textFieldBg,
                      ),

                      isLatLngRequired: true,
                      getPlaceDetailWithLatLng: (prediction) {
                        selectedLat = double.tryParse(prediction.lat ?? "0.0");
                        selectedLng = double.tryParse(prediction.lng ?? "0.0");
                        log("$selectedLat................selected lat");
                        log("$selectedLng................selected lng");
                      },
                      itemClick: (prediction) {
                        addressSearchController.text = prediction.description!;
                        // searchController.text = prediction.description!;
                        addressSearchController
                            .selection = TextSelection.fromPosition(
                          TextPosition(offset: prediction.description!.length),
                        );
                      },
                    ),

                    Text(
                      "Setp 7: ${AppString.servicesDetails}",
                      style: styleForBoldText,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      AppString.providerType,
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
                          eventCreateController.businessCategories
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

                    const SizedBox(height: 20),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16),
                        Text(
                          "Supported Events",
                          style: styleForBoldText.copyWith(fontSize: 20),
                        ),
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
                    ),

                    const SizedBox(height: 10),

                    Text(
                      AppString.priceRange,
                      style: styleForBoldText.copyWith(
                        fontSize: 18,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 10),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ChoiceChip(
                            label: Text('€ - Budget'),
                            selected: selectedPriceRange == '€ - Budget',
                            onSelected: (selected) {
                              handlePriceRangeChange(
                                selected ? '€ - Budget' : '',
                              );
                            },
                            checkmarkColor: Colors.white,
                            selectedColor: AppColors.primary,
                            labelStyle: TextStyle(
                              color:
                                  selectedPriceRange == '€ - Budget'
                                      ? Colors.white
                                      : Colors.black,
                            ),
                            backgroundColor: Colors.white,
                          ),
                          SizedBox(width: 5),
                          ChoiceChip(
                            label: Text('€€ - Medium'),
                            selected: selectedPriceRange == '€€ - Medium',
                            onSelected: (selected) {
                              handlePriceRangeChange(
                                selected ? '€€ - Medium' : '',
                              );
                            },
                            checkmarkColor: Colors.white,
                            selectedColor: AppColors.primary,
                            labelStyle: TextStyle(
                              color:
                                  selectedPriceRange == '€€ - Medium'
                                      ? Colors.white
                                      : Colors.black,
                            ),
                            backgroundColor: Colors.white,
                          ),
                          SizedBox(width: 5),
                          ChoiceChip(
                            label: Text('€€€ - High'),
                            selected: selectedPriceRange == '€€€ - High',
                            onSelected: (selected) {
                              handlePriceRangeChange(
                                selected ? '€€€ - High' : '',
                              );
                            },
                            selectedColor: AppColors.primary,
                            checkmarkColor: Colors.white,
                            labelStyle: TextStyle(
                              color:
                                  selectedPriceRange == '€€€ - High'
                                      ? Colors.white
                                      : Colors.black,
                            ),
                            backgroundColor: Colors.white,
                          ),
                          SizedBox(width: 5),
                          ChoiceChip(
                            label: Text('€€€€ - Luxury'),
                            selected: selectedPriceRange == '€€€€ - Luxury',
                            onSelected: (selected) {
                              handlePriceRangeChange(
                                selected ? '€€€€ - Luxury' : '',
                              );
                            },
                            checkmarkColor: Colors.white,
                            selectedColor: AppColors.primary,
                            labelStyle: TextStyle(
                              color:
                                  selectedPriceRange == '€€€€ - Luxury'
                                      ? Colors.white
                                      : Colors.black,
                            ),
                            backgroundColor: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      AppString.maximumGuestCapacity,
                      style: styleForBoldText.copyWith(
                        fontSize: 18,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 10),
                    const SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primary),
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.textFieldBg,
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
                ),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Step 8: ${AppString.addFaq}",
                      style: styleForBoldText,
                    ),
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
                // Publish Button
                Obx(() {
                  return CustomButton(
                    text: AppString.save,
                    isLoading: businessCreateController.isLoading.value,
                    borderRadius: 16,
                    onTap: () async {
                      void showError(String message) {
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

                      if (logoImagePath.isEmpty) {
                        showError('Logo Image is required');
                        return;
                      }
                      if (coverImagePath.isEmpty) {
                        showError('Cover Image is required');
                        return;
                      }

                      if (addressSearchController.text.trim().isEmpty ||
                          selectedLat == null ||
                          selectedLng == null) {
                        showError('Valid Address is required');
                        return;
                      }

                      // if (selectedCatagory == null) {
                      //   showError('Please select a Category');
                      //   return;
                      // }

                      // if (controller.selectedIds.isEmpty) {
                      //   showError('Please select at least one Supported Event');
                      //   return;
                      // }

                      // if (controller.selectedAdditionalIds.isEmpty) {
                      //   showError(
                      //     'Please select at least one Additional Service',
                      //   );
                      //   return;
                      // }

                      final Map<String, dynamic> data = {};

                      // Add string fields if not empty
                      void addIfNotEmpty(
                        String key,
                        TextEditingController controller,
                      ) {
                        if (controller.text.trim().isNotEmpty) {
                          data[key] = controller.text.trim();
                        }
                      }

                      // Add social links only if at least one is not empty
                      final socialLinks = {
                        "facebook": facebookController.text.trim(),
                        "instagram": instagramController.text.trim(),
                        "twitter": twitterController.text.trim(),
                        "tiktok": tiktokController.text.trim(),
                      };
                      if (socialLinks.values.any((v) => v.isNotEmpty)) {
                        data["socialLinks"] =
                            socialLinks..removeWhere((k, v) => v.isEmpty);
                      }

                      // Add availability if times and days are valid
                      final days = _getSelectedDays();
                      if (days.isNotEmpty &&
                          startTime != null &&
                          endTime != null) {
                        data["availabilities"] = {
                          "day": days,
                          "startTime": _formatTime(startTime),
                          "endTime": _formatTime(endTime),
                        };
                      }

                      // Apply checks for each individual field
                      addIfNotEmpty("name", businessTitleController);
                      addIfNotEmpty(
                        "shortDescription",
                        eventShortDescriptionController,
                      );
                      addIfNotEmpty(
                        "description",
                        eventDetailedDescriptionController,
                      );
                      addIfNotEmpty("email", emailController);
                      addIfNotEmpty("phoneNumber", phoneController);
                      addIfNotEmpty("website", websiteController);
                      addIfNotEmpty("address", addressSearchController);

                    if(selectedLng!=null && selectedLat!=null) {
                      data["location"] = {
                        "type": "Point",
                        "coordinates": [selectedLng, selectedLat],
                      };
                    }
                     if(controller.selectedAdditionalIds.isNotEmpty) {
                       data["additionalServices"] =
                          controller.selectedAdditionalIds
                              .map(
                                (id) =>
                                    controller.additionalServices
                                        .firstWhere(
                                          (service) => service.id == id,
                                        )
                                        .name,
                              )
                              .toList();
                     }
                    if(controller.selectedIds.isNotEmpty) {
                      data["supportedServices"] =
                          controller.selectedIds
                              .map(
                                (id) =>
                                    controller.services
                                        .firstWhere(
                                          (service) => service.id == id,
                                        )
                                        .name,
                              )
                              .toList();
                    }

                      if (selectedPriceRange.isNotEmpty &&
                          selectedPriceRange.contains(' - ')) {
                        data["priceRange"] =
                            selectedPriceRange.split(' - ').last.toLowerCase();
                      }

                      // maxGuest
                      if (maxCountController.text.trim().isNotEmpty) {
                        final parsed = int.tryParse(
                          maxCountController.text.trim(),
                        );
                        if (parsed != null) data["maxGuest"] = parsed;
                      }

                      final faqList =
                          List.generate(questionControllers.length, (index) {
                            final question =
                                questionControllers[index].text.trim();
                            final answer = answerControllers[index].text.trim();
                            if (question.isNotEmpty && answer.isNotEmpty) {
                              return {"question": question, "answer": answer};
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
                      final Map<String, String> body = {
                        "data": jsonEncode(data),
                      };

                      // API call
                      await businessCreateController.editBusiness(
                        body,
                        id: widget.data.id,
                        coverLogo: coverImagePath,
                        businessLogo: logoImagePath,
                        promotionLogo: promotionImagePath, // optional
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
        );
      }),
    );
  }

  List<String> _getSelectedDays() {
    return List.generate(
      dayNames.length,
      (index) => selectedDays[index] ? dayNames[index] : null,
    ).whereType<String>().toList();
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return '';
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? "AM" : "PM";
    return "${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $period";
  }
}
