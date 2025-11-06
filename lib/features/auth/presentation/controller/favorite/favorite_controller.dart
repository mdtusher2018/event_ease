import 'dart:developer';

import 'package:event_ease/features/auth/data/repository/user_repository.dart';
import 'package:event_ease/features/auth/presentation/models/my_model/folder_model.dart';
import 'package:event_ease/features/auth/presentation/models/my_model/see_all_folder_model.dart';
import 'package:get/get.dart';

import '../../../../../core/routers/routes_name.dart';
import '../../models/my_model/check_list_model.dart';
import '../../models/my_model/favorite_item_model.dart';

class FavoriteController extends GetxController {
  static FavoriteController get instance => Get.find<FavoriteController>();
  UserRepository userRepository = UserRepository();

  RxBool isLoading = false.obs;
  RxBool isChecked = false.obs;
  RxList<CheckListModel> checkListModel = <CheckListModel>[].obs;
  RxList folderList = [].obs;

  SeeAllFolderModel seeAllFolderModel = SeeAllFolderModel();

  Future<void> getCheckList() async {
    isLoading.value = true;
    try {
      var response = await userRepository.getCheckList();
      if (response.statusCode == 200 || response.statusCode == 201) {
        List jsonList = response.data ?? [];

        checkListModel.value =
            jsonList.map((value) => CheckListModel.fromJson(value)).toList();

        log("Response controller : === $checkListModel");
        log("Success : === ${response.message}");
      } else {
        log("Error : === ${response.message}");
        // Get.snackbar("Error".tr,response.message);
      }
    } catch (e, s) {
      log(">>>>>>>>>> Error e : === $e");
      log(">>>>>>>>>> Error s : === $s");
    } finally {
      isLoading.value = false;
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Update checklist >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ///
  // Future<void> updateCheckList({
  //   required String folderName,
  //   required bool isActive,
  //   required String itemId
  // }) async {
  //   isLoading.value = true;
  //   try {
  //     var body = {"checklistName": folderName, "isChecked": isActive,    "itemId": itemId,};
  //     var response = await userRepository.updateCheckList(body);
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       log("Response controller : === ${response.data}");
  //       log("Success : === ${response.message}");
  //     } else {
  //       log("Error : === ${response.message}");
  //       Get.snackbar("Error".tr,response.message);
  //     }
  //   } catch (e, s) {
  //     log(">>>>>>>>>> Error e : === $e");
  //     log(">>>>>>>>>> Error s : === $s");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> all folder >>>>>>>>>>>>>>>>>>>>>>>

  Future<void> getAllWishList() async {
    isLoading.value = true;
    try {
      var response = await userRepository.getAllFolder();
      if (response.statusCode == 200 || response.statusCode == 201) {
        List jsonList = response.data["folders"] ?? [];

        folderList.clear();

        for (var i = 0; i < jsonList.length; i++) {
          var data = jsonList[i]["isActive"];
          if (data == true) {
            folderList.add(FolderModel.fromJson(jsonList[i]));
          }
        }

        log("Response controller : === $folderList");
        log("Success : === ${response.message}");
      } else {
        log("Error : === ${response.message}");
        // Get.snackbar("Error".tr,response.message);
      }
    } catch (e, s) {
      log(">>>>>>>>>> Error e : === $e");
      log(">>>>>>>>>> Error s : === $s");
    } finally {
      isLoading.value = false;
    }
  }


  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> wishList folder >>>>>>>>>>>>>>>>>>>>>>>

  RxList<FavoriteItemModel> allFolderList = <FavoriteItemModel>[].obs;

  Future<void> getWishListFolder(String folderName) async {
    isLoading.value = true;
    try {
      var response = await userRepository.getWishListFolder(folderName);
      if (response.statusCode == 200 || response.statusCode == 201) {
        seeAllFolderModel = SeeAllFolderModel.fromJson(response.data);
        allFolderList.clear();

        allFolderList.addAll(
          seeAllFolderModel.businesses.map((e) => FavoriteItemModel(
            id: e.id,
            name: e.name,isWishlisted: e.isWishlisted,
            coverImage: e.coverImage,
            address: e.address,
            subscriptionType: e.subscriptionType,
            createdAt: e.createdAt,
            averageRating: e.averageRating,
            totalReviews: e.totalReviews,
            totalLikes: e.totalLikes,
            totalComments: e.totalComments,
            isLiked: e.isLiked,
            isFollowed: e.isFollowed,
            blueVerifiedBadge: e.blueVerifiedBadge,
            maxGuest: e.maxGuest,
            providerType: e.providerType.name,
            priceRange: e.priceRange,
            type: e.type,
          )),
        );

        allFolderList.addAll(
          seeAllFolderModel.events.map((e) => FavoriteItemModel(
            id: e.id,
            name: e.name,
            isWishlisted: e.isWishlisted,
            coverImage: e.coverImage,
            address: e.address,
            subscriptionType: e.subscriptionType,
            createdAt: e.createdAt,
            averageRating: e.averageRating,
            totalReviews: e.totalReviews,
            totalLikes: e.totalLikes,
            totalComments: e.totalComments,
            isLiked: e.isLiked,
            blueVerifiedBadge: e.blueVerifiedBadge,
            entranceFee: e.entranceFee,
            type: e.type,
          )),
        );

        allFolderList.addAll(
          seeAllFolderModel.jobs.map((e) => FavoriteItemModel(
            id: e.id,
            title: e.title,
            isWishlisted: e.isWishlisted,
            coverImage: e.coverImage,
            category: e.category,
            address: e.address,
            subscriptionType: e.subscriptionType,
            createdAt: e.createdAt,
            blueVerifiedBadge: e.blueVerifiedBadge,
            type: e.type,
          )),
        );

        Get.toNamed(RoutesName.favoriteDetail);


      } else {
        log("Error : === ${response.message}");
      }
    } catch (e, s) {
      log(">>>>>>>>>> Error e : === $e");
      log(">>>>>>>>>> Error s : === $s");
    } finally {
      isLoading.value = false;
    }
  }


  Future<bool>createBookmark({folderName, type, id})async{
    isLoading.value = true;
    try {

      var body = {
        "folderName": folderName,
        "$type": id
      };

      var response = await userRepository.postBookmark(body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        Get.snackbar("Success".tr, response.message);
        log("Response controller : === ");
        log("Success : === ${response.message}");
        return true;
      } else {
        log("Error : === ${response.message}");
        // Get.snackbar("Error".tr,response.message);
      }
    } catch (e, s) {
      log(">>>>>>>>>> Error e : === $e");
      log(">>>>>>>>>> Error s : === $s");
    } finally {
      isLoading.value = false;
    }
    return false;
  }



}
