
import 'dart:developer';
import 'dart:io';

import 'package:event_ease/core/helper/other_helper.dart';
import 'package:event_ease/engagment%20handle/comment_bottomsheet.dart';
import 'package:event_ease/engagment%20handle/engagment.dart';
import 'package:event_ease/features/auth/presentation/controller/favorite/favorite_controller.dart';
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/common_image.dart';
import 'package:event_ease/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../../core/routers/routes_name.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/app_url.dart';
import '../../../widgets/custom_feature_event_container.dart';

class FavoriteDetailScreen extends StatefulWidget {
  FavoriteDetailScreen({super.key});

  @override
  State<FavoriteDetailScreen> createState() => _FavoriteDetailScreenState();
}

class _FavoriteDetailScreenState extends State<FavoriteDetailScreen> {
  final FavoriteController controller = Get.find<FavoriteController>();

RxString folderName="".obs;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    folderName.value= controller.seeAllFolderModel.folderName;
  }


void showEditFolderDialog(BuildContext context) {
  final TextEditingController folderController =
      TextEditingController(text: controller.seeAllFolderModel.folderName);

  final oldFolderName = controller.seeAllFolderModel.folderName;
  File? selectedImage;
log(controller.seeAllFolderModel.image+"............");
  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 8,
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Edit Folder",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple[700],
                      ),
                    ),
                    SizedBox(height: 20),

                    // Folder Name Input
                    TextField(
                      controller: folderController,
                      decoration: InputDecoration(
                        labelText: "Folder Name",
                        labelStyle: TextStyle(color: Colors.purple[700]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.purple.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.purple, width: 2),
                        ),
                        prefixIcon: Icon(Icons.folder, color: Colors.purple),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Image Picker
                    Column(
                      children: [
                        selectedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  selectedImage!,
                                  height: 140,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : (controller.seeAllFolderModel.image.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      controller.seeAllFolderModel.image,
                                      height: 140,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Container(
                                    height: 140,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.purple.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: AppColors.primary),
                                    ),
                                    child: Icon(Icons.image,
                                        size: 50, color: AppColors.primary),
                                  )),
                        SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              final ImagePicker picker = ImagePicker();
                              final XFile? image = await picker.pickImage(
                                  source: ImageSource.gallery);
                              if (image != null) {
                                setState(() {
                                  selectedImage = File(image.path);
                                });
                              }
                            },
                            icon: Icon(Icons.upload_file),
                            label: Text("Upload Image"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () async {
                            if (folderController.text.trim().isEmpty) {
                              Get.snackbar("Empty", "Folder name can't be empty",
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white);
                              return;
                            }

                            // API call to update folder name & image
                            final response =
                                await ApiService.to.multipartData(
                              AppUrl.updateFolderName,method: "PATCH",
                              {
                                "oldFolderName": oldFolderName,
                                "newFolderName": folderController.text.trim(),
                              },
                              multipartBody: selectedImage != null
                                  ? [MultipartBody("image", selectedImage!)]
                                  : [],
                            );

                            if (response.success) {
                              folderName.value =
                                  folderController.text.trim();
                              controller.getAllWishList();
                              Get.snackbar("Success".tr, "Folder updated successfully",
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white);
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text("Save"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}





void showDeleteDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          "Delete Folder",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.red,
          ),
        ),
        content: const Text(
          "Are you sure you want to delete this collection? This action cannot be undone.",
          style: TextStyle(fontSize: 14),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.black),
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async{
         
              // controller.updateFolderName(textController.text);
              final response=await ApiService.to.patchApi(AppUrl.deleteFolder, {
                         "folderName": folderName.value,
              });
        
              if(response.success){
                      // Pop all routes until the first
  Navigator.of(Get.context!).popUntil((route) => route.isFirst);
                controller.getAllWishList();
                Get.snackbar("Successfull", "Folder deleted sucessfully");
           
              }
            },
            child: const Text("Delete"),
          ),
        ],
      );
    },
  );
}








  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Obx(
          () {
            return Text(
              folderName.value,
              style: styleForBoldText.copyWith(fontSize: 24.sp),
            );
          }
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == "edit") {
                showEditFolderDialog(context);
              } else if (value == "delete") {
                showDeleteDialog(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: "edit",
                child: Text("Edit"),
              ),
              const PopupMenuItem(
                value: "delete",
                child: Text("Delete"),
              ),
            ],
          ),
        ],
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
body: Obx(() {
  if (controller.allFolderList.isEmpty) {
    return const Center(child: Text("No Favorite Found",style: TextStyle(color: AppColors.primary,fontSize: 21,fontWeight: FontWeight.bold),));
  }

  // Separate lists
  final businessList = controller.allFolderList.where((e) => e.type == "business").toList();
  final eventList = controller.allFolderList.where((e) => e.type == "event").toList();
  final jobList = controller.allFolderList.where((e) => e.type == "job").toList();

  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (businessList.isNotEmpty) buildSection("Businesses", businessList),
        if (eventList.isNotEmpty) buildSection("Events", eventList),
        if (jobList.isNotEmpty) buildSection("Jobs", jobList),
      ],
    ),
  );
}),
    );
  }







