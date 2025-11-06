import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/utils/app_url.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import '../../widgets/custom_button.dart';

class GiveReviewScreen extends StatefulWidget {
  GiveReviewScreen({super.key});

  @override
  State<GiveReviewScreen> createState() => _GiveReviewScreenState();
}

class _GiveReviewScreenState extends State<GiveReviewScreen> {
  final bioController = TextEditingController();

  num? ratting;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          top: 10,
          bottom: 10,
        ),
        child: Column(
          children: [
            Text(
              AppString.leaveReviewFor,
              style: styleForNormalText.copyWith(
                fontSize: 24,
                color: AppColors.darkGrey,
              ),
            ),
            SizedBox(height: 20),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              itemCount: 5,
              itemSize: 35,
              direction: Axis.horizontal,
              itemPadding: EdgeInsets.symmetric(horizontal: 4),
              allowHalfRating: true,
              itemBuilder:
                  (context, index) => Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (rating) {
                ratting = rating;
                setState(() {});
              },
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.textFieldBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: TextField(
                controller: bioController,
                maxLines: 3, // Maximum number of lines
                maxLength: 100,

                decoration: InputDecoration(
                  counterText: "",
                  contentPadding: EdgeInsets.all(10),
                  hintText: "${AppString.writeReview}...",
                  hintStyle: styleForNormalText.copyWith(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 20),

            SizedBox(height: 20),
            Obx(
               () {
                return CustomButton(text: AppString.submitReview,   onTap: () {
                    if (ratting == null || ratting!.isNaN) {
                      Get.snackbar("Error".tr,"Please give a ratting");
                      return;
                    }
                    if (bioController.text.isEmpty) {
                      Get.snackbar("Error".tr,"Please leave a comment");
                      return;
                    }
                
                    final args = Get.arguments as Map<String, dynamic>;
                    final type = args['type'] as String;
                    final id = args['id'] as String;
                    postReview(
                      id: id,
                      text: bioController.text,
                      rating: ratting!,
                      type: type,
                      // (type=="business")?AppUrl.postBusinessReview:(type=="event")?AppUrl.postEventReview:AppUrl.postJobReview
                    );
                  },isLoading: isLoading.value,);
              }
            ),
          ],
        ),
      ),
    );
  }
  RxBool isLoading=false.obs;
Future<bool> postReview({
  required String id,
  required String text,
  required num rating,
  required String type,
}) async {
  isLoading.value=true;
  try {
    final Map<String, dynamic> body = {
      "${type}Id": id,
      "comment": text, // or "reviewText": text, check your API spec
      "rating": rating,
    };

    final ApiResponse response = await ApiService.to.postApi(
      AppUrl.postReview(type),
      body,
    );

    if (response.success) {
      Get.back();
      Get.snackbar("Success".tr, "Review added successfully");

      return true;
    } else {
      Get.snackbar("Failed".tr,response.message);
      return false;
    }
  } catch (e) {
    
    Get.snackbar("Error".tr,"Something went wrong: $e");
    return false;
  }finally{
isLoading.value=false;
  }
}

}
