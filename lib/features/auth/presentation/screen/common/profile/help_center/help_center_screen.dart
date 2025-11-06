// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:event_ease/core/helper/prefs_helper.dart';
import 'package:event_ease/core/routers/routes_name.dart';
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/app_icons.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/common_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../controller/profile/help_center_controller.dart';
import '../../../../utils/app_string.dart';

class HelpCenterScreen extends StatefulWidget {
  HelpCenterScreen({super.key,this.target=0});
  int target;

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  HelpCenterController controller = Get.find<HelpCenterController>();

  TextEditingController searchController = TextEditingController();

  void openWhatsApp(String phoneNumber, {String message = ""}) async {
    final Uri whatsappUri = Uri.parse(
      "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}",
    );

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else {
      throw "Could not launch WhatsApp";
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.index=widget.target;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          AppString.helpCenter,
          style: styleForBoldText.copyWith(fontSize: 24.sp),
        ),
        bottom: TabBar(
          onTap: (value) {
            log("value======$value");
          },
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.grey,
          unselectedLabelStyle: styleForBoldText.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.w200,
            color: AppColors.grey,
            height: 1.40.h,
            letterSpacing: 0.20,
          ),
          labelStyle: styleForBoldText.copyWith(
            fontSize: 18.sp,
            height: 1.40.h,
            letterSpacing: 0.20,
          ),
          tabs: [Tab(text: AppString.faq), Tab(text: AppString.contactUs)],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // FAQ Tab
          Column(
            children: [
              const SizedBox(height: 10),
              // Padding(
              //   padding: const EdgeInsets.all(14),
              //   child: CustomSearchField(prefixIcon: Icon(Icons.search),hintText: "Search", controller: searchController, ),
              // ),
              // const SizedBox(height: 5),
              Obx(
                () => Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: controller.faqList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        shadowColor: Colors.white,
                        color: AppColors.textFieldBg,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          // side: BorderSide(color: AppColors.secondary),
                        ),
                        child: ExpansionTile(
                          iconColor: AppColors.primary,
                          collapsedIconColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: AppColors.secondary),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          collapsedShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          title: Text(
                            controller.faqList[index]['question'],
                            style: styleForBoldText.copyWith(
                              color: AppColors.primary,
                              fontSize: 18.sp,
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                controller.faqList[index]['answer'],
                                style: styleForNormalText.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.darkGrey,
                                  height: 1.40,
                                  letterSpacing: 0.20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          // Contact Us Tab
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                children: [
                  if (PrefsHelper.myRole == "organizer") ...[
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        openWhatsApp(
                          "393277913497",
                          message: "Hello, I’m contacting you from EventEase!",
                        );
                      },
                      child: _buildClickableTile(
                        icon: FontAwesomeIcons.whatsapp,
                        color: Colors.green,
                        title: "WhatsApp",
                        url: "",
                      ),
                    ),
                  ],

                  SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      Get.toNamed(RoutesName.liveSupportScreen);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.textFieldBg,
                        border: Border.all(color: Colors.white, width: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: CommonImage(
                          imageSrc: AppIcons.support,
                          imageType: ImageType.svg,
                          height: 24.h,
                          width: 24.w,
                        ),
                        title: Text(
                          "Ticket Support",
                          style: styleForBoldText.copyWith(fontSize: 18.sp),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void launcherMethod(String url) async {
    if (!url.startsWith("http") && !url.startsWith("https")) {
      url = "https://$url";
    }

    var launcherUrl = Uri.parse(url);
    try {
      if (await canLaunchUrl(launcherUrl)) {
        await launchUrl(launcherUrl);
      } else {
        throw 'Could not launch $launcherUrl';
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Widget _buildClickableTile({
    required IconData icon,
    required String title,
    required Color color,
    required String url,
  }) {
    return GestureDetector(
      onTap: () async {
        launcherMethod(url);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.textFieldBg,
          border: Border.all(color: Colors.white, width: 0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: FaIcon(icon, color: color, size: 24.r),
          title: Text(title, style: styleForBoldText.copyWith(fontSize: 18.sp)),
        ),
      ),
    );
  }
}
