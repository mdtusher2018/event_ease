import 'package:event_ease/features/auth/presentation/screen/business/sponsorship/api/CreditsController.dart';
import 'package:event_ease/features/auth/presentation/screen/business/sponsorship/api/subscription_payment_controller.dart';
import 'package:event_ease/features/auth/presentation/screen/common/nav_screen.dart';
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

enum PaymentOption { usePayment, useCredits }

class PaymentMethodScreen extends StatefulWidget {
  final String subscriptionId;
  final String subscriptionFor;
  final String subscriptionForType; // "Business", "Event", or "Job"
  final String name;
  final String subscriptionName;
  final int subscriptionOptionIndex;
  final double amount;
  final int duration;

  const PaymentMethodScreen({
    super.key,
    required this.subscriptionId,
    required this.subscriptionFor,
    required this.subscriptionForType,
    required this.name,
    required this.subscriptionName,
    required this.subscriptionOptionIndex,
    required this.amount,
    required this.duration,
  });

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  PaymentOption? _selectedOption = PaymentOption.usePayment;
  final controller = Get.put(SubscriptionPaymentController());
  void _onNext() {
    if (_selectedOption != null) {
      if (_selectedOption == PaymentOption.usePayment) {
        showPromotionCodeDialog(context);
      }
      if (_selectedOption == PaymentOption.useCredits) {
        // Check if user has enough credits before hitting server
        final userCredits =
            double.tryParse(creditsController.credits.value) ?? 0.0;

        if (userCredits < widget.amount) {
          showPromotionCodeDialog(context, userCredits: userCredits);
          return;
        }

        controller
            .subscribeToPlanWithCredit(
              context: context,
              subscriptionId: widget.subscriptionId,
              subscriptionFor: widget.subscriptionFor, // or eventId/jobId
              subscriptionForType:
                  widget.subscriptionForType, // or "Event" / "Job"
              subscriptionOptionIndex: widget.subscriptionOptionIndex,
              amount: widget.amount,
              duration: widget.duration,
            )
            .then((value) {
              Get.offAll(NavScreen());
              // Navigator.of(context).popUntil((route) => route.isFirst);
              creditsController.fetchMyTotalCredits();
            });
      }

      // Navigate or submit as needed
    } else {
      Get.snackbar("Error".tr, "Please select a payment option.");
    }
  }

