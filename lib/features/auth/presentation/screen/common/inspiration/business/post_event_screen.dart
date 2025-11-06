import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_button.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../utils/app_colors.dart';

class PostEventScreen extends StatefulWidget {
  const PostEventScreen({super.key});

  @override
  State<PostEventScreen> createState() => _PostEventScreenState();
}

class _PostEventScreenState extends State<PostEventScreen> {
  TextEditingController eventTitleController = TextEditingController();

  TextEditingController eventShortDescriptionController = TextEditingController();

  TextEditingController eventDetailedDescriptionController = TextEditingController();

  bool  galleryUploaded= false;

  bool coverImage = false;

  String? selectedCategory;

  final List<String> categories = [
    'ideas & tips',
    'real events',
    'style & outfits',
    'decor & setup',
    'dream locations',
    'food & drink',
    'music & entertainment',
    'ideas for every occasion',
    'more',
    'getting started ideas',
    'seasonal trends',
    'real events that inspire',
    'stile & mood'
  ];

  void uploadImage(String type) {
    // Simulate image upload
    setState(() {
      if (type == 'cover') coverImage = true;
      if (type == 'gallery') galleryUploaded = true;
    });

    Get.snackbar(
        "Upload Successful",
        "$type image uploaded successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(AppString.eventGallery, style: styleForBoldText.copyWith(fontSize: 24.sp),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppString.title, style: styleForBoldText.copyWith(fontSize: 18.sp),),
            SizedBox(height: 5.h,),
            CustomTextField(hintText: AppString.eventTitle, isSuffix: false, controller: eventTitleController),
            SizedBox(height: 10.h,),
            Text(AppString.category, style: styleForBoldText.copyWith(fontSize: 18.sp),),
            SizedBox(height: 5.h,),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                fillColor: AppColors.textFieldBg,
                filled: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: AppColors.primary,width: 2), // Purple border
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: AppColors.primary,width: 2), // Purple border
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: AppColors.primary, width: 2), // Purple border thicker when focused
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: AppColors.primary,width: 2), // Purple border
                ),
              ),
              hint: Text(AppString.category, style:  styleForNormalText.copyWith(color: AppColors.grey, fontSize: 14.sp, fontWeight: FontWeight.w400)),
              value: selectedCategory,
              items: categories
                  .map((cat) => DropdownMenuItem<String>(
                value: cat,
                child: Text(cat,style: styleForNormalText.copyWith(color: Colors.black, fontSize: 15.sp, fontWeight: FontWeight.w500),),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
            ),
            SizedBox(height: 10.h,),
            Row(
              children: [
                Text("${AppString.coverImage} *", style: styleForBoldText.copyWith(fontSize: 18.sp)),
                 SizedBox(width: 5.w),
                coverImage
                    ? Icon(Icons.check_circle, color: Colors.green)
                    : Container(),
              ],
            ),
             SizedBox(height: 5.h),
            InkWell(
              onTap: () => uploadImage('logo'),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.primary
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.upload, color: Colors.white),
                     SizedBox(width: 8.w),
                    Text(
                      coverImage ? AppString.changeImage : AppString.uploadImage,
                      style: styleForBoldText.copyWith(color: Colors.white, fontSize: 18.sp),
                    )
                  ],
                ),
              ),
            ),

             SizedBox(height: 20.h),

            // Cover Image Section
            Row(
              children: [
                Text(AppString.imageGallery, style: styleForBoldText.copyWith(fontSize: 18.sp)),
                 SizedBox(width: 5.w),
                galleryUploaded
                    ? Icon(Icons.check_circle, color: Colors.green)
                    : Container(),
              ],
            ),
             SizedBox(height: 5.h),
            InkWell(
              onTap: () => uploadImage('cover'),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.primary
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.upload, color: Colors.white),
                     SizedBox(width: 8.w),
                    Text(
                      galleryUploaded ? AppString.changeImage : AppString.uploadImage,
                      style: styleForBoldText.copyWith(color: Colors.white, fontSize: 18.sp),
                    )
                  ],
                ),
              ),
            ),
            Spacer(),
            
            CustomButton(text: AppString.post, borderRadius: 16,),



          ],
        ),
      ),
    );
  }
}
