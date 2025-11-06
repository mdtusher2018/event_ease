
import 'package:event_ease/features/auth/presentation/screen/business/sponsorship/api/sponsorship_business_controller.dart';
import 'package:event_ease/features/auth/presentation/screen/business/sponsorship/detail_screen/business_profile_card_screen.dart';
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/styles.dart';

class SponsorshipBusinessPage extends StatefulWidget {

  const SponsorshipBusinessPage({super.key});

  @override
  State<SponsorshipBusinessPage> createState() => _SponsorshipBusinessPageState();
}

class _SponsorshipBusinessPageState extends State<SponsorshipBusinessPage> {
  final TextEditingController searchController = TextEditingController();
SponsorshipBusinessListController controller= Get.put(SponsorshipBusinessListController());



  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Business",style: TextStyle(fontSize: 21,fontWeight: FontWeight.bold),),centerTitle: true,backgroundColor: AppColors.white,surfaceTintColor: Colors.transparent,),
      body:     Padding(
      padding: const EdgeInsets.all(16.0),
      child: Obx(
        () {
          if(controller.isLoading.value){
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: controller.businessList.length,
            itemBuilder: (context, index) {
              final business = controller.businessList[index];
              return ListTile(
                leading: SvgPicture.asset(AppIcons.businessIcon),
                title: Text(
                  business.name,
                  style: styleForNormalText.copyWith(fontSize: 16.sp),
                ),
                onTap: () {
          // DashboardScreen.status="business";
          // DashboardScreen.deshBoardController.fetchDeshBoardDetails(parentBusinessId: filteredResults[index].id,status: "business");
          // Get.back();
          Get.to(BusinessProfileCardScreen(id: controller.businessList[index].id,businessName: controller.businessList[index].name,));
                },
          
              );
            },
          );
        }
      ),
    )
  
  
    );
    

  }
}
