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

class CreateNewBusiness extends StatefulWidget {
  const CreateNewBusiness({super.key});

  @override
  State<CreateNewBusiness> createState() => _CreateNewBusinessState();
}

class _CreateNewBusinessState extends State<CreateNewBusiness> {
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
  bool promotionUploaded = false;
  bool galleryUploaded = false;
  bool coverImage = false;
  bool logoUploaded = false;
  bool _isExpanded = false;

  String logoImagePath = '';
  String coverImagePath = '';
  String promotionImagePath = '';
  List<String> galleryImagePath = [];
  final SupportedServicesController controller = Get.put(
    SupportedServicesController(),
  );
      final CreateController businessCreateController = Get.put(
                        CreateController(),
                      );
  String? selectedAddress;

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


  final List<String> dayNames = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];
  final CreateController eventCreateController = Get.put(CreateController());
  String? selectedCatagory;
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
  int guestCount = 1;
  final TextEditingController maxCountController = TextEditingController();

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

  double? selectedLat;
  double? selectedLng;
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

  bool _isAdditionalExpanded = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Create New Business",
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
                    "${AppString.website} (Optional)",
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Address & Map
                      Text("6. ${AppString.location}", style: styleForBoldText),
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
                        // focusNode: FocusNode(),
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
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                        ),
                        debounceTime: 800,

                        isLatLngRequired: true,
                        getPlaceDetailWithLatLng: (prediction) {
                          selectedLat = double.tryParse(
                            prediction.lat ?? "0.0",
                          );
                          selectedLng = double.tryParse(
                            prediction.lng ?? "0.0",
                          );
                          log("$selectedLat................selected lat");
                          log("$selectedLng................selected lng");
                        },
                        itemClick: (prediction) {
                          addressSearchController.text =
                              prediction.description!;

                          addressSearchController
                              .selection = TextSelection.fromPosition(
                            TextPosition(
                              offset: prediction.description!.length,
                            ),
                          );
                        },
                      ),

                      // const SizedBox(height: 10),
                      // Text(
                      //   AppString.geolocation,
                      //   style: styleForBoldText.copyWith(
                      //     fontSize: 16,
                      //     color: AppColors.primary,
                      //   ),
                      // ),
                      // const SizedBox(height: 5),
                      // GestureDetector(
                      //   onTap: () async {
                      //     final result = await showLocationPickerDialog(
                      //       context,
                      //     );
                      //     if (result != null) {
                      //       selectedLat = result["lat"];
                      //       selectedLng = result["lng"];
                      //       // ✅ Convert lat/lng to address
                      //       List<Placemark> placemarks =
                      //           await placemarkFromCoordinates(
                      //             selectedLat!,
                      //             selectedLng!,
                      //           );
                      //       if (placemarks.isNotEmpty) {
                      //         final place = placemarks.first;
                      //         selectedAddress =
                      //             "${place.name}, ${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
                      //       }
                      //       setState(() {});
                      //       debugPrint(
                      //         "User picked location: $selectedAddress",
                      //       );
                      //     }
                      //   },
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //       color: const Color(0xffeff0f1),
                      //       borderRadius: BorderRadius.circular(12),
                      //       border: Border.all(color: AppColors.primary),
                      //     ),
                      //     child: ListTile(
                      //       leading: Icon(
                      //         Icons.location_on,
                      //         color: AppColors.primary,
                      //       ),
                      //       trailing: const Icon(Icons.keyboard_arrow_right),
                      //       title:
                      //           (selectedAddress != null)
                      //               ? Text(selectedAddress!)
                      //               : Text("Geolocation (Required)"),
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(height: 10),

                      // Event Details
                    ],
                  ),

                  // Services & Details
                  Text(
                    "Setp 7: ${AppString.servicesDetails}",
                    style: styleForBoldText,
                  ),
                  const SizedBox(height: 10),

                  Obx(() {
                    if (eventCreateController.businessCategories.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                        const SizedBox(height: 10),
                      ],
                    );
                  }),

                  Obx(
                     () {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // SizedBox(height: 16),
                          // Text(
                          //   "Supported Events",
                          //   style: styleForBoldText.copyWith(fontSize: 20),
                          // ),
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
                                      AppString.supportedServiceTypes,
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
                    }
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
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primary),
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.textFieldBg,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(guestCount.toString(), style: styleForNormalText),
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
              // Publish Button
              Obx(
                 () {
                  return CustomButton(
                    text: AppString.publishBusiness,
                    borderRadius: 16,
                    isLoading: businessCreateController.isLoading.value,
                    onTap: () async {
                      
                      // void showError(String message) {
                      //   Get.snackbar(
                      //     'Missing Field',
                      //     message,
                      //     snackPosition: SnackPosition.TOP,
                      //     backgroundColor: Colors.redAccent,
                      //     colorText: Colors.white,
                      //   );
                      // }
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
                  
                      // Validate required fields
                      if (businessTitleController.text.trim().isEmpty) {
                        showError('Business Title is required');
                        return;
                      }
                  
                      if (eventShortDescriptionController.text.trim().isEmpty) {
                        showError('Short Description is required');
                        return;
                      }
                  
                      if (eventDetailedDescriptionController.text.trim().isEmpty) {
                        showError('Detailed Description is required');
                        return;
                      }
                      if (coverImagePath.isEmpty) {
                        showError("Please add a cover image");
                        return;
                      }
                  
                      if (logoImagePath.isEmpty) {
                        showError("Please add a business logo");
                        return;
                      }
                  
                      if (galleryImagePath.isEmpty) {
                        showError("Please add at least one gallery image");
                        return;
                      }
                      if (emailController.text.trim().isEmpty) {
                        showError('Email is required');
                        return;
                      }
                      if (phoneController.text.trim().isEmpty) {
                        showError('Phone is required');
                        return;
                      }
                  
                      if (addressSearchController.text.trim().isEmpty) {
                        showError('Address is required');
                        return;
                      }
                  
                      if (selectedPriceRange.isEmpty) {
                        showError('Please select a price range');
                        return;
                      }
                  
                      if (_getSelectedDays().isEmpty) {
                        showError('Please select at least one operating day');
                        return;
                      }
                  
                      if (startTime == null) {
                        showError('Start time is required');
                        return;
                      }
                  
                      if (endTime == null) {
                        showError('End time is required');
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
                        showError("Please add at least one question & answer.");
                        return;
                      }
                  
                
                  
                      final Map<String, String> body = {
                        "data": jsonEncode({
                          "name": businessTitleController.text.trim(),
                          "shortDescription":
                              eventShortDescriptionController.text.trim(),
                          "description":
                              eventDetailedDescriptionController.text.trim(),
                          "email": emailController.text.trim(),
                          "phoneNumber": phoneController.text.trim(),
                          "website": websiteController.text.trim(),
                          "socialLinks": {
                            "facebook": facebookController.text.trim(),
                            "instagram": instagramController.text.trim(),
                            "twitter": twitterController.text.trim(),
                            "tiktok": tiktokController.text.trim(),
                          },
                          "availabilities": {
                            "day": _getSelectedDays(),
                            "startTime": _formatTime(startTime),
                            "endTime": _formatTime(endTime),
                          },
                          "address": addressSearchController.text.trim(),
                          "longitude": selectedLng,
                          "latitude": selectedLat,
                          "providerType": selectedCatagory,
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
                  
                          "priceRange":
                              selectedPriceRange.split(' - ').last.toLowerCase(),
                  
                          "maxGuest":
                              int.tryParse(maxCountController.text) ?? guestCount,
                          "faq": List.generate(
                            questionControllers.length,
                            (index) => {
                              "question": questionControllers[index].text.trim(),
                              "answer": answerControllers[index].text.trim(),
                            },
                          ),
                        }),
                      };
                      await businessCreateController.createCompleteBusiness(
                        body,
                        coverLogo: coverImagePath,
                        businessLogo: logoImagePath,
                        promotionLogo: promotionImagePath, // if you have a path
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