  final CreditsController creditsController = Get.put(CreditsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,

        title: Text(
          "Payment".tr,
          style: styleForBoldText.copyWith(fontSize: 24.sp),
        ),
        backgroundColor: Colors.white,

        elevation: 1,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Select a payment method".tr,
                    style: styleForBoldText.copyWith(fontSize: 20.sp),
                  ),
                  SizedBox(height: 20.h),
                  RadioListTile<PaymentOption>(
                    contentPadding: EdgeInsets.all(0),
                    title: Text(
                      "Use Payments".tr,
                      selectionColor: AppColors.primary,

                      style: styleForNormalText.copyWith(
                        fontSize: 16.sp,
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    value: PaymentOption.usePayment,
                    groupValue: _selectedOption,
                    onChanged: (PaymentOption? value) {
                      setState(() {
                        _selectedOption = value;
                      });
                    },
                  ),
                  RadioListTile<PaymentOption>(
                    contentPadding: EdgeInsets.all(0),
                    title: Text(
                      "Use Credits".tr,
                      style: styleForNormalText.copyWith(
                        fontSize: 16.sp,
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    value: PaymentOption.useCredits,
                    groupValue: _selectedOption,
                    onChanged: (PaymentOption? value) {
                      setState(() {
                        _selectedOption = value;
                      });
                    },
                  ),

                  SizedBox(height: 16.h),
                  Obx(
                    () => Text(
                      "${"Credits".tr}: ${creditsController.credits.value}",
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Spacer(),
                  // Subscription Summary Card
                  Container(
                    padding: EdgeInsets.all(16.w),
                    margin: EdgeInsets.only(bottom: 20.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Summary".tr,
                          style: styleForBoldText.copyWith(
                            fontSize: 18.sp,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        _buildSummaryRow(
                          "Plan for:".tr,
                          widget.subscriptionForType,
                        ),
                        _buildSummaryRow(
                          "${widget.subscriptionForType} Name:",
                          widget.name,
                        ),
                        _buildSummaryRow(
                          "Subscription:".tr,
                          widget.subscriptionName,
                        ),
                        _buildSummaryRow(
                          "Duration:".tr,
                          "${widget.duration} days",
                        ),
                        _buildSummaryRow(
                          "Amount:".tr,
                          "€${widget.amount.toStringAsFixed(2)}",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Obx(() {
              return CustomButton(
                text: AppString.next,
                borderRadius: 50,
                onTap: _onNext,
                isLoading: controller.isLoading.value,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: styleForNormalText.copyWith(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: styleForBoldText.copyWith(
              fontSize: 14.sp,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> noCreditsDialog() {
    return Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titlePadding: EdgeInsets.only(top: 20, left: 20, right: 20),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        actionsPadding: EdgeInsets.only(bottom: 10, right: 10),
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Icon(Icons.cancel, color: AppColors.primary, size: 32),
                ),
              ],
            ),

            Text(
              "You Don’t have\nenough credits",
              style: styleForBoldText.copyWith(
                fontSize: 30,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
          ],
        ),

        actionsAlignment: MainAxisAlignment.center,
      ),
    );
  }

  // Step 1: Confirmation dialog
  void showPromotionCodeDialog(BuildContext context, {num? userCredits}) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "Do you have a promotion code?".tr,
          style: styleForBoldText.copyWith(
            color: AppColors.primary,
            fontSize: 18,
          ),
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          // Yes Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
            ),
            onPressed: () {
              Navigator.pop(context);
              _showEnterPromoCodeDialog(context, userCredits: userCredits);
            },
            child: Text(
              "Yes".tr,
              style: styleForBoldText.copyWith(color: Colors.white),
            ),
          ),

          // No Button
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.primary, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
            ),

            onPressed: () {
              Navigator.pop(context);
              controller.subscribeToPlan(
                context: context,
                subscriptionId: widget.subscriptionId,
                subscriptionFor: widget.subscriptionFor, // or eventId/jobId
                subscriptionForType:
                    widget.subscriptionForType, // or "Event" / "Job"
                subscriptionOptionIndex: widget.subscriptionOptionIndex,
                amount: widget.amount,
                duration: widget.duration,
                userCredits: userCredits,
              );
            },
            child: Text(
              "No".tr,
              style: styleForBoldText.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  // Step 2: Input dialog for entering code
  void _showEnterPromoCodeDialog(BuildContext context, {num? userCredits}) {
    final TextEditingController promoController = TextEditingController();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "Enter Promotion Code",
          style: styleForBoldText.copyWith(
            color: AppColors.primary,
            fontSize: 18,
          ),
        ),
        content: TextField(
          controller: promoController,
          decoration: InputDecoration(
            hintText: "Enter your code here",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
              ),
              onPressed: () {
                if (promoController.text.trim().isEmpty) {
                  Get.snackbar("Error".tr, "Please enter a promotion code");
                  return;
                }
                Navigator.pop(context);
                controller.subscribeToPlan(
                  context: context,
                  subscriptionId: widget.subscriptionId,
                  subscriptionFor: widget.subscriptionFor, // or eventId/jobId
                  subscriptionForType:
                      widget.subscriptionForType, // or "Event" / "Job"
                  subscriptionOptionIndex: widget.subscriptionOptionIndex,
                  amount: widget.amount,
                  duration: widget.duration,
                  promocode: promoController.text,
                  userCredits: userCredits,
                );
              },
              child: Text(
                "Next",
                style: styleForBoldText.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
