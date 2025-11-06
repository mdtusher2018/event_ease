// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:io';

import 'package:event_ease/core/helper/other_helper.dart';
import 'package:event_ease/features/auth/presentation/screen/business/listing/api/edit_controller.dart';
import 'package:event_ease/features/auth/presentation/screen/business/listing/api/job_model.dart';
import 'package:event_ease/features/auth/presentation/screen/business/listing/separatly%20page/widget.dart';
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/utils/app_url.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_button.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:event_ease/features/auth/presentation/widgets/regular/Custom_description_Text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:image_picker/image_picker.dart';

class EditJob extends StatefulWidget {
  EditJob({super.key, required this.data});
  JobModel data;

  @override
  State<EditJob> createState() => _EditJobState();
}

class _EditJobState extends State<EditJob> {
  final TextEditingController eventTitleController = TextEditingController();
  final TextEditingController eventDetailedDescriptionController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressSearchController = TextEditingController();
  final TextEditingController instagramController = TextEditingController();
  final TextEditingController facebookController = TextEditingController();
  final TextEditingController tiktokController = TextEditingController();
  final TextEditingController twitterController = TextEditingController();
  final EditBusinessEventJobController businessCreateController = Get.put(
    EditBusinessEventJobController(),
  );
  final List<bool> selectedDays = List.filled(7, false);
  bool promotionUploaded = false;
  bool galleryUploaded = false;
  bool coverImage = false;
  bool logoUploaded = false;

  final TextEditingController roleController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController workHourController = TextEditingController();

  String selectedCategory = 'Event Planner';
  String selectedContract = 'Full Time';
  String selectedExperience = 'No Experience';
  String selectedAvailability = 'Immediate';

  final List<String> categories = [
    'Event Planner',
    'Photographer',
    'Developer',
  ];
  final List<String> contracts = ['Full Time', 'Part Time', 'Contract'];
  final List<String> experiences = ['No Experience', '1-2 Years', '3+ Years'];
  final List<String> availability = ['Immediate', '1 Week', '2 Weeks'];

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
  List<String> deletedGalleryImages = [];
  String logoImagePath = '';
  String coverImagePath = '';
  String promotionImagePath = '';
  List<String> galleryImagePath = [];

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

  double? selectedLat;
  double? selectedLng;
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

  @override
  void initState() {
    super.initState();

    final data = widget.data;

    // Basic Info
    eventTitleController.text = data.title;
    eventDetailedDescriptionController.text = data.description;
    emailController.text = data.email;
    phoneController.text = data.phoneNumber;
    addressSearchController.text = data.address;
    selectedLng = data.location.coordinates.first;
    selectedLat = data.location.coordinates.last;
    // Gallery
    galleryImagePath = List<String>.from(data.gallery);
    galleryUploaded = galleryImagePath.isNotEmpty;

    // Logo & Cover
    logoImagePath = data.logo;
    logoUploaded = logoImagePath.isNotEmpty;

    coverImagePath = data.coverImage;
    coverImage = coverImagePath.isNotEmpty;
    promotionUploaded = promotionImagePath.isNotEmpty;

    // Role, Salary, Work Hour
    roleController.text = data.role;
    salaryController.text = data.salery.toString();
    workHourController.text = data.workHour.toString();

    // Dropdowns
    // selectedCategory = data.category;
    selectedContract = mapContractTypeReverse(data.contractType);
    // selectedExperience = data.experience;
    // selectedAvailability = data.availability;

    // FAQ
    faqList.clear();
    questionControllers.clear();
    answerControllers.clear();
    for (var faq in data.faq) {
      final question = faq['question'] ?? '';
      final answer = faq['answer'] ?? '';
      faqList.add({'question': question, 'answer': answer});
      questionControllers.add(TextEditingController(text: question));
      answerControllers.add(TextEditingController(text: answer));
    }

    // If you have time fields saved and want to restore
    // Example: startTime = parseTime(data.startTime);
    // Optional if you store start/end times in job data

    setState(() {});
  }

