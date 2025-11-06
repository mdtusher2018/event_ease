import 'package:event_ease/features/auth/presentation/controller/community_controller.dart';
import 'package:event_ease/features/auth/presentation/models/my_model/poll_model.dart';
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_button.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../widgets/regular/Custom_description_Text_field.dart';


class EditPollScreen extends StatefulWidget {
  final PollModel poll;

  const EditPollScreen({super.key, required this.poll});

  @override
  State<EditPollScreen> createState() => _EditPollScreenState();
}

class _EditPollScreenState extends State<EditPollScreen> {
  CommunityController controller = Get.find<CommunityController>();

  final List<String> categories = [
    'EVENT PLANNING',
    'TYPE OF EVENT',
    'INSPIRATION & CREATIVE IDEAS',
    'DECOR & SETUP',
    'GIFTS, FAVORS & GADGETS',
    'FOOD & DRINKS',
    'ENTERTAINMENT & MUSIC',
    'OUTFITS & LOOKS',
    'BEAUTY & WELLNESS',
    'LOCATIONS & SUPPLIERS',
    'QUESTIONS, TIPS & ADVICE',
    'PROBLEMS & LAST-MINUTE ISSUES',
    'POLLS & QUIZZES',
  ];

  final List<String> regions = [
    'Abruzzo',
    'Basilicata',
    'Calabria',
    'Campania',
    'Emilia-Romagna',
    'Friuli-Venezia Giulia',
    'Lazio',
    'Liguria',
    'Lombardia',
    'Marche',
    'Molise',
    'Piemonte',
    'Puglia',
    'Sardegna',
    'Sicilia',
    'Toscana',
    'Trentino-Alto Adige',
    'Umbria',
    'Valle d’Aosta',
    'Veneto',
  ];

  @override
  void initState() {
    super.initState();

    // Pre-fill controllers with existing poll data
    controller.titleController2.text = widget.poll.title;
    controller.eventShortDescriptionController2.text = widget.poll.description;
    controller.selectedCategory2.value = widget.poll.category;
    controller.selectedRegion2.value = widget.poll.region;

    // Clear any old option controllers
    controller.optionControllers.clear();

    // Pre-fill poll options
    for (var option in widget.poll.options) {
      controller.optionControllers.add(TextEditingController(text: option.text));
    }

    // Ensure at least one option is present
    if (controller.optionControllers.isEmpty) {
      controller.optionControllers.add(TextEditingController());
    }
  }

  void _addOption() {
    setState(() {
      controller.optionControllers.add(TextEditingController());
    });
  }

  void _removeOption(int index) {
    if (controller.optionControllers.length > 1) {
      setState(() {
        controller.optionControllers[index].dispose();
        controller.optionControllers.removeAt(index);
      });
    } else {
      Get.snackbar("Error".tr, "At least one option is required.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Edit Poll".tr,
          style: styleForBoldText.copyWith(fontSize: 24.sp),
        ),
      ),
      body: SingleChildScrollView(
        controller: controller.scrollController,
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppString.title,
                style: styleForBoldText.copyWith(
                    color: AppColors.primary, fontSize: 18.sp)),
            SizedBox(height: 10.h),
            CustomTextField(
              hintText: AppString.eventTitle,
              isSuffix: false,
              controller: controller.titleController2,
            ),
            SizedBox(height: 10.h),

            _buildLabel(AppString.category),
            _buildDropdown(
              hint: AppString.category,
              value: controller.selectedCategory2.value,
              items: categories,
              onChanged: (value) {
                if (value != null) controller.selectedCategory2.value = value;
              },
            ),
            SizedBox(height: 12.h),

            _buildLabel("Region"),
            _buildDropdown(
              hint: "Region",
              value: controller.selectedRegion2.value,
              items: regions,
              onChanged: (value) {
                if (value != null) controller.selectedRegion2.value = value;
              },
            ),
            SizedBox(height: 10.h),

            Text(AppString.shortDescription,
                style: styleForBoldText.copyWith(
                    color: AppColors.primary, fontSize: 18.sp)),
            SizedBox(height: 10.h),
            CustomDescriptionTextField(
              hintText: AppString.shortDescription,
              controller: controller.eventShortDescriptionController2,
            ),
            SizedBox(height: 20.h),

            Text("Poll Options",
                style: styleForBoldText.copyWith(
                    color: AppColors.primary, fontSize: 18.sp)),
            SizedBox(height: 10.h),

            ListView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: controller.optionControllers.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Option ${index + 1}",
                                style: styleForBoldText.copyWith(
                                    color: AppColors.primary, fontSize: 18.sp)),
                            SizedBox(height: 6.h),
                            CustomTextField(
                              hintText: "Enter option",
                              isSuffix: false,
                              controller: controller.optionControllers[index],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10.w),
                      if (controller.optionControllers.length > 1)
                        InkWell(
                          onTap: () => _removeOption(index),
                          child: Container(
                            margin: EdgeInsets.only(top: 28.h),
                            padding: EdgeInsets.all(6.w),
                            decoration: BoxDecoration(
                              color: Colors.red.shade300,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close,
                                color: Colors.white, size: 20),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: _addOption,
                icon: Icon(Icons.add, color: AppColors.primary),
                label: Text("Add Option",
                    style: styleForBoldText.copyWith(
                        color: AppColors.primary, fontSize: 16.sp)),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: SafeArea(
          child: Obx(() => CustomButton(
                isLoading: controller.isLoading.value,
                text: "Update Poll",
                borderRadius: 16.r,
                onTap: () {
             controller.editPoll(widget.poll.id);
                },
              )),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text,
        style: styleForBoldText.copyWith(
            color: AppColors.primary, fontSize: 18.sp));
  }

  Widget _buildDropdown({
    required String hint,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value.isEmpty ? null : value,
      decoration: InputDecoration(
        fillColor: AppColors.textFieldBg,
        filled: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      hint: Text(hint,
          style:
              styleForNormalText.copyWith(color: AppColors.grey, fontSize: 14.sp)),
      items: items
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item,
                    style: styleForNormalText.copyWith(
                        color: Colors.black, fontSize: 15.sp)),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}
