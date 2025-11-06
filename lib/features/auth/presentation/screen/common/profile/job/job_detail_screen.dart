
import 'package:event_ease/engagment%20handle/comment_bottomsheet.dart';
import 'package:event_ease/features/auth/presentation/screen/common/home/widgets/fullimage.dart';
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/app_icons.dart';

import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../../../core/routers/routes_name.dart';
import '../../../../controller/job/job_controller.dart';
import '../../../../widgets/custom_related_job_Container.dart';
import '../../../../widgets/regular/business_detail/build_action_button.dart';
import '../../../../widgets/regular/business_detail/build_stat_column.dart';
import '../../../../widgets/regular/business_detail/custom_comment.dart';
import '../../../../widgets/regular/business_detail/custom_info_list_tile.dart';
import '../../../../widgets/regular/business_detail/custom_input_field.dart';
import '../../../../widgets/regular/business_detail/faq_item_widget.dart';
import '../../home/bussiness map/map_page.dart';

class JobDetailScreen extends StatefulWidget {
  const JobDetailScreen({super.key});

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {

  JobController controller = Get.find<JobController>();

  final ScrollController _scrollController = ScrollController();

  final GlobalKey _galleryKey = GlobalKey();

  final GlobalKey _locationKey = GlobalKey();

  final GlobalKey _faqKey = GlobalKey();

  // Track selected tab index: 0 = Gallery, 1 = Reviews, 2 = Location, 3 = FAQ
  int _selectedTabIndex = 0;

  // Scroll to the section and update selected tab index
  void scrollToSection(GlobalKey key, int index) {
    setState(() {
      _selectedTabIndex = index;
    });

    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask((){
      WidgetsBinding.instance.addPostFrameCallback((value){
        controller.getJobDetail(Get.arguments??"");
      });
    });

  }


  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  String formatDateTime(String createdAt) {
    try {
      final DateTime dateTime = DateTime.parse(createdAt).toLocal();
      return DateFormat('EEEE, MMM d, y • h:mm a').format(dateTime);
    } catch (e) {
      return 'Date unavailable';
    }
  }



  Widget buildTab(String label, int index, GlobalKey targetKey, {Widget? icon}) {
    final bool isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () => scrollToSection(targetKey, index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 8.h),
        margin: EdgeInsets.only(right: 8.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(color: AppColors.primary),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              icon,
              SizedBox(width: 8.w),
            ],
            Text(
              label,
              style: styleForBoldText.copyWith(
                fontSize: 16.sp,
                color: isSelected ? Colors.white : AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>




  @override
  Widget build(BuildContext context) {
    final String? detailShow =
        Get.arguments is Map ? Get.arguments['detailShow'] as String? : null;

    return Scaffold(
      floatingActionButton: detailShow == "job"
          ? Padding(
        padding: const EdgeInsets.only(left: 30),
            child: CustomButton(text: "Edit"),
          )
          : Padding(
            padding: const EdgeInsets.only(left: 30),
            child: CustomButton(
                    text: AppString.apply,
                    paddingVertical: 11,
                    fontSize: 18,
                    backgroundColor: AppColors.primary,
                    textColor: Colors.white,
                    onTap: () {
            Get.toNamed(RoutesName.applyJobScreen);
                    },
                  ),
          ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 10),
        child: Obx(() {
  
          return (controller.isLoading.value || controller.jobDetailModel.value==null)
            ?Center(child: CircularProgressIndicator(),)
            :Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Background Image
                InkWell(
                  onTap: () {
                         showFullImage(
                                      context,
                                       controller
                                          .jobDetailModel
                                          .value!
                                          .coverImage,
                                        
                                    );
                  },
                  child: Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      // borderRadius: BorderRadius.only(
                      //   bottomRight: Radius.circular(20),
                      //   bottomLeft: Radius.circular(20),
                      // ),
                      image: DecorationImage(
                        image: NetworkImage(controller.jobDetailModel.value!.coverImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                // Back Button
                Positioned(
                  top: 40,
                  left: 10,
                  child: Container(
                    height: 45,
                    width: 45,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ),
                ),
                // Bookmark Icon
                // Positioned(
                //   bottom: -50,
                //   right: 10,
                //   child: IconButton(
                //     icon: SvgPicture.asset(AppIcons.bookmarkIcon,),
                //     onPressed: () {},
                //   ),
                // ),
                // Profile Image with Decorative Overlay
                Positioned(
                  bottom: -50, // Overlaps the container below
                  left: 16,
                  child: Stack(
                    children: [
                      // Profile Image
                      InkWell(
                        onTap: (){
                              showFullImage(
                                      context,
                                       controller
                                          .jobDetailModel
                                          .value!
                                          .logo,
                                        
                                    );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              "${controller.jobDetailModel.value!.logo}",
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      // Decorative Flower Overlay
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50), // Space for the profile image overlap
            // Profile Name and Bio Section
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    controller.jobDetailModel.value!.title,
                    style: styleForBoldText.copyWith(
                      fontSize: 24,
                      color: AppColors.darkGrey,
                      height: 1.07,
                    ),
                  ),
        
                  const SizedBox(height: 10),
        
                  // Action Buttons (Follow, Like, Comment)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: AppColors.grey, width: 0.3),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Salary",
                              style: styleForNormalText.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                height: 1.50,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "\$${controller.jobDetailModel.value!.salery}",
                              style: styleForBoldText.copyWith(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
        
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: AppColors.grey, width: 0.3),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Working Hrs",
                              style: styleForNormalText.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                height: 1.50,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                             "${controller.jobDetailModel.value!.workHour} hour",
                              style: styleForBoldText.copyWith(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                          border: Border.all(color: AppColors.grey, width: 0.3),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Experience",
                              style: styleForNormalText.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                height: 1.50,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "${controller.jobDetailModel.value!.experience.split(" ").first} Years",
                              style: styleForBoldText.copyWith(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
        
                  SizedBox(height: 10),
                  Column(
                    children: [
                      buildActionButton(
                        icon: SvgPicture.asset(AppIcons.commentIcon),
                        label: AppString.comment,
                        color: AppColors.primary,
                        onPressed: () {
                                 showHomePageCommentBottomSheet(
                                  id: controller.jobDetailModel.value!.id,
                                  isBussiness: false,
                                  context,
                                  commentController: TextEditingController(),
                            
                                ).then((value) {
                                  controller.getJobDetail(Get.arguments);
                                },);
                        },
                      ),
                      SizedBox(height: 10),
                      buildStatColumn("${controller.jobDetailModel.value!.totalComments}", AppString.comments),
                    ],
                  ),
        
                  SizedBox(height: 10),
        
                  Text(
                    AppString.description,
                    style: styleForBoldText.copyWith(
                      color: AppColors.darkGrey,
                      fontSize: 20,
                      height: 1.50,
                    ),
                  ),
        
                  SizedBox(height: 10),
        
                  Text(
                    controller.jobDetailModel.value!.description,
                    style: styleForNormalText.copyWith(
                      fontSize: 16,
                      height: 1.44,
                      fontWeight: FontWeight.w400,
                      color: AppColors.darkGrey,
                    ),
                  ),
                  FutureBuilder<String?>(
                    future: controller.getLocationName(
                      controller.jobDetailModel.value!.longitude, // longitude
                      controller.jobDetailModel.value!.latitude, // latitude
                    ),
                    builder: (context, snapshot) {
                      return CustomInfoListTile(
                        icon: SvgPicture.asset(AppIcons.locationIcon2),
                        title: 'Address',
                        subTitle: snapshot.connectionState == ConnectionState.waiting
                            ? 'Loading...'
                            : snapshot.data ?? 'Location unavailable',
                      );
                    },
                  ),
        
                  CustomInfoListTile(
                    icon: Icon(Icons.phone, color: AppColors.primary),
                    title: 'Phone',
                    subTitle: controller.jobDetailModel.value!.phoneNumber,
                  ),
                   CustomInfoListTile(
                    icon: Icon(Icons.email, color: AppColors.primary),
                    title: 'Email',
                    subTitle: controller.jobDetailModel.value!.email,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "${AppString.hour} : ",
                        style: styleForBoldText.copyWith(
                          color: AppColors.darkGrey,
                          fontSize: 16,
                          height: 1.50,
                        ),
                      ),
                      Text(
                        formatDateTime(controller.jobDetailModel.value!.createdAt),
                        style: styleForNormalText.copyWith(
                          fontSize: 16,
                          height: 1.12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.darkGrey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Row(
                  //   children: [
                  //     Text(
                  //       "${AppString.social}:",
                  //       style: styleForBoldText.copyWith(
                  //         color: AppColors.darkGrey,
                  //         fontSize: 16,
                  //         height: 1.50,
                  //       ),
                  //     ),
                  //     const SizedBox(width: 10),
                  //     CommonImage(
                  //       imageSrc: AppIcons.facebookIcon,
                  //       imageType: ImageType.svg,
                  //       size: 16,
                  //     ),
                  //     const SizedBox(width: 5),
                  //     CommonImage(
                  //       imageSrc: AppIcons.instagramIcon,
                  //       imageType: ImageType.svg,
                  //       size: 16,
                  //     ),
                  //     const SizedBox(width: 5),
                  //     CommonImage(
                  //       imageSrc: AppIcons.xIcon,
                  //       imageType: ImageType.svg,
                  //       size: 16,
                  //     ),
                  //     const SizedBox(width: 5),
                  //     CommonImage(
                  //       imageSrc: AppIcons.tiktokIcon,
                  //       imageType: ImageType.svg,
                  //       size: 16,
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(height: 20),
                  //
                  // SizedBox(height: 5),
                  // Text(
                  //   AppString.elegantHandcrafted,
                  //   style: styleForNormalText.copyWith(
                  //     fontSize: 16,
                  //     color: AppColors.darkGrey,
                  //     fontWeight: FontWeight.w400,
                  //     height: 1.44,
                  //   ),
                  // ),
                  // const SizedBox(height: 10),
        
                  // Tabs
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          buildTab(AppString.gallery, 0, _galleryKey, icon: SvgPicture.asset(AppIcons.galleryLogo, height: 18.h, width: 18.w, color: _selectedTabIndex == 0 ? Colors.white : AppColors.primary),),
                          buildTab(AppString.location, 1, _locationKey,  icon: SvgPicture.asset(AppIcons.locationIcon2, height: 18.h, width: 18.w, color: _selectedTabIndex == 1 ? Colors.white : AppColors.primary),),
                          buildTab(AppString.faq, 2, _faqKey, icon: SvgPicture.asset(AppIcons.faqTabIcon, height: 18.h, width: 18.w, color: _selectedTabIndex == 2 ? Colors.white : AppColors.primary),),
                        ],
                      ),
                    ),
                  ),
        
                  // Gallery Section
                  Padding(
                    key: _galleryKey,
                    padding: EdgeInsets.all(0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppString.gallery,
                          style: styleForBoldText.copyWith(
                            color: AppColors.darkGrey,
                            fontSize: 24.sp,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        GridView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                                  itemCount: controller.jobDetailModel.value!.gallery.length > 4
        ? 4 
        : controller.jobDetailModel.value!.gallery.length,
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisExtent: 180,
                          ),
                          itemBuilder: (context, index) {
                   
                                 final gallery = controller.jobDetailModel.value!.gallery;
      final imageUrl = gallery[index];

      final bool isLastThumbnail =
          gallery.length > 4 && index == 3; // 4th item
                            return GestureDetector(
                              onTap: (){
                                    showFullImageGallery(
                                      context,
                                     imageUrls:  controller
                                          .jobDetailModel
                                          .value!
                                          .gallery,
                                        initialIndex:   index
                                    );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child:  Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
              if (isLastThumbnail)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  alignment: Alignment.center,
                  child: Text(
                    "+${gallery.length - 4}", // number of extra images
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
        
                  // Location Section
                  Padding(
                    key: _locationKey,
                    padding: EdgeInsets.all(0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppString.location,
                          style: styleForBoldText.copyWith(
                            color: AppColors.darkGrey,
                            fontSize: 24.sp,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Container(
                          height: 218.h,
                          width: double.infinity,
                          child: MapPreview(
                            lat:
                            controller.jobDetailModel.value!.latitude,
                            lng:
                            controller.jobDetailModel.value!.longitude,
                          ),
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
        
                  SizedBox(height: 16.h),
        
                  // FAQ Section
                  Padding(
                    key: _faqKey,
                    padding: EdgeInsets.all(0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppString.faq,
                          style: styleForBoldText.copyWith(
                            fontSize: 24.sp,
                            color: AppColors.darkGrey,
                          ),
                        ),
                        controller.jobDetailModel.value!.faq.isNotEmpty?ListView.builder(
                          itemCount: controller.jobDetailModel.value!.faq.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            var faq = controller.jobDetailModel.value!.faq[index];
                            return FAQItem(
                              number: "${index+1}",
                              question: faq.question,
                              answer:
                              faq.answer,
                              isExpanded: false,
                            );
        
                          },):Center(child: Text("No data found", style: styleForNormalText,),),
        
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
        
                  Text(
                    AppString.announcement,
                    style: styleForBoldText.copyWith(
                      color: AppColors.darkGrey,
                      fontSize: 23,
                      height: 1.50,
                    ),
                  ),
                  SizedBox(height: 10),
                  ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blueAccent,
                      child: Icon(
                        Icons.shopping_bag,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    title: Row(
                      children: [
                        Flexible(
                          child: Text(
                            controller.jobDetailModel.value!.author.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: styleForBoldText.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.darkGrey,
                              height: 1.50,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        SvgPicture.asset(AppIcons.verificationIcon),
                      ],
                    ),
                    subtitle: Text(
                      "Villarosa di Mare",
                      style: styleForNormalText.copyWith(
                        fontSize: 14,
                        color: AppColors.grey,
                        fontWeight: FontWeight.w600,
                        height: 1.50,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
        
                  Container(
                    decoration: BoxDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppString.comments,
                          style: styleForBoldText.copyWith(
                            color: AppColors.darkGrey,
                            fontSize: 23,
                            height: 1.50,
                          ),
                        ),
                        SizedBox(height: 5),
                        controller.jobDetailModel.value!.comments.isNotEmpty?
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: controller.jobDetailModel.value!.comments.length,
                          itemBuilder: (context, index) {
                            var comment = controller.jobDetailModel.value!.comments[index];
                            return CustomComment(profilePicture: "${comment.user.profileImage}",name: comment.user.name,comment: comment.text,);
        
                        },):Center(child: Text("No Data Found"),),
        
                        SizedBox(height: 10),
        
                           CustomInputField(onSendCommentClick: (value){
                          controller.postComment(id: controller.jobDetailModel.value!.id, text: value);
                        },),
                        SizedBox(height: 20),
                        Text(
                          "Related Job Offer",
                          style: styleForBoldText.copyWith(
                            color: AppColors.darkGrey,
                            fontSize: 23,
                            height: 1.50,
                          ),
                        ),
                        SizedBox(height: 10),
        
                        controller.jobDetailModel.value!.relatedJobs.isNotEmpty
                            ?SizedBox(
                          height: 330,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: controller.jobDetailModel.value!.relatedJobs.length,
                            itemBuilder: (context, index) {
                              var data = controller.jobDetailModel.value!.relatedJobs[index];
                              return SizedBox(
                                width: 288,
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: CustomRelatedJobContainer(
                                    onTap: () {
                                      controller.getJobDetail(data.id);
                                    },
                                    typeImage: AppIcons.jobIcon,
                                    name: data.title,
                                    eventJobImage: data.coverImage,
                                                                        location:
                                    data.address,
                                    verificationIcon: Icons.verified,
                                    bookmarkOnPressed: () {},
                             
                                  ),
                                ),
                              );
                            },
                          ),
                        ):Center(child: Text("No Data Found"),),
        
        
                        SizedBox(height: 130.h,)
        
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
        },
        ),
      ),
    );
  }



}
