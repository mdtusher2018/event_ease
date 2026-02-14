import 'dart:developer';
import 'dart:io';

import 'package:event_ease/features/auth/presentation/screen/regular/favorite/checklist_details_screen.dart';
import 'package:event_ease/features/auth/presentation/utils/app_url.dart';
import 'package:event_ease/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../controller/favorite/favorite_controller.dart';
import '../../../models/my_model/folder_model.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_string.dart';
import '../../../utils/styles.dart';
import '../../../widgets/common_image.dart';
import 'package:path/path.dart' as path;

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FavoriteController controller = Get.find<FavoriteController>();

  @override
  void initState() {
    super.initState();
    final selectedTabIndex = Get.arguments?['tab'] ?? 0;
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: selectedTabIndex,
    );
    controller.getAllWishList();
    controller.getCheckList();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 40, left: 10, right: 10),
        child: Column(
          children: [
            Text(
              AppString.favorite,
              style: styleForBoldText.copyWith(
                fontSize: 28.sp,
                color: AppColors.darkGrey,
              ),
            ),
            SizedBox(height: 10.h),
            TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primary,
              labelColor: AppColors.primary,
              unselectedLabelColor: Colors.grey,
              labelStyle: styleForBoldText.copyWith(fontSize: 22.sp),
              onTap: (index) {
                if (index == 0) controller.getAllWishList();
                if (index == 1) controller.getCheckList();
              },
              tabs: [
                Tab(text: AppString.favorite),
                Tab(text: AppString.checklist),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [_buildFavoriteTab(), _buildChecklistTab()],
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
        onPressed: () {
          if (_tabController.index == 0) {
            _showCreateFavoriteFolderDialog(context);
          } else {
            _showCreateCheckListFolderDialog(context);
          }
        },
      ),
    );
  }

  void _showCreateFavoriteFolderDialog(BuildContext context) {
    final TextEditingController folderController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        File? selectedImage;

        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
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
                        "Create a favourite folder".tr,
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
                          labelText: "Folder name".tr,
                          labelStyle: TextStyle(color: Colors.purple[700]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.purple.shade200,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.purple,
                              width: 2,
                            ),
                          ),
                          prefixIcon: Icon(Icons.folder, color: Colors.purple),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
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
                              : Container(
                                height: 140,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.purple.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.primary),
                                ),
                                child: Icon(
                                  Icons.image,
                                  size: 50,
                                  color: AppColors.primary,
                                ),
                              ),
                          SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final ImagePicker picker = ImagePicker();
                                final XFile? image = await picker.pickImage(
                                  source: ImageSource.gallery,
                                );
                                if (image != null) {
                                  setState(() {
                                    selectedImage = File(image.path);
                                  });
                                }
                              },
                              icon: Icon(Icons.upload_file),
                              label: Text("Upload image".tr),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
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
                              "Cancel".tr,
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ),
                          SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () async {
                              if (folderController.text.isEmpty) {
                                Get.snackbar(
                                  "Empty",
                                  "Please enter folder name",
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                                // ScaffoldMessenger.of(context).showSnackBar(
                                //   SnackBar(content: Text("Please enter folder name")),
                                // );
                                return;
                              }
                              if (selectedImage == null) {
                                Get.snackbar(
                                  "Empty",
                                  "Please select an image",
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                                // ScaffoldMessenger.of(context).showSnackBar(
                                //   SnackBar(content: Text("Please select an image")),
                                // );
                                return;
                              }

                              // TODO: Save folder name + image
                              print("Folder: ${folderController.text}");
                              print("Image Path: ${selectedImage!.path}");

                              final response = await ApiService.to
                                  .multipartData(
                                    AppUrl.createFolder,
                                    {"folderName": folderController.text},
                                    multipartBody: [
                                      MultipartBody("image", selectedImage!),
                                    ],
                                  );

                              if (response.success) {
                                Navigator.of(context).pop();
                              }
                            },
                            child: Text("Create"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
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
    ).then((value) {
      controller.getCheckList();
      controller.getAllWishList();
      setState(() {});
    });
  }

  void _showCreateCheckListFolderDialog(BuildContext context) {
    final TextEditingController checklistController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        File? selectedImage;
        bool isLoading = false; // Add this

        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
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
                        "Create a CheckList Folder".tr,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple[700],
                        ),
                      ),
                      SizedBox(height: 20),

                      // Folder Name Input
                      TextField(
                        controller: checklistController,
                        decoration: InputDecoration(
                          labelText: "CheckList Name".tr,
                          labelStyle: TextStyle(color: Colors.purple[700]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.purple.shade200,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.purple,
                              width: 2,
                            ),
                          ),
                          prefixIcon: Icon(Icons.folder, color: Colors.purple),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
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
                              : Container(
                                height: 140,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.purple.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.primary),
                                ),
                                child: Icon(
                                  Icons.image,
                                  size: 50,
                                  color: AppColors.primary,
                                ),
                              ),
                          SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final ImagePicker picker = ImagePicker();
                                final XFile? image = await picker.pickImage(
                                  source: ImageSource.gallery,
                                );
                                if (image != null) {
                                  setState(() {
                                    selectedImage = File(image.path);
                                  });
                                }
                              },
                              icon: Icon(Icons.upload_file),
                              label: Text("Upload Image".tr),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
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
                              "Cancel".tr,
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ),
                          SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () async {
                              if (checklistController.text.isEmpty) {
                                Get.snackbar(
                                  "Empty",
                                  "Please enter checklist name",
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                                // ScaffoldMessenger.of(context).showSnackBar(
                                //   SnackBar(content: Text("Please enter folder name")),
                                // );
                                return;
                              }
                              if (selectedImage == null) {
                                Get.snackbar(
                                  "Empty",
                                  "Please select an image",
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                                // ScaffoldMessenger.of(context).showSnackBar(
                                //   SnackBar(content: Text("Please select an image")),
                                // );
                                return;
                              }

                              setState(() => isLoading = true); // start loading
                              // TODO: Save folder name + image
                              print("Folder: ${checklistController.text}");
                              print("Image Path: ${selectedImage!.path}");

                              final response = await ApiService.to
                                  .multipartData(
                                    AppUrl.createCheckList,
                                    {"checklistName": checklistController.text},
                                    multipartBody: [
                                      MultipartBody("image", selectedImage!),
                                    ],
                                  );
                              setState(() => isLoading = false); // stop loading
                              if (response.success) {
                                Navigator.of(context).pop();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child:
                                isLoading
                                    ? SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : Text("Create".tr),
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
    ).then((value) {
      controller.getCheckList();
    });
  }

  Widget _buildFavoriteTab() {
    return Obx(() {
      if (controller.folderList.isEmpty) {
        return Center(child: Text(AppString.noDataFound));
      }
      return GridView.builder(
        padding: const EdgeInsets.symmetric(vertical: 0),
        itemCount: controller.folderList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          mainAxisExtent: 240,
        ),
        itemBuilder: (context, index) {
          FolderModel folder = controller.folderList[index];
          return _buildCategorySection(folder, () {
            controller.getWishListFolder(folder.folderName);
          });
        },
      );
    });
  }

  Widget _buildChecklistTab() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return ListView.builder(
        padding: const EdgeInsets.only(top: 10, bottom: 90),
        itemCount: controller.checkListModel.length,
        itemBuilder: (context, index) {
          final data = controller.checkListModel[index];

          return GestureDetector(
            onTap: () async {
              Get.to(ChecklistDetailsScreen(items: data))!.then((value) {
                controller.getCheckList();
              });
            },
            child: ListTile(
              leading: CommonImage(
                imageSrc: data.image,
                imageType: ImageType.network,
                borderRadius: 50,
                height: 50,
                width: 50,
              ),
              title: Text(
                data.checklistName,
                style: styleForBoldText.copyWith(
                  color: AppColors.primary,
                  fontSize: 22.sp,
                ),
              ),
              subtitle: Text(
                "${data.checkedItemsCount} Check",
                style: styleForNormalText.copyWith(fontSize: 20.sp),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_outlined,
                color: AppColors.primary,
              ),
            ),
          );
          // : Center(child: Text(AppString.noDataFound, style: styleForNormalText.copyWith(fontSize: 18),),)
        },
      );
    });
  }

  Widget _buildCategorySection(FolderModel model, VoidCallback? onTap) {
    final folderImages = <String>[
      ...model.businesses.map((e) => e.coverImage),
      ...model.events.map((e) => e.coverImage),
      ...model.jobs.map((e) => e.coverImage),
    ];

    var isActive = model.isActive;

    // Ensure the grid always shows 4 items
    final displayedImages =
        folderImages.length >= 4
            ? folderImages.take(4).toList()
            : [
              ...folderImages,
              ...List.generate(
                4 - folderImages.length,
                (index) => '',
              ), // empty placeholders
            ];

    return isActive
        ? InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 200,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 4,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemBuilder: (context, index) {
                    String imageUrl = displayedImages[index];

                    // If image is empty (placeholder), show empty box or a default image
                    if (imageUrl.isEmpty) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                      );
                    }

                    String fileName = path.basename(imageUrl);
                    String extension = path
                        .extension(fileName)
                        .replaceFirst('.', '');

                    log("Image URL: $imageUrl");
                    log("Extension: $extension");

                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child:
                          extension == "svg"
                              ? CommonImage(
                                imageSrc: imageUrl,
                                imageType: ImageType.networkSvg,
                              )
                              : CommonImage(
                                imageSrc: imageUrl,
                                imageType: ImageType.network,
                              ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Text(
                model.folderName,
                style: styleForBoldText.copyWith(
                  color: AppColors.darkGrey,
                  fontSize: 18.sp,
                ),
              ),
            ],
          ),
        )
        : const SizedBox();
  }
}
