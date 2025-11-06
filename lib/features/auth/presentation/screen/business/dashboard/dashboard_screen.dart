import 'package:event_ease/core/helper/prefs_helper.dart';
import 'package:event_ease/core/routers/routes_name.dart';
import 'package:event_ease/features/auth/presentation/screen/business/dashboard/api/deshboard_controller.dart';
import 'package:event_ease/features/auth/presentation/screen/business/dashboard/send_notification_screen.dart';
import 'package:event_ease/features/auth/presentation/screen/business/sponsorship/detail_screen/business_profile_card_screen.dart';
import 'package:event_ease/features/auth/presentation/screen/business/sponsorship/detail_screen/event_card_screen.dart';
import 'package:event_ease/features/auth/presentation/screen/business/sponsorship/detail_screen/job_card_screen.dart';
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/app_icons.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/common_image.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_button.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../widgets/business/dashboard/overview_container.dart';
import '../../../widgets/business/dashboard/view_trend_line_chart.dart';
import '../../../widgets/percentage_ring.dart';
import 'api/deshboard_search_controller.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  static DeshBoardController deshBoardController = Get.put(
    DeshBoardController(),
  );
  static String status = "business";
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController linkController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  BusinessListController controller = Get.put(BusinessListController());

  @override
  void dispose() {
    linkController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadParentBusinessId();
  }

  RxString parentBusinessId = "".obs;

  void loadParentBusinessId() async {
    parentBusinessId.value = await PrefsHelper.getParentBusinessId() ?? "";
  }

  @override
  Widget build(BuildContext context) {
    // final String? data = Get.arguments is Map ? Get.arguments['data'] : null;
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          
             if (DashboardScreen.deshBoardController.isLoading.value ||
              DashboardScreen.deshBoardController.stats.value == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (parentBusinessId.value.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Create Your 1st business to access the Dashboard",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 21,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 220,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                      onPressed: () {
                        Get.toNamed(RoutesName.signUpStep);
                      },
                      child: const Text(
                        "Complete Profile",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

       

          return SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
              top: 10,
              bottom: 50,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 52.h,
                      width: 52.w,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primary, width: 2),
                        shape: BoxShape.circle,
                      ),
                      child: CommonImage(
  imageSrc: (PrefsHelper.myImage.isNotEmpty) 
      ? PrefsHelper.myImage 
      : "https://tse4.mm.bing.net/th/id/OIP.tvaMwK3QuFxhTYg4PSNNVAHaHa?rs=1&pid=ImgDetMain&o=7&rm=3", // or local asset
  imageType: ImageType.network,
  borderRadius: 100,
),

                    ),
                    SizedBox(width: 10.w),
                    Text(
                      "${AppString.welcome} ${AppString.back}",
                      style: styleForBoldText.copyWith(
                        height: 1.50,
                        fontSize: 20.sp,
                      ),
                    ),
                    Spacer(),
                    Text(
                      "€ ${DashboardScreen.deshBoardController.stats.value!.totalCredits!.toStringAsFixed(1)}",
                      style: styleForBoldText.copyWith(
                        height: 1.50,
                        fontSize: 21.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),

                //=========================================================================select listing part
                Text(
                  AppString.selectListings,
                  style: styleForBoldText.copyWith(
                    height: 1.56.h,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 5.h),
                Obx(() {
                  return CustomSearchField(
                    hintText:
                        controller.filterValue.value.isNotEmpty
                            ? controller.filterValue.value
                            : "Select Listings",
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 20.w, right: 16.w),
                      child: SvgPicture.asset(
                        DashboardScreen.status == "job"
                            ? AppIcons.jobIcon
                            : DashboardScreen.status == "business"
                            ? AppIcons.businessIcon
                            : AppIcons.eventIcon,
                        height: 23.h,
                        width: 23.w,
                        fit: BoxFit.contain,
                      ),
                    ),
                    controller: searchController,
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(bottom: 0),
                      child: Icon(Icons.keyboard_arrow_down),
                    ),
                    readOnly: true,
                    onTap: () {
                      Get.toNamed(RoutesName.dashboardSearchScreen);
                    },
                  );
                }),

                SizedBox(height: 10.h),

                //========================================================================================completion card
                Container(
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey, width: 0.4),
                  ),
                  child: Column(
                    children: [
                      Text(
                        AppString.competitionScore,
                        style: styleForBoldText.copyWith(
                          color: AppColors.darkGrey,
                          fontSize: 24.sp,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        AppString.anIntelligentSystem,
                        style: styleForNormalText.copyWith(
                          color: AppColors.darkGrey,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 28.h),
                        child: PercentageRing(
                          percentage:
                              DashboardScreen
                                  .deshBoardController
                                  .competitionScore
                                  .value
                                  .toDouble(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.textFieldBg,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.primary,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              AppString.recommendedAdvertisingPackage,
                              style: styleForBoldText.copyWith(
                                color: AppColors.darkGrey,
                                fontSize: 16.sp,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 5),
                            ElevatedButton(
                              onPressed: () {
                                if (DashboardScreen.status == "business") {
                                  Get.to(
                                    BusinessProfileCardScreen(
                                      id:
                                          DashboardScreen
                                              .deshBoardController
                                              .stats
                                              .value!
                                              .businessId
                                              .toString(),
                                      selectedPlan:
                                          DashboardScreen
                                              .deshBoardController
                                              .suggestedPack
                                              .value,
                                      businessName:
                                          controller
                                                  .filterValue
                                                  .value
                                                  .isNotEmpty
                                              ? controller.filterValue.value
                                              : controller
                                                  .businessList
                                                  .first
                                                  .name,
                                    ),
                                  );
                                } else if (DashboardScreen.status == "event") {
                                  Get.to(
                                    EventCardScreen(
                                      id:
                                          DashboardScreen
                                              .deshBoardController
                                              .stats
                                              .value!
                                              .eventId
                                              .toString(),
                                      eventName:
                                          controller
                                                  .filterValue
                                                  .value
                                                  .isNotEmpty
                                              ? controller.filterValue.value
                                              : controller
                                                  .businessList
                                                  .first
                                                  .name,
                                    ),
                                  );
                                } else if (DashboardScreen.status == "job") {
                                  Get.to(
                                    JobCardScreen(
                                      id:
                                          DashboardScreen
                                              .deshBoardController
                                              .stats
                                              .value!
                                              .jobId
                                              .toString(),
                                      jobName:
                                          controller
                                                  .filterValue
                                                  .value
                                                  .isNotEmpty
                                              ? controller.filterValue.value
                                              : controller
                                                  .businessList
                                                  .first
                                                  .name,
                                    ),
                                  );
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                  AppColors.primary,
                                ),
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              child: Text(
                                DashboardScreen
                                    .deshBoardController
                                    .suggestedPack
                                    .value
                                    .toString(),
                                style: styleForBoldText.copyWith(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: AppString.buyNow,
                              paddingVertical: 12.h,
                              onTap: () {
                                if (DashboardScreen.status == "business") {
                                  Get.to(
                                    BusinessProfileCardScreen(
                                      id:
                                          DashboardScreen
                                              .deshBoardController
                                              .stats
                                              .value!
                                              .businessId
                                              .toString(),

                                      selectedPlan:
                                          DashboardScreen
                                              .deshBoardController
                                              .suggestedPack
                                              .value,
                                      businessName:
                                          controller
                                                  .filterValue
                                                  .value
                                                  .isNotEmpty
                                              ? controller.filterValue.value
                                              : controller
                                                  .businessList
                                                  .first
                                                  .name,
                                    ),
                                  );
                                } else if (DashboardScreen.status == "event") {
                                  Get.to(
                                    EventCardScreen(
                                      id:
                                          DashboardScreen
                                              .deshBoardController
                                              .stats
                                              .value!
                                              .eventId
                                              .toString(),
                                      eventName:
                                          controller
                                                  .filterValue
                                                  .value
                                                  .isNotEmpty
                                              ? controller.filterValue.value
                                              : controller
                                                  .businessList
                                                  .first
                                                  .name,
                                    ),
                                  );
                                } else if (DashboardScreen.status == "job") {
                                  Get.to(
                                    JobCardScreen(
                                      id:
                                          DashboardScreen
                                              .deshBoardController
                                              .stats
                                              .value!
                                              .jobId
                                              .toString(),
                                      jobName:
                                          controller
                                                  .filterValue
                                                  .value
                                                  .isNotEmpty
                                              ? controller.filterValue.value
                                              : controller
                                                  .businessList
                                                  .first
                                                  .name,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Get.toNamed(RoutesName.sponsorshipScreen);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                    color: AppColors.primary,
                                    width: 3,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 12.h,
                                ),
                                child: Text(
                                  AppString.learnMore,
                                  style: styleForBoldText.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  AppString.statsOverview,
                  style: styleForBoldText.copyWith(
                    color: AppColors.darkGrey,
                    fontSize: 24.sp,
                  ),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.count(
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 25,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    children: [
                      if (DashboardScreen.status == 'business')
                        OverviewContainer(
                          title: AppString.followers,
                          icon: Icon(
                            Icons.person_add_alt_1_rounded,
                            color: AppColors.primary,
                          ),
                          totalNumber:
                              DashboardScreen
                                  .deshBoardController
                                  .stats
                                  .value!
                                  .totalFollowers
                                  .toString(),
                        ),

                      if (DashboardScreen.status == 'business' ||
                          DashboardScreen.status == 'event')
                        OverviewContainer(
                          icon: SvgPicture.asset(AppIcons.likeIcon),
                          title: AppString.like,
                          totalNumber:
                              DashboardScreen
                                  .deshBoardController
                                  .stats
                                  .value!
                                  .totalLikes
                                  .toString(),
                        ),
                      OverviewContainer(
                        icon: Icon(Icons.chat, color: AppColors.primary),
                        title: AppString.comments,
                        totalNumber:
                            DashboardScreen
                                .deshBoardController
                                .stats
                                .value!
                                .totalComments
                                .toString(),
                      ),

                      if (DashboardScreen.status == 'job')
                        OverviewContainer(
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: AppColors.primary,
                          ),
                          title: AppString.profileViews,
                          totalNumber:
                              DashboardScreen
                                  .deshBoardController
                                  .stats
                                  .value!
                                  .jobViews
                                  .toString(),
                        ),

                      if (DashboardScreen.status == 'business')
                        OverviewContainer(
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: AppColors.primary,
                          ),
                          title: AppString.profileViews,
                          totalNumber:
                              DashboardScreen
                                  .deshBoardController
                                  .stats
                                  .value!
                                  .profileViews
                                  .toString(),
                        ),

                      if (DashboardScreen.status == 'event')
                        OverviewContainer(
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: AppColors.primary,
                          ),
                          title: AppString.eventViews,
                          totalNumber:
                              DashboardScreen
                                  .deshBoardController
                                  .stats
                                  .value!
                                  .eventViews
                                  .toString(),
                        ),

                      if (DashboardScreen.status == 'job')
                        OverviewContainer(
                          icon: Icon(
                            Icons.group_sharp,
                            color: AppColors.primary,
                          ),
                          title: AppString.jobApplicants,
                          totalNumber:
                              DashboardScreen
                                  .deshBoardController
                                  .stats
                                  .value!
                                  .jobApplicants
                                  .toString(),
                        ),
                      OverviewContainer(
                        icon: SvgPicture.asset(AppIcons.sponsorshipIcon),
                        title: AppString.activeSponsorship,
                        totalNumber:
                            DashboardScreen
                                .deshBoardController
                                .stats
                                .value!
                                .totalActiveSub
                                .toString(),
                      ),
                      if (DashboardScreen.status == 'business')
                        OverviewContainer(
                          icon: Icon(
                            Icons.credit_card,
                            color: AppColors.primary,
                          ),
                          title: AppString.totalCredits,
                          totalNumber:
                              DashboardScreen
                                  .deshBoardController
                                  .stats
                                  .value!
                                  .totalCredits!
                                  .toStringAsFixed(1)
                                  .toString(),
                        ),

                      if (DashboardScreen.status == 'business' ||
                          DashboardScreen.status == 'event')
                        OverviewContainer(
                          icon: SvgPicture.asset(AppIcons.reviewIcon),
                          title: AppString.review,
                          totalNumber:
                              DashboardScreen
                                  .deshBoardController
                                  .stats
                                  .value!
                                  .averageRating
                                  .toString(),
                        ),

                      if (DashboardScreen.status == 'event')
                        InkWell(
                          onTap: () {
                            if (DashboardScreen
                                        .deshBoardController
                                        .stats
                                        .value!
                                        .interestsUsers !=
                                    null &&
                                DashboardScreen
                                        .deshBoardController
                                        .stats
                                        .value!
                                        .interestsUsers! >
                                    0) {
                              Get.toNamed(
                                RoutesName.interestedUserScreen,
                                arguments: {
                                  'id':
                                      DashboardScreen
                                          .deshBoardController
                                          .stats
                                          .value!
                                          .eventId,
                                },
                              );
                            } else {
                              Get.snackbar(
                                "No Interested Users",
                                "There are currently no users who have shown interest in this event.",
                                snackPosition: SnackPosition.TOP,
                                backgroundColor: Colors.orangeAccent,
                                colorText: Colors.black,
                              );
                            }

                            //event id have to pass
                          },

                          child: Container(
                            width: 200.w,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.grey,
                                width: 0.4,
                              ),
                              color: Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        radius: 24.r,
                                        child: Icon(
                                          Icons.groups_sharp,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      SizedBox(
                                        width: 120,
                                        child: Text(
                                          AppString.interestedUsers,
                                          style: styleForBoldText.copyWith(
                                            fontSize: 16.sp,
                                            color: AppColors.grey,
                                            height: 1.50.h,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        DashboardScreen
                                            .deshBoardController
                                            .stats
                                            .value!
                                            .interestsUsers
                                            .toString(),
                                        style: styleForBoldText.copyWith(
                                          fontSize: 24.sp,
                                        ),
                                      ),

                                      // SizedBox(height: 10,),
                                      // Text("! 2 Expiring This Week", style: styleForNormalText.copyWith(fontSize: 12.sp),),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: AppColors.primary,
                                  size: 24.r,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                SizedBox(height: 10),

                if (DashboardScreen.status == "business")
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppString.affiliateLink,
                        style: styleForBoldText.copyWith(color: Colors.black),
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        hintText:
                            DashboardScreen
                                .deshBoardController
                                .stats
                                .value!
                                .customId ??
                            "N/A",
                        isSuffix: false,
                        enabled: false,
                        controller: linkController,
                      ),
                      const SizedBox(height: 10),
                      CustomButton(
                        text: AppString.copyLink,
                        borderRadius: 16,
                        onTap: () {
                          Clipboard.setData(
                            ClipboardData(text: linkController.text),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Link copied to clipboard!"),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "${AppString.creditsEarned} :  €0 (3 ${AppString.referrals})",
                        style: styleForBoldText.copyWith(
                          fontSize: 16,
                          color: AppColors.darkGrey,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                if (DashboardScreen.status == "job"
                // && DashboardScreen.deshBoardController.stats.value!.jobApplicants!=null && DashboardScreen.deshBoardController.stats.value!.jobApplicants!>0
                ) ...[
                  CustomButton(
                    text: AppString.viewApplication,
                    borderRadius: 16,
                    onTap: () {
                      Get.toNamed(
                        RoutesName.jobApplicationScreen,
                        arguments: {
                          "id":
                              DashboardScreen
                                  .deshBoardController
                                  .stats
                                  .value!
                                  .jobId,
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                ],
                Text(
                  AppString.viewsTrend,
                  style: styleForBoldText.copyWith(
                    color: AppColors.darkGrey,
                    fontSize: 24.sp,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: SizedBox(
                    height: 200,
                    child: ViewsTrendLineChart(
                      monthlyViews:
                          DashboardScreen
                              .deshBoardController
                              .stats
                              .value!
                              .monthlyViews ??
                          [],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () {
                      // Get.toNamed(RoutesName.sendNotificationScreen);
                      DashboardScreen.deshBoardController.notificationCount(
                        DashboardScreen.status,
                        (DashboardScreen.status == "event")
                            ? DashboardScreen
                                .deshBoardController
                                .stats
                                .value!
                                .eventId!
                            : (DashboardScreen.status == "job")
                            ? DashboardScreen
                                .deshBoardController
                                .stats
                                .value!
                                .jobId!
                            : DashboardScreen
                                .deshBoardController
                                .stats
                                .value!
                                .businessId!,
                      );
                      Get.to(
                        SendNotificationScreen(
                          type: DashboardScreen.status,
                          notificationFor:
                              (DashboardScreen.status == "event")
                                  ? DashboardScreen
                                      .deshBoardController
                                      .stats
                                      .value!
                                      .eventId!
                                  : (DashboardScreen.status == "job")
                                  ? DashboardScreen
                                      .deshBoardController
                                      .stats
                                      .value!
                                      .jobId!
                                  : DashboardScreen
                                      .deshBoardController
                                      .stats
                                      .value!
                                      .businessId!,
                          totalFollower:
                              (DashboardScreen
                                          .deshBoardController
                                          .stats
                                          .value!
                                          .totalFollowers ??
                                      0)
                                  .toString(),
                          image:
                              DashboardScreen
                                  .deshBoardController
                                  .stats
                                  .value!
                                  .image
                                  .toString(),

                          name:
                            controller.filterValue.value.isNotEmpty
    ? controller.filterValue.value
    : (controller.businessList.isNotEmpty 
        ? controller.businessList.first.name 
        : "N/A"),
                        ),
                      );
                    },
                    child: Container(
                      width: 220,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.primary,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.notifications_active, color: Colors.white),
                          Text(
                            AppString.sendNotification,
                            style: styleForBoldText.copyWith(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10),

                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: styleForNormalText.copyWith(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                    children: [
                      const TextSpan(
                        text:
                            "By clicking this button, you will send a notification to all the followers of this listing:\nLISTING: ",
                      ),
                      TextSpan(
                        text:
                            controller.filterValue.value.isNotEmpty
                                ? controller.filterValue.value
                                : controller.businessList.first.name,
                        style: styleForNormalText.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // 👈 optional for emphasis
                        ),
                      ),
                      const TextSpan(text: "\nFOLLOWERS: "),
                      TextSpan(
                        text:
                            "${DashboardScreen.deshBoardController.stats.value!.totalFollowers ?? 0}",
                        style: styleForNormalText.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // 👈 optional for emphasis
                        ),
                      ),
                      const TextSpan(text: "."),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
