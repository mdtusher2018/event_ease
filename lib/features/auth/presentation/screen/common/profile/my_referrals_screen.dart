import 'package:event_ease/core/helper/prefs_helper.dart';
import 'package:event_ease/features/auth/presentation/screen/business/dashboard/api/my_business_model.dart';
import 'package:event_ease/features/auth/presentation/screen/business/sponsorship/sponsorship_screen.dart';
import 'package:event_ease/features/auth/presentation/screen/common/profile/pending_request_helper.dart';
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/app_icons.dart';
import 'package:event_ease/features/auth/presentation/widgets/common_image.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/profile/referrals_controller.dart';
import '../../../utils/app_string.dart';
import '../../../utils/styles.dart';

class MyReferralsScreen extends StatelessWidget {
  final ReferralsController controller = Get.find<ReferralsController>();

  MyReferralsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // controller.getReferral();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Text(
          AppString.myReferrals,
          style: styleForBoldText.copyWith(fontSize: 24.sp),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${AppString.friendsInvited} : ",
                      style: styleForNormalText.copyWith(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        height: 1.56.h,
                      ),
                    ),
                    SizedBox(height: 10),
                    Obx(
                      () => Text(
                        controller.invitedFriends.value.toString(),
                        style: styleForNormalText.copyWith(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          height: 1.56.h,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "${AppString.creditEarned} : ",
                      style: styleForNormalText.copyWith(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        height: 1.56.h,
                      ),
                    ),
                    SizedBox(height: 10),
                    Obx(() {
                      final double value =
                          double.tryParse(controller.creditEarned.value) ?? 0.0;
                      return Text(
                        "€${value.toStringAsFixed(1)}", // 👉 1 digit after decimal
                        style: styleForNormalText.copyWith(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      );
                    }),

                    SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: Obx(
                            () => Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 15,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: AppColors.textFieldBg,
                                border: Border.all(
                                  color: AppColors.primary,
                                  width: 2,
                                ),
                              ),
                              child: Text(
                                "${controller.referralCode.value} ",
                                style: styleForNormalText.copyWith(
                                  color: Colors.black,
                                  fontSize: 24.sp,
                                ),
                                maxLines: 1,
                              ),
                            ),
                          ),
                          // CustomTextField(
                          //     hintText: AppString.pianofestaIt, isSuffix: false,
                          //     controller: controller.referralController
                          // )
                        ),
                        SizedBox(width: 5),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              vertical: 20.h,
                              horizontal: 10.w,
                            ),
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            final textToCopy = controller.referralCode.value;
                            if (textToCopy.isNotEmpty) {
                              Clipboard.setData(
                                ClipboardData(text: textToCopy),
                              );
                              Get.snackbar(
                                "Copied",
                                "Referral link copied to clipboard",
                                colorText: Colors.white,
                                backgroundColor: Colors.green,
                              );
                            } else {
                              Get.snackbar(
                                "Error".tr,
                                "Referral link is empty",
                                colorText: Colors.white,
                                backgroundColor: Colors.red,
                              );
                            }
                          },

                          child: Text(
                            AppString.copyLink,
                            style: styleForBoldText.copyWith(
                              color: AppColors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    Obx(() {
                      return Text(
                        (controller.pendingRequests.isNotEmpty)
                            ? "${AppString.pendingrequest} : "
                            : "",
                        style: styleForNormalText.copyWith(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          height: 1.56.h,
                        ),
                      );
                    }),
                    SizedBox(height: 8),
                    Obx(() {
                      return ListView.builder(
                        itemCount: controller.pendingRequests.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(12),
                        itemBuilder: (context, index) {
                          final req = controller.pendingRequests[index];
                          return buildRequestCard(req);
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),

            CustomButton(
              text: AppString.useCredit,
              borderRadius: 12,
              onTap: () {
                if (PrefsHelper.myRole == "organizer") {
                  Get.back();

                  Get.to(SponsorshipScreen());
                  return;
                }
                showUseCreditDialog(context, controller);
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void showUseCreditDialog(
    BuildContext context,
    ReferralsController controller,
  ) {
    showDialog(
      context: context,

      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 10,
          backgroundColor: Colors.white,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.75,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.useCredit,
                      style: styleForBoldText.copyWith(
                        fontSize: 20,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      AppString.selectAmount,
                      style: styleForNormalText.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: controller.amountController,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        hintText: "Enter amount".tr,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.primary),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Max 15 €",
                      style: styleForBoldText.copyWith(
                        fontSize: 14,
                        color: AppColors.darkGrey,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      AppString.selectSupplier,
                      style: styleForNormalText.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Obx(
                      () => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primary),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Autocomplete<BusinessNameModel>(
                          displayStringForOption:
                              (option) => option.name, // display name
                          initialValue: TextEditingValue(
                            text: controller.selectedSupplier.value,
                          ),
                          optionsBuilder: (textEditingValue) {
                            if (textEditingValue.text.isEmpty) {
                              return controller.suppliers;
                            } else {
                              return controller.suppliers.where(
                                (supplier) =>
                                    supplier.name.toLowerCase().contains(
                                      textEditingValue.text.toLowerCase(),
                                    ),
                              );
                            }
                          },
                          onSelected: (selection) {
                            controller.selectedSupplier.value = selection.name;
                            controller.selectedSupplierId.value = selection.id;
                          },
                          fieldViewBuilder: (
                            context,
                            textController,
                            focusNode,
                            onFieldSubmitted,
                          ) {
                            textController.text =
                                controller.selectedSupplier.value;
                            textController
                                .selection = TextSelection.fromPosition(
                              TextPosition(offset: textController.text.length),
                            );
                            return TextField(
                              controller: textController,
                              focusNode: focusNode,
                              decoration: InputDecoration(
                                hintText: 'Type or select supplier'.tr,
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                controller.selectedSupplier.value = value;
                              },
                            );
                          },
                          optionsViewBuilder: (context, onSelected, options) {
                            return Align(
                              alignment: Alignment.topLeft,
                              child: Material(
                                elevation: 4,
                                borderRadius: BorderRadius.circular(12),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(maxWidth: 280),
                                  child: ListView(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    children:
                                        options.map((option) {
                                          return ListTile(
                                            title: Text(option.name),
                                            onTap: () => onSelected(option),
                                          );
                                        }).toList(),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    SizedBox(height: 15),
                    Text(
                      AppString.uploadReceipt,
                      style: styleForNormalText.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Obx(
                      () => GestureDetector(
                        onTap: () {
                          controller.pickImage();
                        },
                        child: Container(
                          width: double.infinity,
                          height: 120, // adjust height as needed
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.primary,
                              width: 0.3,
                            ),
                            color: AppColors.textFieldBg,
                            image:
                                controller.selectedImage.value != null
                                    ? DecorationImage(
                                      image: FileImage(
                                        controller.selectedImage.value!,
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                    : null,
                          ),
                          child:
                              controller.selectedImage.value == null
                                  ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.white,
                                        child: CommonImage(
                                          imageSrc: AppIcons.uploadIcon,
                                          imageType: ImageType.svg,
                                          size: 35,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "Click to Upload",
                                        style: styleForNormalText.copyWith(
                                          fontSize: 14,
                                          color: AppColors.darkGrey,
                                        ),
                                      ),
                                    ],
                                  )
                                  : SizedBox.shrink(),
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    Obx(() {
                      return CustomButton(
                        text: AppString.submit,
                        borderRadius: 16,
                        isLoading: controller.isSubmitting.value,
                        fontSize: 16,
                        onTap: () {
                          final amountText =
                              controller.amountController.text.trim();
                          final availableCredit =
                              double.tryParse(controller.creditEarned.value) ??
                              0;
                          final enteredAmount =
                              double.tryParse(amountText) ?? -1;

                          // Validate amount
                          if (amountText.isEmpty || enteredAmount < 0) {
                            Get.snackbar(
                              "Invalid Amount",
                              "Please enter a valid amount.",
                            );
                            return;
                          }

                          if (enteredAmount > availableCredit) {
                            Get.snackbar(
                              "Insufficient Credit",
                              "You cannot submit more than your available credit of $availableCredit.",
                            );
                            return;
                          }
                          // Validate supplier
                          if (controller.selectedSupplier.value.isEmpty) {
                            Get.snackbar(
                              "Invalid Supplier",
                              "Please select a supplier.",
                            );
                            return;
                          }

                          // Check if supplier exists in the list
                          final isValidSupplier = controller.suppliers.any(
                            (s) =>
                                s.name.toLowerCase() ==
                                controller.selectedSupplier.value.toLowerCase(),
                          );
                          if (!isValidSupplier) {
                            Get.snackbar(
                              "Invalid Supplier",
                              "Please select a valid supplier from the list.",
                            );
                            return;
                          }

                          // Validate image
                          if (controller.selectedImage.value == null) {
                            Get.snackbar(
                              "No Image Selected",
                              "Please select an image to upload.",
                            );
                            return;
                          }

                          controller.submitCredit();
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ).whenComplete(() {
      controller.resetAmountInput();
    });
  }
}
