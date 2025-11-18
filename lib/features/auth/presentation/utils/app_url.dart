class AppUrl {
  //===========================================for payment
  // static const publishableKey =
  //     "pk_test_51QAlfRKN37lQc7z95yHg6nrpGlpm6UD2Q2yqNK1tK60UTQwMcXhQ6zoqhTPasHpXPssn7KJLAKVxYbcGZcQffJur00sctRxg6V";
  // static const secretKey = "sk_test_51QAlfRKN37lQc7z9FivKUYOQdE2DDrNR70sj4yBMS29mWVJ38LDli2T67xCoVkxX3u1A466MIWe7y9IyKwpFnmsq00PUj7b2tj";
  // static String payPalClientId =
  //     "AaCH5bLv0gDhHMrW3gbqchECbFFJjLnkhRmfeQlGuFdp441uPkiXEnuW5MS5QHndFS2JEMWhsogkcSRm";
  // static String payPalSecretKey = "EOu1iAOF9P0uDwkyKfWUfzUB4WjfUAi38GEi1U2QjdjP8MfQRNAZ5JoQGDwvDJunDxTFZPL15DVKpSxF";
  //
  //
  // static const baseUrl = "http://159.223.184.53:8010/api/v1/"; //http://159.223.184.53:8010/
  //
  // static const myBaseUrl = "http://159.223.184.53:8010/api/v1";
  // static const photoUrl = "http://159.223.184.53:8010";
  // static const socketUrl = "http://159.223.184.53:8020";

  // static const googleMapPlaceKey = "AIzaSyB9FjAvbKE947adYrm-LnnDA4gmcQiaYFo";

  static const googleMapPlaceKey =
      "AIzaSyAicZRwkffHVARNs1m6LKk_5lsA2LYAb6U"; //Luca - Event-ease
  // static const baseUrl = "http://172.252.13.74:7010/api/v1";
  // static const baseImageUrl = "http://172.252.13.74:7010";
  //
  // static const socketUrl = "http://172.252.13.74:7020";

  static const baseUrl = "https://api.pianofesta.it/api/v1";
  static const baseImageUrl = "https://api.pianofesta.it";
  static const socketUrl = "https://socket.pianofesta.it";

  // static const baseUrl = "http://109.176.197.7:7010/api/v1";
  // static const baseImageUrl = "http://109.176.197.7:7010";
  // static const socketUrl = "http://109.176.197.7:7020";

  // static const baseUrl = "http://10.10.10.32:7010/api/v1";
  // static const baseImageUrl = "http://10.10.10.32:7010";
  // static const socketUrl = "http://10.10.10.32:7020";

  static const createUser = "$baseUrl/users/create";
  static const login = "$baseUrl/auth/login";
  static const forgetPassword = "$baseUrl/auth/forgot-password-otpByEmail";
  static const forgetPasswordOtp = "$baseUrl/auth/forgot-password-otp-match";
  static const otp = "$baseUrl/users/create-user-verify-otp";
  static const newPassword = "$baseUrl/auth/forgot-password-reset";
  static const businessCreate = "$baseUrl/business/create";
  static const inspirationCreate = "$baseUrl/inspiration/create";
  static inspirationUpdate(String id) => "$baseUrl/inspiration//update/$id";
  static const inspirationMyPost = "$baseUrl/inspiration/my";
  static const providerType = "$baseUrl/category/Provider?limit=10000";
  static const supportedService =
      "$baseUrl/category/sopportedServices?limit=10000";
  static const findProvider = "$baseUrl/requestCategory/create";
  static const extraServices = "$baseUrl/category/extraServices?limit=10000";
  static const editProfile = "$baseUrl/users/update-my-profile";
  static const changePassword = "$baseUrl/auth/change-password";
  static const myProfile = "$baseUrl/users/my-profile";
  static const privacy = "$baseUrl/settings/privacy";
  static String notificationCount(String type, String id) =>
      "$baseUrl/notification/$type/today-count/$id";
  static const userPrivacySignUp = "$baseUrl/settings/accept-privacy-policy";
  static const businessPrivacySignUp =
      "$baseUrl/settings/business/accept-privacy-policy";
  static const termCondition = "$baseUrl/settings/business/termAndConditions";

  static const usertermCondition = "$baseUrl/settings/termAndConditions";

  static const faq = "$baseUrl/faq";
  static const inspirationCategory =
      "$baseUrl/category/inspiration?limit=10000";
  static const inspirationCategoryGroup =
      "$baseUrl/inspiration/group-by/subcategory";
  static const specificCategory = "$baseUrl/inspiration/category/";
  static const categoryDetails = "$baseUrl/inspiration/";
  static const myPost = "$baseUrl/postCommunity/myPost";
  static comments({id}) => "$baseUrl/community/engaagement/comments/$id";
  static commentsPersonalized({id}) =>
      "$baseUrl/business/engaagement/comments/$id";
  static const giveCommentPersonalized =
      "$baseUrl/business/engaagement/comment";
  static const giveLikePersonalized = "$baseUrl/business/engaagement/like";
  static const giveUnLikePersonalized = "$baseUrl/business/engaagement/unlike";
  static const latestPost = "$baseUrl/postCommunity/latest";
  static const mostCommentPost = "$baseUrl/postCommunity/mostComment";
  static const mostViewedPost = "$baseUrl/postCommunity/mostViewed";
  static const latestPoll = "$baseUrl/pollCommunity/latest";
  static const myPoll = "$baseUrl/pollCommunity/myPolls";
  static const vote = "$baseUrl/pollCommunity/vote";
  static const specificPost = "$baseUrl/postCommunity/specific?";
  static const communityDetail = "$baseUrl/postCommunity/";
  static const report = "$baseUrl/report";
  static const jobCategory = "$baseUrl/category/job?limit=10000";
  static const jobSubCategory = "$baseUrl/job/sub";
  static const jobUnSubCategory = "$baseUrl/job/all";
  static const jobDetail = "$baseUrl/job/";
  static const notification = "$baseUrl/notification/my-notifications";
  static const ticket = "$baseUrl/ticket";
  static const applyJob = "$baseUrl/jobApply/";
  static const chatList = "$baseUrl/chat/my-chat-list";
  static const addBookmark = "$baseUrl/wishlist/add";
  static const removeBookmark = "$baseUrl/wishlist/remove-item";
  static const chatMsg = "$baseUrl/message/";
  static const createChat = "$baseUrl/chat/create";
  static const likePost = "$baseUrl/community/engaagement/like";
  static const unLikePost = "$baseUrl/community/engaagement/unlike";
  static const commentPost = "$baseUrl/community/engaagement/comment";
  static const commentPostReply = "$baseUrl/community/engaagement/reply";
  static const newCommunityPost = "$baseUrl/postCommunity/add";

  //==========>>>>>>>>>>Edit<<<<<<<<=============
  static String editCommunityPost(String id) => "$baseUrl/postCommunity/$id";
  static String deleteCommunityPost(String id) => "$baseUrl/postCommunity/$id";

  static String deleteMyPost(String id) => "$baseUrl/inspiration/$id";

  static String deleteFolder = "$baseUrl/wishlist/soft-delete-folder";
  static String updateFolderName = "$baseUrl/wishlist/update-folder-name";

  static const newCommunityPoll = "$baseUrl/pollCommunity/add";
  static const googleLogin = "$baseUrl/auth/google-login";
  static const mapData = "$baseUrl/business/map";
  static const createBlog = "$baseUrl/inspiration/create";
  static const checkList = "$baseUrl/checkList";
  static const createCheckList = "$baseUrl/checkList/create";
  static String updateCheckList(id) => "$baseUrl/checkList/update/$id";
  static String deleteCheckList(String id) => "$baseUrl/checkList/$id";
  static const updateCheckListIteamsStatus =
      "$baseUrl/checkList/update-item-status";
  static const createCheckListItem = "$baseUrl/checkList/add-item";
  static const wishlist = "$baseUrl/wishlist";
  static const wishlistFolder = "$baseUrl/wishlist/";
  static const referral = "$baseUrl/users/myReferrals";
  static const businessProfile = "$baseUrl/business//myParent";
  static const updateBusinessProfile = "$baseUrl/business/update/";
  static const updatePermission = "$baseUrl/users/complete";
  static const resendOtp = "$baseUrl/otp/resend-otp";

  //>>>>>>>>>>>>>>> business <<<<<<<<<<<<<<<<<<<<<<<<<<<
  static const getAllBusiness = "$baseUrl/business/location";
  static const getAllGuestBusiness = "$baseUrl/business/guest/location";
  // static const getAllBusiness = "$baseUrl/business/";
  // static const getAllSubscriptionEvent = "$baseUrl/event/sub/location";
  static const getAllSubscriptionEvent = "$baseUrl/event/all/location";
  static const getAllGuestSubscriptionEvent =
      "$baseUrl/event/all/guest/location";
  static const getAllEvent = "$baseUrl/business/exclusive/location";
  static const getGuestAllEvent = "$baseUrl/business/exclusive/guest/location";
  static const getAllInspirationCategory =
      "$baseUrl/category/inspiration?limit=10000";
  static String getBusinessDetailsById(String id) => "$baseUrl/business/$id";
  static String getExtraBusinessDetailsById(String id) =>
      "$baseUrl/business/extra/$id";
  static const String giveBusinessLikeById =
      "$baseUrl/business/engaagement/like";
  static String geEventDetailsById(String id) => "$baseUrl/event/$id";
  static const String categoryProvider =
      "$baseUrl/category/business?limit=10000";
  static const String categoryEvent = "$baseUrl/category/Event?limit=10000";
  static const String categoryJob = "$baseUrl/category/job?limit=10000";
  static const String chatFileUpload = "$baseUrl/message/file-upload";

  //listing
  static const getMyBusiness = "$baseUrl/business/my";
  static const getMyEvents = "$baseUrl/event/my";
  static const getMyJobs = "$baseUrl/job/my";

  static const createEvent = "$baseUrl/event/create";
  static const createBusiness = "$baseUrl/business/create";
  static const createJob = "$baseUrl/job/create";

  static const getMyBusinessList = "$baseUrl/business/myList";
  static const getMyEventList = "$baseUrl/event/myList";
  static const getMyJobList = "$baseUrl/job/myList";

  static String getInterestedUsers(String id) => "$baseUrl/event-interest/$id";
  static editEvent(String id) => "$baseUrl/event/update/$id";
  static editBusiness(String id) => "$baseUrl/business/update/$id";
  static editJob(String id) => "$baseUrl/job/update/$id";

  static String getdeshboardBusinessStats(String businessId) =>
      "$baseUrl/business/stats/$businessId";
  static String getdeshboardEventStats(String id) => "$baseUrl/event/stats/$id";
  static String getdeshboardJobStats(String id) => "$baseUrl/job/stats/$id";

  static String getJobApplicants(String id) =>
      "$baseUrl/jobApply/applicants/$id";
  static String likeBusiness = "$baseUrl/business/engaagement/like";
  static String unlikeBusiness = "$baseUrl/business/engaagement/unlike";

  static String likeEvent = "$baseUrl/event/engaagement/like";
  static String unlikeEvent = "$baseUrl/event/engaagement/unlike";

  static String geteventComments(String eventId) {
    return "$baseUrl/event/engaagement/comments/$eventId";
  }

  static getBusinessComments(String id) {
    return "$baseUrl/business/engaagement/comments/$id";
  }

  static String postBusinessComment = '$baseUrl/business/engaagement/comment';
  static String postEventComment = '$baseUrl/event/engaagement/comment';
  static String postjobComment = '$baseUrl/job/engaagement/comment';

  static String postBusinessCommentReply =
      '$baseUrl/business/engaagement/comment/reply';
  static String postEventCommentReply =
      '$baseUrl/event/engaagement/comment/reply';

  static String postReview(String type) => '$baseUrl/${type}Review/add';

  static String businessFollow = '$baseUrl/business/engaagement/follow';
  static String businessUnfollow = '$baseUrl/business/engaagement/unfollow';

  //====================================================================dev_topu
  static String buissnessFilter = "$baseUrl/business/filter";
  static String getBuissnessListname = "$baseUrl/business/myList";
  static String eventCatagory = "$baseUrl/category/Provider?limit=10000";

  static String getwizard = "$baseUrl/business/wizard-search";

  static String getBusinessSubscriptionPlans =
      "$baseUrl/subscription/type/business";
  static String getEventSubscriptionPlans = "$baseUrl/subscription/type/event";
  static String getJobSubscriptionPlans = "$baseUrl/subscription/type/job";
  static String freeSearch({
    required String searchValue,
    String? address,
    String? city,
    String? town,
    String? longitude,
    String? latitude,
  }) {
    final queryParams = [
      "searchTerm=$searchValue",
      if (address != null && address.isNotEmpty) "address=$address",
      if (city != null && city.isNotEmpty) "city=$city",
      if (town != null && town.isNotEmpty) "town=$town",
      if (longitude != null && longitude.isNotEmpty) "longitude=$longitude",
      if (latitude != null && latitude.isNotEmpty) "latitude=$latitude",
      "limit=10000000",
    ].join("&");

    return "$baseUrl/business/search/location?$queryParams";
  }

  static String freeEventSearch({
    required String searchValue,
    String? address,
    String? city,
    String? town,
    String? longitude,
    String? latitude,
  }) {
    final queryParams = [
      "searchTerm=$searchValue",
      if (address != null && address.isNotEmpty) "address=$address",
      if (city != null && city.isNotEmpty) "city=$city",
      if (town != null && town.isNotEmpty) "town=$town",
      if (longitude != null && longitude.isNotEmpty) "longitude=$longitude",
      if (latitude != null && latitude.isNotEmpty) "latitude=$latitude",
      "limit=10000000",
    ].join("&");

    return "$baseUrl/event/search/location?$queryParams";
  }

  static String paymentUrl = "$baseUrl/subscriptionPayment/initiate";
  static String paymentWithCriditUrl =
      '$baseUrl/subscriptionPayment/buy/credit';

  static String getMySubscriptions = "$baseUrl/mySubscription";
  static String getMySubscriptionsHistory = "$baseUrl/mySubscription/history";
  static String businessCompetitionScore(String id) =>
      "$baseUrl/business/competation/$id";
  static String eventCompetitionScore(String id) =>
      "$baseUrl/event/competation/$id";
  static String jobCompetitionScore(String id) =>
      "$baseUrl/job/competation/$id";
  static String getCreateInterest(id) => "$baseUrl/event-interest/add/$id";

  static String getSendNotification(String type, String id) =>
      "$baseUrl/notification/$type/mySented/$id";

  static const getUserArchive = "$baseUrl/ticket/my-tickets";

  static String myTotalCredits = "$baseUrl/users/myTotalCredits";

  static activeSubscription(String id) =>
      "$baseUrl/mySubscription/activate/$id";

  static stopSubscription(String id) => "$baseUrl/mySubscription/stop/$id";
  static String getUnreadNotification = "$baseUrl/notification/unread";

  static String getUnreadMassage = "$baseUrl/message/unread-count";

  static const sendFCMToken = "$baseUrl/users/update-fcmToken";
  static const createFolder = "$baseUrl/wishlist/create";

  static const myBusiness = "$baseUrl/business/my/nameList";
  static String categoryBusinessNameList =
      "$baseUrl/business/categoryBusinessNameList";
  static String categoryEventNameList = "$baseUrl/event/categoryEventNameList";

  static String fetchAllBusinessName = "$baseUrl/business/allNameList";

  static String useCredit = "$baseUrl/useCredits/use";

  static String categoryJobNameList = "$baseUrl/job/categoryJobNameList";

  static String leatestUrl = "$baseUrl/inspiration";
  static String freeJobSearch(String trems) =>
      "$baseUrl/job?searchTerm=$trems&limit=10000";

  static editCommunityPolls(String id) => "$baseUrl/pollCommunity/update/$id";
  static deletePolls(String id) => "$baseUrl/pollCommunity/$id";

  static String shareBusiness(String id) =>
      "https://api.pianofesta.it/share/business/$id";
  static String shareEvent(String id) =>
      "https://api.pianofesta.it/share/event/$id";
  static String shareJob(String id) =>
      "https://api.pianofesta.it/share/job/$id";

  static const String pendingRequestsOfUser =
      "$baseUrl/useCredits/pending-requests-of-user";

  static const String pendingRequestsOfBusiness =
      "$baseUrl/useCredits/pending-requests-of-business";

  static var approvePendingRequest = "$baseUrl/useCredits/accept";

  static var rejectPendingRequest = "$baseUrl/useCredits/reject";
}
