// ignore_for_file: must_be_immutable

import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../controller/inspiration/inspiration_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../widgets/regular/inspiration/custom_idea_container.dart';

class IdeaAdviceScreen extends StatelessWidget {
  IdeaAdviceScreen({super.key});

  InspirationController controller = Get.find<InspirationController>();

  bool routeData = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Obx(
          () => Text(
            controller.categoryName.value,
            style: styleForBoldText.copyWith(
              color: AppColors.primary,
              fontSize: 24.sp,
            ),
          ),
        ),
      ),
      body: Obx(
        () => (routeData == true && controller.groupCategoryViewAllList.isEmpty)?Center(child: Text("No data found")):(routeData == false && controller.specificCategoryList.isEmpty)? Center(child: Text("No data found")):  ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount:
              routeData == true
                  ? controller.groupCategoryViewAllList.length
                  : controller.specificCategoryList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            var data =
                routeData == true
                    ? controller.groupCategoryViewAllList[index]
                    : controller.specificCategoryList[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: InkWell(
                onTap: () {
                  // Get.toNamed(RoutesName.post);
                  controller.getCategoryDetails(data['_id']);
                },
                child: CustomIdeaContainer(
                  image: "${data['coverImage']}",
                  description: data['description'] ?? "",
                  title: data['title'] ?? "",
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
