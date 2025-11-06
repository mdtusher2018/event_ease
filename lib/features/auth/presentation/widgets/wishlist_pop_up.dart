// ignore_for_file: must_be_immutable

import 'package:event_ease/features/auth/presentation/controller/favorite/favorite_controller.dart';
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_button.dart';
import 'package:event_ease/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:event_ease/features/auth/presentation/widgets/wish_list_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/my_model/folder_model.dart';

class WishlistPopUp extends StatefulWidget {
   WishlistPopUp({super.key, required this.id, required this.type,required this.callBackWishlisted});

  late String id;
  late String type;
  late Function(bool) callBackWishlisted;

  @override
  _WishlistPopUpState createState() => _WishlistPopUpState();
}

class _WishlistPopUpState extends State<WishlistPopUp> {
  TextEditingController searchController = TextEditingController();
  final WishlistManager wishlistManager = WishlistManager();



  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Center(
        child: Text(
          "Add to Wishlist",
          style: styleForBoldText.copyWith(fontSize: 24.sp),
        ),
      ),
      content: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        child: SingleChildScrollView(
          child: ListBody(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      hintText: "Type",
                      isSuffix: false,
                      controller: searchController,
                      contentPadding: 10,
                      borderRadius: 80,
                      backgroundColor: AppColors.textFieldBg,
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      FavoriteController.instance.createBookmark(id: widget.id, folderName: searchController.text,type: widget.type);
                      
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.primary,
                      child: Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...List.generate(
                    FavoriteController.instance.folderList.length,
                    (index) {
                      FolderModel data =
                          FavoriteController.instance.folderList[index];
                      return FavoriteController.instance.folderList.isEmpty
                          ? Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              "No items in wishlist",
                              style: styleForNormalText,
                            ),
                          )
                          : Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              children: [
                                Expanded(
                                  child: CustomButton(
                                    onTap: () {
                                      FavoriteController.instance.createBookmark(id: widget.id, folderName: data.folderName,type: widget.type).then((value) {
                                                   widget.callBackWishlisted(value);
                                      },);
                           
                                    },
                                    text: data.folderName,
                                    backgroundColor: AppColors.textFieldBg,
                                    borderColor: AppColors.primary,
                                    textColor: AppColors.primary,
                                    fontSize: 16,
                                    paddingVertical: 14,
                                  ),
                                ),
                                // const SizedBox(width: 10),
                                // IconButton(
                                //   icon: const Icon(Icons.delete, color: Colors.red),
                                //   onPressed: () {
                                //     setState(() {
                                //       wishlistManager.removeItem(item);
                                //     });
                                //   },
                                // ),
                              ],
                            ),
                          );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
