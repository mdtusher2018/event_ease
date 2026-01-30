import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:event_ease/core/helper/other_helper.dart';
import 'package:event_ease/features/auth/presentation/screen/business/listing/api/create_bussiness_controller.dart';
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

class CreateNewJob extends StatefulWidget {
  const CreateNewJob({super.key});

  @override
  State<CreateNewJob> createState() => _CreateNewJobState();
}

class _CreateNewJobState extends State<CreateNewJob> {
  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
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
  String? selectedBusiness;

  final TextEditingController roleController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController workHourController = TextEditingController();

  String? selectedCategory;
  String selectedContract = 'Full Time';
  String selectedExperience = 'No Experience';
  String selectedAvailability = 'immediate';

  final List<String> contracts = ['Full Time', 'Part Time'];
  final List<String> experiences = ['No Experience', '1-2 Years', '3+ Years'];
  final List<String> availability = [
    'immediate',
    '15 days',
    '1 week',
    '1 month',
  ];

  final CreateController jobCreateController = Get.put(CreateController());

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

  String logoImagePath = '';
  String coverImagePath = '';
  String promotionImagePath = '';
  List<String> galleryImagePath = [];

  double? selectedLat;
  double? selectedLng;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Create New Job".tr,
          style: styleForBoldText.copyWith(fontSize: 22),
        ),
      ),
      body: Obx(() {
        if (jobCreateController.isLoading.value ||
            jobCreateController.jobCategories.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }
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
                      "Job Name".tr,
                      style: styleForBoldText.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    CustomTextField(
                      hintText: "Job Title".tr,
                      isSuffix: false,
                      controller: jobTitleController,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      AppString.shortDescription,
                      style: styleForBoldText.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    CustomDescriptionTextField(
                      hintText: AppString.shortDescription,
                      controller: descriptionController,
                    ),
                    const SizedBox(height: 10),
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
                            });
                          }
                        },
                        onRemove: (path) {
                          logoImagePath = "";
                          setState(() {
                            logoUploaded = false;
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
                            setState(() {
                              coverImagePath = path;
                              coverImage = true;
                            });
                          }
                        },
                        onRemove: (path) {
                          coverImagePath = "";
                          setState(() {
                            coverImage = false;
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
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
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

                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Job categories".tr,
                            style: styleForBoldText.copyWith(
                              fontSize: 16,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: AppString.category,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            value: selectedCategory,
                            items:
                                jobCreateController.jobCategories
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
                                selectedCategory = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Obx(() {
                      if (jobCreateController.myBusinesses.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Select business".tr,
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
                                borderSide: BorderSide(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            value:
                                selectedBusiness, // <- make sure to declare `String? selectedBusiness;`
                            items:
                                jobCreateController.myBusinesses
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

                    _buildTextField('Job role'.tr, roleController),
                    _buildDropdown(
                      'Contract type'.tr,
                      contracts,
                      selectedContract,
                      (val) {
                        setState(() => selectedContract = val!);
                      },
                    ),
                    _buildTextField(
                      '${"Salary".tr} / Compensation',
                      salaryController,
                      hint: 'Salary',
                    ),
                    _buildDropdown(
                      'Requered experienxe'.tr,
                      experiences,
                      selectedExperience,
                      (val) {
                        setState(() => selectedExperience = val!);
                      },
                    ),
                    _buildDropdown(
                      'Availabily required'.tr,
                      availability,
                      selectedAvailability,
                      (val) {
                        setState(() => selectedAvailability = val!);
                      },
                    ),
                    _buildTextField(
                      'Work Hours'.tr,
                      workHourController,
                      hint: 'Add Work Hrs'.tr,
                    ),
                  ],
                ),

                SizedBox(height: 16),
                Column(
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
                            '${"Question".tr} ${index + 1}',
                            style: styleForBoldText.copyWith(
                              fontSize: 14,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(height: 10),
                          CustomTextField(
                            hintText: 'Add Question'.tr,
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
                            '${"Answer".tr} ${index + 1}',
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
                // Publish Button
                Obx(() {
                  return CustomButton(
                    text: "Publish Job".tr,
                    isLoading: jobCreateController.isLoading.value,
                    borderRadius: 16,
                    onTap: () async {
                      String mapContractType(String input) {
                        switch (input.toLowerCase()) {
                          case 'full time':
                            return 'fullTime';
                          case 'part time':
                            return 'partTime';
                          default:
                            return 'fullTime';
                        }
                      }

                      _showError(String message) {
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

                      if (jobTitleController.text.trim().isEmpty) {
                        _showError('Job title is required.');
                        return;
                      }

                      if (descriptionController.text.trim().isEmpty) {
                        _showError('Description is required.');
                        return;
                      }
                      if (coverImagePath.isEmpty) {
                        _showError("Please add a cover image");
                        return;
                      }

                      if (logoImagePath.isEmpty) {
                        _showError("Please add a business logo");
                        return;
                      }

                      if (galleryImagePath.isEmpty) {
                        _showError("Please add at least one gallery image");
                        return;
                      }
                      if (phoneController.text.trim().isEmpty) {
                        _showError('Phone number is required.');
                        return;
                      }

                      if (emailController.text.trim().isEmpty) {
                        _showError('Email is required.');
                        return;
                      }

                      if (selectedCategory == null) {
                        _showError('Please select a job category.');
                        return;
                      }

                      if (addressSearchController.text.trim().isEmpty) {
                        _showError('Address is required.');
                        return;
                      }

                      if (roleController.text.trim().isEmpty) {
                        _showError('Role is required.');
                        return;
                      }

                      if (selectedContract.trim().isEmpty) {
                        _showError('Please select a contract type.');
                        return;
                      }

                      if (salaryController.text.trim().isEmpty) {
                        _showError('Salary is required.');
                        return;
                      }

                      // if (selectedLng == null || selectedLat == null) {
                      //   _showError('Please select a location on the map.');
                      //   return;
                      // }

                      if (selectedExperience.trim().isEmpty) {
                        _showError('Please select experience level.');
                        return;
                      }

                      if (selectedAvailability.trim().isEmpty) {
                        _showError('Please select availability.');
                        return;
                      }

                      if (workHourController.text.trim().isEmpty) {
                        _showError('Work hours are required.');
                        return;
                      }
                      final faqs =
                          List.generate(
                                questionControllers.length,
                                (index) => {
                                  "question":
                                      questionControllers[index].text.trim(),
                                  "answer":
                                      answerControllers[index].text.trim(),
                                },
                              )
                              .where(
                                (faq) =>
                                    faq["question"]!.isNotEmpty &&
                                    faq["answer"]!.isNotEmpty,
                              )
                              .toList();

                      if (faqs.isEmpty) {
                        _showError(
                          "Please add at least one question & answer.",
                        );
                        return;
                      }
                      log(selectedCategory!);
                      final tempCategory = jobCreateController.jobCategories
                          .firstWhere((e) => e.id == selectedCategory);

                      final Map<String, String> body = {
                        "data": jsonEncode({
                          "title": jobTitleController.text.trim(),
                          "description": descriptionController.text.trim(),
                          "phoneNumber": phoneController.text.trim(),
                          "email": emailController.text.trim(),
                          "categoryId": selectedCategory,
                          "category": tempCategory.name,
                          "address": addressSearchController.text.trim(),
                          "location": {
                            "type": "Point",
                            "coordinates": [selectedLng, selectedLat],
                          },
                          "businessId":
                              jobCreateController.myBusinesses
                                  .firstWhere(
                                    (element) => element.id == selectedBusiness,
                                  )
                                  .id,
                          "role": roleController.text.trim(),
                          "contractType": mapContractType(selectedContract),
                          "salery":
                              int.tryParse(salaryController.text.trim()) ?? 0,
                          "experience": selectedExperience,
                          "availability": selectedAvailability.toLowerCase(),
                          "workHour":
                              int.tryParse(workHourController.text.trim()) ??
                              40,
                          "faq": List.generate(
                            questionControllers.length,
                            (index) => {
                              "question":
                                  questionControllers[index].text.trim(),
                              "answer": answerControllers[index].text.trim(),
                            },
                          ),
                        }),
                      };

                      await jobCreateController.createJob(
                        body,
                        coverLogo: coverImagePath,
                        businessLogo: logoImagePath,
                        promotionLogo: '', // if you have a path
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
            label.tr,
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