  String mapContractTypeReverse(String type) {
    switch (type.toLowerCase()) {
      case 'fulltime':
      case 'full time':
        return 'Full Time';
      case 'parttime':
      case 'part time':
        return 'Part Time';
      case 'contract':
        return 'Contract';
      default:
        return 'Full Time';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Edit Job", style: styleForBoldText.copyWith(fontSize: 22)),
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
                          galleryUploaded =
                              galleryImagePath.isNotEmpty; // Keep state in sync

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
                ],
              ),
              const SizedBox(height: 10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Step 4: ${AppString.addressMap}",
                    style: styleForBoldText,
                  ),
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
                      ),
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    debounceTime: 800,

                    isLatLngRequired: true,
                    getPlaceDetailWithLatLng: (prediction) {
                      if (prediction.lat != null && prediction.lng != null) {
                        selectedLat = double.tryParse(prediction.lat!);
                        selectedLng = double.tryParse(prediction.lng!);
                      }
                    },
                    itemClick: (prediction) {
                      addressSearchController.text = prediction.description!;
                      addressSearchController
                          .selection = TextSelection.fromPosition(
                        TextPosition(offset: prediction.description!.length),
                      );
                    },
                  ),
                ],
              ),

              SizedBox(height: 8),
              Column(
                children: [
                  Row(children: [_buildTitle('5. Job Details')]),
                  _buildDropdown(
                    'Job Categories',
                    categories,
                    selectedCategory,
                    (val) {
                      setState(() => selectedCategory = val!);
                    },
                  ),
                  _buildTextField('Job Role', roleController),
                  _buildDropdown('Contract Type', contracts, selectedContract, (
                    val,
                  ) {
                    setState(() => selectedContract = val!);
                  }),
                  _buildTextField(
                    'Salary / Compensation',
                    salaryController,
                    hint: 'Salary',
                  ),
                  _buildDropdown(
                    'Required Experience',
                    experiences,
                    selectedExperience,
                    (val) {
                      setState(() => selectedExperience = val!);
                    },
                  ),
                  _buildDropdown(
                    'Availability Required',
                    availability,
                    selectedAvailability,
                    (val) {
                      setState(() => selectedAvailability = val!);
                    },
                  ),
                  _buildTextField(
                    'Work Hours',
                    workHourController,
                    hint: 'Add Work Hrs',
                  ),
                ],
              ),

              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Step 5: ${AppString.addFaq}",
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
              ),

              const SizedBox(height: 20),
              // Publish Button
              Obx(
                 () {
                  return CustomButton(
                    text: AppString.save,
                    isLoading: businessCreateController.isLoading.value,
                    borderRadius: 16,
                    onTap: () async {
                      String mapContractType(String input) {
                        switch (input.toLowerCase()) {
                          case 'full time':
                            return 'fullTime';
                          case 'part time':
                            return 'partTime';
                          case 'contract':
                            return 'contract'; // If supported
                          default:
                            return 'fullTime'; // fallback
                        }
                      }
                  
                      final Map<String, String> body = {
                        "data": jsonEncode({
                          "title": eventTitleController.text.trim(),
                          "description":
                              eventDetailedDescriptionController.text.trim(),
                          "phoneNumber": phoneController.text.trim(),
                          "email": emailController.text.trim(),
                          "categoryId":
                              "686ca7ecab029a7c9a0d0ba0", // Replace dynamically if needed
                          "category": selectedCategory,
                          "address": addressSearchController.text.trim(),
                          "location": {
                            "type": "Point",
                            "coordinates": [selectedLng, selectedLat],
                          },
                          "deleteGallery": deletedGalleryImages,
                          "role": roleController.text.trim(),
                          "contractType": mapContractType(selectedContract),
                          "salery": int.tryParse(salaryController.text.trim()) ?? 0,
                          "experience": selectedExperience,
                          "availability": selectedAvailability.toLowerCase(),
                          "workHour":
                              int.tryParse(workHourController.text.trim()) ?? 40,
                        }),
                      };
                  
                      await businessCreateController.editJob(
                        body,
                        id: widget.data.id,
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

  Widget _buildTitle(String text) {
    return Text(text, style: styleForBoldText);
  }

  Widget _buildDropdown(
    String label,
    List<String> items,
    String value,
    ValueChanged<String?> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: styleForBoldText.copyWith(
              fontSize: 16,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            decoration: _inputDecoration(),
            value: value,
            items:
                items
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: styleForBoldText.copyWith(
              fontSize: 16,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            decoration: _inputDecoration(hint: hint ?? label),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF6EDFF),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF7926C3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF7926C3), width: 1.5),
      ),
    );
  }
}
