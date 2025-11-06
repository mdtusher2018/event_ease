import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/routers/routes_name.dart';
import '../../../controller/notification/notification_controller.dart';
import '../../../utils/app_url.dart';
import '../../../utils/styles.dart';
import '../../../widgets/custom_notification_content_card.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationController controller = Get.find<NotificationController>();


  String formatTimestampToReadable(String timestamp) {
    final dateTime = DateTime.parse(timestamp).toLocal();
    final now = DateTime.now();

    final isToday = dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;

    final isYesterday = dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day - 1;

    final timeFormat = DateFormat('h:mm a'); // e.g., 10:15 AM
    final dateFormat = DateFormat('MMM d');  // e.g., Jul 8

    if (isToday) {
      return "Today at ${timeFormat.format(dateTime)}";
    } else if (isYesterday) {
      return "Yesterday at ${timeFormat.format(dateTime)}";
    } else {
      return "${dateFormat.format(dateTime)} at ${timeFormat.format(dateTime)}";
    }
  }

  @override
  void initState() {
    super.initState();
    controller.getNotification();
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
          AppString.notification,
          style: styleForBoldText.copyWith(
            color: AppColors.primary,
            fontSize: 24.sp,
          ),
        ),
      ),
      body: Obx((){
        return ListView.builder(
          itemCount: controller.notificationList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            var data = controller.notificationList[index];
            return InkWell(
              onTap: (){

                final type = data.message.types;

                if(data.type == "BusinessNotification" || data.type == "EventNotification" || data.type == "JobNotification"){
                  switch (type) {
                    case "business":
                      Get.toNamed(RoutesName.businessDetail, arguments: data.message.notificationFor);
                      break;
                    case "event":
                      Get.toNamed(RoutesName.eventDetailScreen, arguments: data.message.notificationFor);
                      break;
                    case "job":
                      Get.toNamed(RoutesName.jobDetailScreen, arguments: data.message.notificationFor);
                      break;
                    default:
                      Get.snackbar("Unknown Type", "No valid type found for this notification.");
                  }

                }else{

                }
              },
              child: GestureDetector(
                onTap: () {
                
                  if(data.type=="review"){
if (data.type == "review") {
  showReviewDialog(
    type: data.message.types,
    id: data.message.notificationFor,
  );
}
                  }
                },
                child: CustomNotificationContentCard(
                    avatar: data.message.image,
                    message: data.message.text,
                    name:data.message.name,
                    timestamp:  formatTimestampToReadable(data.createdAt)//"Today at 10:15 AM",
                ),
              ),
            );
          },
        );
      }),


    );
  }




void showReviewDialog({required String type, required String id}) {
  final TextEditingController bioController = TextEditingController();
  num? rating;

  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Leave a Review",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 20),
              RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                itemCount: 5,
                itemSize: 35,
                allowHalfRating: true,
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (value) {
                  rating = value;
                },
              ),
              SizedBox(height: 15),
              TextField(
                controller: bioController,
                maxLines: 3,
                maxLength: 100,
                decoration: InputDecoration(
                  hintText: "Write your review...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  if (rating == null || rating!.isNaN) {
                    Get.snackbar("Error".tr,"Please give a rating");
                    return;
                  }
                  if (bioController.text.isEmpty) {
                    Get.snackbar("Error".tr,"Please leave a comment");
                    return;
                  }

                 await postReview(
                    id: id,
                    text: bioController.text,
                    rating: rating!,
                    type: type,
                  );

               
                },
                child: Text("Submit Review"),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Future<bool> postReview({
  required String id,
  required String text,
  required num rating,
  required String type,
}) async {
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
  }
}




}
