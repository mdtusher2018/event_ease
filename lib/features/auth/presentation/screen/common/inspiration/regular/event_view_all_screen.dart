// import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
// import 'package:event_ease/features/auth/presentation/utils/styles.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
//
// import '../../../../../../../core/routers/routes_name.dart';
// import '../../../../widgets/regular/inspiration/custom_profile_container.dart';
//
// class EventViewAllScreen extends StatelessWidget {
//   const EventViewAllScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Text(AppString.realWedding, style: styleForBoldText.copyWith(fontSize: 24.sp),),
//       ),
//       body: GridView.builder(
//         padding: EdgeInsets.all(10),
//         itemCount: 12,
//           shrinkWrap: true,
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//             mainAxisExtent: 150,
//             crossAxisSpacing: 10,
//             mainAxisSpacing: 5
//           ),
//           itemBuilder: (context, index) {
//             return InkWell(
//                 onTap: (){Get.toNamed(RoutesName.eventProfile);},
//                 child: CustomProfileContainer());
//           },),
//     );
//   }
// }
