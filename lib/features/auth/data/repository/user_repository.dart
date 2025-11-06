import 'dart:developer';

import '../../../../services/api_service.dart';
import '../../presentation/utils/app_url.dart';

class UserRepository {

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get Inspiration Category  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> getInspirationCategory() async {
    final url = AppUrl.inspirationCategory;
    log("Provider URL: $url");
    final response = await ApiService.to.getApi(url);
    log(">>>> Response : $response");
    return response;
  }
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get Inspiration Category Group >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> getInspirationCategoryGroup() async {
    final url = AppUrl.inspirationCategoryGroup;
    log("Provider URL: $url");
    final response = await ApiService.to.getApi(url);
    log(">>>> Response : $response");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get all specific Inspiration Category >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> getAllSpecificCategory(String id) async {
    final url = AppUrl.specificCategory+id;
    log("Provider URL: $url");
    final response = await ApiService.to.getApi(url);
    log(">>>> Response : $response");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get all specific Inspiration Category >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> getCategoryDetail(String id) async {
    final url = AppUrl.categoryDetails+id;
    log("Provider URL: $url");
    final response = await ApiService.to.getApi(url);
    log(">>>> Response : $response");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get community my post >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> getMyPost() async {
    final url = AppUrl.myPost;
    log("Provider URL: $url");
    final response = await ApiService.to.getApi(url);
    log(">>>> Response : $response");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get comments >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> getComments({id}) async {
    final url = AppUrl.comments(id: id );
    log("Provider URL: $url");
    final response = await ApiService.to.getApi(url);
    log(">>>> Response : $response");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get comments Personalized>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> getCommentsPersonalized({id}) async {
    final url = AppUrl.commentsPersonalized(id: id );
    log("Provider URL: $url");
    final response = await ApiService.to.getApi(url);
    log(">>>> Response : $response");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> post comments Personalized >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> postCommentPersonalized(var body) async {
    final url = AppUrl.giveCommentPersonalized;
    log("URL: $url");
    final response = await ApiService.to.postApi(url, body);
    log(">>>> Response : $response");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get community latest post >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> getLatestPost() async {
    final url = AppUrl.latestPost;
    log("Provider URL: $url");
    final response = await ApiService.to.getApi(url);
    log(">>>> Response : $response");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get community latest post >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> getMostCommentPost() async {
    final url = AppUrl.mostCommentPost;
    log("Provider URL: $url");
    final response = await ApiService.to.getApi(url);
    log(">>>> Response : $response");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get community Most Viewed post >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> getMostViewedPost() async {
    final url = AppUrl.mostViewedPost;
    log("Provider URL: $url");
    final response = await ApiService.to.getApi(url);
    log(">>>> Response : $response");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get community latest poll >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> getLatestPoll() async {
    final url = AppUrl.latestPoll;
    log("Provider URL: $url");
    final response = await ApiService.to.getApi(url);
    log(">>>> Response : $response");
    return response;
  }


  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get My poll >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> getMyPoll() async {
    final url = AppUrl.myPoll;
    log("Provider URL: $url");
    final response = await ApiService.to.getApi(url);
    log(">>>> Response : $response");
    return response;
  }


  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Give vote >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> patchVote(var body) async {
    final url = AppUrl.vote;
    log("URL: $url");
    final response = await ApiService.to.patchApi(url, body);
    log(">>>> Response : $response");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get community group >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> getCommunityGroup(String name) async {
    final url = "${AppUrl.specificPost}category=$name";
    log("Provider URL: $url");
    final response = await ApiService.to.getApi(url);
    log(">>>> Response : $response");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get community region >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> getCommunityRegion(String name) async {
    final url = "${AppUrl.specificPost}region=$name";
    log("Provider URL: $url");
    final response = await ApiService.to.getApi(url);
    log(">>>> Response : $response");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get community post details >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> getPostDetail(String id) async {
    final url = "${AppUrl.communityDetail}$id";
    log("Provider URL: $url");
    final response = await ApiService.to.getApi(url);
    log(">>>> Response : $response");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get community post details report>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> postCommunityReport(var body) async {
    final url = AppUrl.report;
    log("Provider URL: $url");
    final response = await ApiService.to.postApi(url, body);
    log(">>>> Response : $response");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get job category>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> getJobCategory() async {
    final url = AppUrl.jobCategory;
    log("Provider URL: $url");
    final response = await ApiService.to.getApi(url);
    log(">>>> Response : $response");
    return response;
  }


  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get  sub job >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> getSubJob(String id) async {
    final url = "${AppUrl.jobSubCategory}?categoryId=$id";
    log("Provider URL: $url");
    final response = await ApiService.to.getApi(url);
    log(">>>> Response : $response");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get  Un sub job >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> getUnSubJob(String id) async {
    final url = "${AppUrl.jobUnSubCategory}?categoryId=$id";
    log("Provider URL: $url");
    final response = await ApiService.to.getApi(url);
    log(">>>> Response : $response");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get job details >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> getJobDetail(String id) async {
    final url = "${AppUrl.jobDetail}$id";
    log("Provider URL: $url");
    final response = await ApiService.to.getApi(url);
    log(">>>> Response : $response");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get Notification >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> getNotification() async {
    final url = AppUrl.notification;
    log("Provider URL: $url");
    final response = await ApiService.to.getApi(url);
    log(">>>> Response : $response");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> post ticket>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> postTicket(var body) async {
    final url = AppUrl.ticket;
    log("Provider URL: $url");
    final response = await ApiService.to.postApi(url, body);
    log(">>>> Response : $response");
    return response;
  }
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> post ticket>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> applyJob(String id,var body, var multipartBody) async {
    final url = AppUrl.applyJob+id;
    log("Provider URL: $url");
    final response = await ApiService.to.multipartData(url, body, multipartBody: multipartBody);
    log(">>>> Response : $response");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> chat List>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> getChatList() async {
    final url = AppUrl.chatList;
    log("Provider URL: $url");
    final response = await ApiService.to.getApi(url);
    log(">>>> Response : $response");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> post like>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> postLike(var body) async {
    final url = AppUrl.likePost;
    log("Provider URL: $url");
    final response = await ApiService.to.postApi(url, body);
    log(">>>> Response : $response");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> post unlike>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> postUnLike(var body) async {
    final url = AppUrl.unLikePost;
    log("Provider URL: $url");
    final response = await ApiService.to.postApi(url, body);
    log(">>>> Response : $response");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> comment like>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> commentPost(var body,{bool isReply=false}) async {
    final url =(isReply)? AppUrl.commentPostReply:AppUrl.commentPost;
    log("Provider URL: $url");
    final response = await ApiService.to.postApi(url, body);
    log(">>>> Response : $response");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> comment post>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> newCommentPost(Map<String, String> body, {
    var multipartBody,
    var header,
  }) async {
    final url = AppUrl.newCommunityPost;
    log("Support Service URL: $url");
    final response = await ApiService.to.multipartData(url, body, multipartBody: multipartBody,
      extraHeaders: header,
      showMessage: true,
    );
    log(">>>> Response : $response");
    return response;
  }


    Future<ApiResponse> editCommentPost(Map<String, String> body,String id, {
    var multipartBody,
    var header,
  }) async {
    final url = AppUrl.editCommunityPost(id);
    log("Support Service URL: $url");
    final response = await ApiService.to.multipartData(url, body, multipartBody: multipartBody,
      extraHeaders: header,method: "PATCH",
      showMessage: true,
    );
    log(">>>> Response : $response");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> comment poll>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> newCommentPoll(var body) async {
    final url = AppUrl.newCommunityPoll;
    log("Support Service URL: $url");
    final response = await ApiService.to.postApi(url, body);
    log(">>>> Response : $response");
    return response;
  }
    Future<ApiResponse> editCommentPoll(var body,String id) async {
    final url = AppUrl.editCommunityPolls(id);
    log("Support Service URL: $url");
    final response = await ApiService.to.patchApi(url, body);
    log(">>>> Response : $response");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get map data >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> getMapData() async {
    final url = AppUrl.mapData;
    log("Provider URL: $url");
    final response = await ApiService.to.getApi(url);
    log(">>>> Response : $response");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get Checklist >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> getCheckList() async {
    final url = AppUrl.checkList;
    log("Provider URL: $url");
    final response = await ApiService.to.getApi(url);
    log(">>>> Response : $response");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Update Checklist >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> updateCheckList(var body) async {
    final url = AppUrl.updateCheckListIteamsStatus;
    log("Provider URL: $url");
    final response = await ApiService.to.patchApi(url, body);
    log(">>>> Response : $response");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Update Checklist >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> getAllFolder() async {
    final url = AppUrl.wishlist;
    log("Provider URL: $url");
    final response = await ApiService.to.getApi(url);
    log(">>>> Response : $response");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Update Checklist >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> getWishListFolder(String folderName) async {
    final url = AppUrl.wishlistFolder+folderName;
    log("Provider URL: $url");
    final response = await ApiService.to.getApi(url);
    log(">>>> Response : $response");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> get Referral >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> getReferral() async {
    final url = AppUrl.referral;
    log("Provider URL: $url");
    final response = await ApiService.to.getApi(url);
    log(">>>> Response : $response");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Update permission >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> postPermission(var body) async {
    final url = AppUrl.updatePermission;
    log("Provider URL: $url");
    final response = await ApiService.to.postApi(url, body);
    log(">>>> Response : $response");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> post like>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> postPersonalizedLike(var body) async {
    final url = AppUrl.giveLikePersonalized;
    log("Provider URL: $url");
    final response = await ApiService.to.postApi(url, body);
    log(">>>> Response : $response");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> post like>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> postPersonalizedUnLike(var body) async {
    final url = AppUrl.giveUnLikePersonalized;
    log("Provider URL: $url");
    final response = await ApiService.to.postApi(url, body);
    log(">>>> Response : $response");
    return response;
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> post like>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<ApiResponse> postBookmark(var body) async {
    final url = AppUrl.addBookmark;
    log("Provider URL: $url");
    final response = await ApiService.to.postApi(url, body);
    log(">>>> Response : $response");
    return response;
  }




}