Widget buildSection(String title, List<dynamic> items) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Text(
          title,
          style: styleForBoldText.copyWith(fontSize: 20.sp),
        ),
      ),
      SizedBox(
        height: 370,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          itemBuilder: (context, index) {
            final data = items[index];
            final id = data.id;
            final type = data.type;
            final imageUrl = data.coverImage ?? "";
            final extension = imageUrl.split(".").last;

            return SizedBox(
              width: 288,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: CustomFeatureEventContainer(
                  isLiked: data.isLiked,
                  bookType: type == "business"
                      ? "businessId"
                      : type == "event"
                          ? "eventId"
                          : "jobId",
                  id: id,
                  onTap: () {
                    if (type == "business") {
                      Get.toNamed(RoutesName.businessDetail, arguments: id);
                    } else if (type == "event") {
                      Get.toNamed(RoutesName.eventDetailScreen, arguments: id);
                    } else {
                      Get.toNamed(RoutesName.jobDetailScreen, arguments: id);
                    }
                  },
                  typeStatus: type,
                  type: type == "business" ? data.providerType : data.category,
                  typeImage: type == "job"
                      ? AppIcons.jobIcon
                      : type == "event"
                          ? AppIcons.eventIcon
                          : AppIcons.businessIcon,
                  name: type == "job" ? data.title : data.name,
                  imageType: extension == "svg"
                      ? ImageType.networkSvg
                      : ImageType.network,
                  location: data.address,
                  peopleCount: type == "job"
                      ? null
                      : type == "event"
                          ? OtherHelper.getDate(serverDate: data.createdAt)
                          : data.maxGuest.toString(),
                  rating: data.averageRating.toString(),
                  doller:  data.priceRange.toLowerCase() == "budget"
    ? "€"
    : data.priceRange.toLowerCase() == "medium"
        ? "€€"
        : data.priceRange.toLowerCase() == "high"
            ? "€€€"
            : "€€€€",

                  imageSrc: data.coverImage,
                  imageHeight: 190,
                  peopleCountIcon: type == "event"
                      ? SvgPicture.asset(AppIcons.calenderIcon, height: 18, width: 18)
                      : const Icon(Icons.people, size: 20),
                  verification: data.blueVerifiedBadge,
                  borderRadius: 8,
                  padding: 5,
                  verificationIcon: Icons.verified,
                  likeCount: data.totalLikes.toString(),
                  commentCount: data.totalComments.toString(),
                  likeOnPressed: () {
                    eventLikeUnlike(
                      isLike: data.isLiked,
                      eventId: id,
                    ).then((value) {
                      if (value) {
                        data.isLiked = !data.isLiked;
                        data.isLiked ? data.totalLikes++ : data.totalLikes--;
                        controller.allFolderList.refresh();
                      }
                    });
                  },
                  commentOnPressed: () {
                    showHomePageCommentBottomSheet(
                      context,
                      id: id,
                      isBussiness: type == "business",
                      commentController: TextEditingController(),
                    );
                  },
                  isWishlisted: data.isWishlisted,
                  bookmarkOnPressed: (result) async {
                    if (data.isWishlisted) {
                      final response = await ApiService.to.postApi(
                        AppUrl.removeBookmark,
                        {
                          type == "business"
                              ? "businessId"
                              : type == "event"
                                  ? "eventId"
                                  : "jobId": id,
                          "folderName": controller.seeAllFolderModel.folderName,
                        },
                      );
                      if (response.success) {
                        data.isWishlisted = false;
                        controller.allFolderList.refresh();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Bookmark removed successfully!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    }
                  },
                  unbookmark: true,
      
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}







}
