// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:event_ease/features/auth/presentation/models/my_model/check_list_model.dart';
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/app_url.dart';
import 'package:event_ease/features/auth/presentation/widgets/common_image.dart';
import 'package:event_ease/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ChecklistDetailsScreen extends StatefulWidget {
  CheckListModel items;
  ChecklistDetailsScreen({super.key, required this.items});

  @override
  State<ChecklistDetailsScreen> createState() => _ChecklistDetailsScreenState();
}

class _ChecklistDetailsScreenState extends State<ChecklistDetailsScreen> {
  // Replace these paths with your actual image assets
  final List<String> firstNineImages = [
    'assets/checklist/Frame.svg',
    'assets/checklist/Frame (1).svg',
    'assets/checklist/Frame (2).svg',
    'assets/checklist/Frame (3).svg',
    'assets/checklist/Frame (4).svg',
    'assets/checklist/Frame (5).svg',
    'assets/checklist/Frame (6).svg',
    'assets/checklist/Frame (7).svg',
    'assets/checklist/Frame (8).svg',
  ];

  final String otherImage = 'assets/checklist/Frame (9).svg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.items.checklistName),
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          GestureDetector(
            onTapDown: (details) async {
              final RenderBox overlay =
                  Overlay.of(context).context.findRenderObject() as RenderBox;

              final selected = await showMenu<String>(
                context: context,
                position: RelativeRect.fromRect(
                  details.globalPosition &
                      const Size(40, 40), // position near the tap
                  Offset.zero & overlay.size,
                ),
                items: [
                  PopupMenuItem(
                    value: 'rename',
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.edit_note_sharp),
                        SizedBox(width: 8),
                        Text(
                          'Edit',
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.delete_forever_outlined,
                          color: Colors.red.shade700,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Delete',
                          style: TextStyle(color: Colors.red.shade700),
                        ),
                      ],
                    ),
                  ),
                ],
                elevation: 8.0,
              );

              if (selected == 'rename') {
                _showEditCheckListFolderDialog(context, widget.items, (name) {
                  widget.items.checklistName = name;
                  setState(() {});
                });
              } else if (selected == 'delete') {
                _showDeleteDialog(widget.items);
              }
            },
            child: Icon(Icons.menu, color: AppColors.primary),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: widget.items.items.length,
        itemBuilder: (context, index) {
          final item = widget.items.items[index];
          String imagePath = (index < 9) ? firstNineImages[index] : otherImage;

          bool isLoading = false; // local loading state for this item

          return StatefulBuilder(
            builder: (context, setItemState) {
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CommonImage(
                    imageSrc: imagePath,
                    imageType: ImageType.svg,
                    width: 24,
                    height: 24,
                  ),
                ),
                title: Text(item.itemName),
                trailing:
                    isLoading
                        ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                item.isChecked
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                color:
                                    item.isChecked
                                        ? AppColors.primary
                                        : AppColors.grey,
                              ),
                              onPressed: () async {
                                setItemState(() => isLoading = true);

                                try {
                                  final response = await ApiService.to.patchApi(
                                    AppUrl.updateCheckListIteamsStatus,
                                    {
                                      "checkListId": widget.items.id,
                                      "itemId": item.id,
                                      "isChecked": !item.isChecked,
                                    },
                                  );

                                  if (response.success) {
                                    setState(() {
                                      widget.items.items[index] = ChecklistItem(
                                        id: item.id,
                                        itemName: item.itemName,
                                        isChecked: !item.isChecked,
                                        createdAt: item.createdAt,
                                      );
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(response.message),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Error: $e"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                } finally {
                                  setItemState(() => isLoading = false);
                                }
                              },
                            ),

                            if (index >= 9)
                              InkWell(
                                onTap: () async {
                                  setItemState(() => isLoading = true);

                                  try {
                                    final response = await ApiService.to
                                        .patchApi(
                                          AppUrl.deleteCheckListIteamsStatus,
                                          {
                                            "checkListId": widget.items.id,
                                            "itemId": item.id,
                                          },
                                        );

                                    if (response.success) {
                                      setState(() {
                                        widget.items.items.removeAt(index);
                                      });
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(response.message),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Error: $e"),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  } finally {
                                    setItemState(() => isLoading = false);
                                  }
                                },
                                child: Icon(
                                  Icons.delete_forever_outlined,
                                  size: 32,
                                  color: Colors.red.shade700,
                                ),
                              ),
                          ],
                        ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddChecklistItemDialog(context, (String itemName) async {
            // Add new item to your list
            final response = await ApiService.to.postApi(
              AppUrl.createCheckListItem,
              {
                "checklistName": widget.items.checklistName,
                "itemName": itemName,
              },
            );

            if (response.success) {
              CheckListModel checklist = CheckListModel.fromJson(response.data);

              // Access the items list
              List<ChecklistItem> items = checklist.items;

              // Use setState to update your UI
              setState(() {
                widget.items.items =
                    items; // assuming widget.items is your list in the page
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(response.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          });
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _showAddChecklistItemDialog(
    BuildContext context,
    Function(String) onCreate,
  ) {
    final TextEditingController itemController = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Add Checklist Item".tr,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: itemController,
                      decoration: InputDecoration(
                        labelText: "Item Name".tr,
                        labelStyle: TextStyle(color: AppColors.primary),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.primary.withOpacity(0.5),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
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
                          onPressed:
                              isLoading
                                  ? null
                                  : () async {
                                    if (itemController.text.isEmpty) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Please enter item name",
                                          ),
                                        ),
                                      );
                                      return;
                                    }
                                    setState(() {
                                      isLoading = true;
                                    });

                                    onCreate(
                                      itemController.text,
                                    ); // Callback to add item

                                    setState(() {
                                      isLoading = false;
                                    });
                                    Navigator.of(context).pop();
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
                                    width: 20,
                                    height: 20,
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
            );
          },
        );
      },
    );
  }

  void _showEditCheckListFolderDialog(
    BuildContext context,
    CheckListModel data,
    callFree(String),
  ) {
    final TextEditingController checklistController = TextEditingController(
      text: data.checklistName,
    );

    showDialog(
      context: context,
      builder: (context) {
        File? selectedImage;
        bool isLoading = false;

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
                        "Update CheckList Folder",
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
                          labelText: "CheckList Name",
                          labelStyle: TextStyle(color: Colors.purple[700]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
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
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child:
                                selectedImage != null
                                    ? Image.file(
                                      selectedImage!,
                                      height: 140,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    )
                                    : (data.image.isNotEmpty
                                        ? Image.network(
                                          data.image,
                                          height: 140,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        )
                                        : Container(
                                          height: 140,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.purple.shade50,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color: AppColors.primary,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.image,
                                            size: 50,
                                            color: AppColors.primary,
                                          ),
                                        )),
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
                              label: Text("Upload Image"),
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
                              "Cancel",
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ),
                          SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () async {
                              setState(() => isLoading = true);

                              final response =
                                  (selectedImage != null)
                                      ? await ApiService.to.multipartData(
                                        AppUrl.updateCheckList(data.id),
                                        {
                                          "updateChecklistName":
                                              checklistController.text,
                                        },
                                        multipartBody: [
                                          MultipartBody(
                                            "image",
                                            selectedImage!,
                                          ),
                                        ],
                                        method: "PATCH",
                                      )
                                      : await ApiService.to.patchApi(
                                        AppUrl.updateCheckList(data.id),
                                        {
                                          "updateChecklistName":
                                              checklistController.text,
                                        },
                                      );

                              setState(() => isLoading = false);

                              if (response.success) {
                                callFree(checklistController.text);
                                Navigator.of(context).pop();
                              }
                            },
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
                                    : Text("Update"),
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
    ).then((value) {});
  }

  void _showDeleteDialog(CheckListModel data) {
    bool isDeleting = false; // track loading

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder:
              (context, setState) => Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.delete_forever,
                        color: Colors.red.shade700,
                        size: 50,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Delete Checklist',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Are you sure you want to delete this checklist? This action cannot be undone.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OutlinedButton(
                            onPressed:
                                isDeleting
                                    ? null
                                    : () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: AppColors.primary),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: AppColors.primary),
                            ),
                          ),
                          ElevatedButton(
                            onPressed:
                                isDeleting
                                    ? null
                                    : () async {
                                      setState(() {
                                        isDeleting = true;
                                      });

                                      final response = await ApiService.to
                                          .deleteApi(
                                            AppUrl.deleteCheckList(data.id),
                                          );

                                      if (response.success) {
                                        Navigator.of(
                                          context,
                                        ).popUntil((route) => route.isFirst);
                                        // controller.getCheckList(); // refresh
                                      } else {
                                        setState(() {
                                          isDeleting = false;
                                        });
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(response.message),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade700,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child:
                                isDeleting
                                    ? SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : const Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.white),
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
  }
}
