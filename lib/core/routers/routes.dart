import 'package:event_ease/core/dependency/dependency/home_binding.dart';
import 'package:event_ease/core/routers/routes_name.dart';
import 'package:event_ease/features/auth/presentation/screen/business/auth/sign_up_step_screen.dart';
import 'package:event_ease/features/auth/presentation/screen/business/business_profile/business_profile_screen.dart';
import 'package:event_ease/features/auth/presentation/screen/business/business_profile/item_screen/general_info_screen.dart';
import 'package:event_ease/features/auth/presentation/screen/business/business_profile/item_screen/promotion_screen.dart';
import 'package:event_ease/features/auth/presentation/screen/business/business_profile/item_screen/social_network_screen.dart';
import 'package:event_ease/features/auth/presentation/screen/business/dashboard/dashboard_screen.dart';
import 'package:event_ease/features/auth/presentation/screen/business/dashboard/dashboard_search_screen.dart';
import 'package:event_ease/features/auth/presentation/screen/business/listing/listing_screen.dart';
import 'package:event_ease/features/auth/presentation/screen/common/home/event_details_screen.dart';
import 'package:event_ease/features/auth/presentation/screen/common/image_view_screen.dart';
import 'package:event_ease/features/auth/presentation/screen/common/inspiration/business/post_block_screen.dart';
import 'package:event_ease/features/auth/presentation/screen/common/inspiration/business/post_event_screen.dart';
import 'package:event_ease/features/auth/presentation/screen/common/inspiration/regular/report_screen.dart';
import 'package:event_ease/features/auth/presentation/screen/common/profile/apply_job_screen.dart';
import 'package:event_ease/features/auth/presentation/screen/regular/community/add_new_post_screen.dart';
import 'package:event_ease/features/auth/presentation/screen/common/home/business_detail_screen.dart';
import 'package:event_ease/features/auth/presentation/screen/common/chat/chat_screen.dart';
import 'package:event_ease/features/auth/presentation/screen/regular/community/comment_post.dart';
import 'package:event_ease/features/auth/presentation/screen/regular/community/new_poll_screen.dart';
import 'package:event_ease/features/auth/presentation/screen/regular/favorite/favorite_detail_screen.dart';
import 'package:event_ease/features/auth/presentation/screen/regular/favorite/favorite_screen.dart';
import 'package:event_ease/features/auth/presentation/screen/regular/give_review_screen.dart';
import 'package:event_ease/features/auth/presentation/screen/common/home/learn_more_screen.dart';
import 'package:event_ease/features/auth/presentation/screen/regular/map/map_screen.dart';
import 'package:event_ease/features/auth/presentation/screen/common/onboarding_screen.dart';
import 'package:event_ease/features/auth/presentation/screen/common/nav_screen.dart';
import 'package:event_ease/features/auth/presentation/screen/common/role_screen.dart';
import 'package:event_ease/features/auth/presentation/screen/splash_screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../../features/auth/presentation/screen/business/business_profile/item_screen/address_map_screen.dart';
import '../../features/auth/presentation/screen/business/business_profile/item_screen/business_hour_screen.dart';
import '../../features/auth/presentation/screen/business/business_profile/item_screen/contact_info_screen.dart';
import '../../features/auth/presentation/screen/business/business_profile/item_screen/faq_screen.dart';
import '../../features/auth/presentation/screen/business/business_profile/item_screen/image_media_screen.dart';
import '../../features/auth/presentation/screen/business/business_profile/item_screen/service_details_screen.dart';
import '../../features/auth/presentation/screen/business/dashboard/interested_user_screen.dart';
import '../../features/auth/presentation/screen/business/dashboard/job_application_screen.dart';
import '../../features/auth/presentation/screen/business/sponsorship/sponsorship_screen.dart';
import '../../features/auth/presentation/screen/common/auth/create_new_password_screen.dart';
import '../../features/auth/presentation/screen/common/auth/forget_password_screen.dart';
import '../../features/auth/presentation/screen/common/auth/otp_screen.dart';
import '../../features/auth/presentation/screen/common/auth/sign_in_screen.dart';
import '../../features/auth/presentation/screen/common/auth/sign_up_privacy_policy_screen.dart';
import '../../features/auth/presentation/screen/common/auth/sign_up_screen.dart';
import '../../features/auth/presentation/screen/common/home/filter_screen.dart';
import '../../features/auth/presentation/screen/common/home/guide_screen.dart';
// import '../../features/auth/presentation/screen/common/home/happen_learn_more_screen.dart';
import '../../features/auth/presentation/screen/common/home/home_screen.dart';
import '../../features/auth/presentation/screen/common/home/notification_screen.dart';
import '../../features/auth/presentation/screen/common/home/search_screen.dart';
import '../../features/auth/presentation/screen/common/chat/chatting_screen.dart';
import '../../features/auth/presentation/screen/common/inspiration/regular/event_profile_screen.dart';
import '../../features/auth/presentation/screen/common/inspiration/regular/idea_advice_screen.dart';
import '../../features/auth/presentation/screen/common/inspiration/inspiration_screen.dart';
import '../../features/auth/presentation/screen/common/inspiration/regular/post_screen.dart';
import '../../features/auth/presentation/screen/common/profile/change_password_screen.dart';
import '../../features/auth/presentation/screen/common/profile/edit_profile_screen.dart';
import '../../features/auth/presentation/screen/common/profile/help_center/help_center_screen.dart';
import '../../features/auth/presentation/screen/common/profile/help_center/live_support_screen.dart';
import '../../features/auth/presentation/screen/common/profile/job/job_detail_screen.dart';
import '../../features/auth/presentation/screen/common/profile/job/job_screen.dart';
import '../../features/auth/presentation/screen/common/profile/language_screen.dart';
import '../../features/auth/presentation/screen/common/profile/my_referrals_screen.dart';
import '../../features/auth/presentation/screen/common/profile/privacy_policy_screen.dart';
import '../../features/auth/presentation/screen/common/profile/terms_of_service_screen.dart';
import '../../features/auth/presentation/screen/regular/community/community_screen.dart';
import '../../features/auth/presentation/screen/regular/community/see_all_poll_screen.dart';
import '../../features/auth/presentation/screen/regular/community/see_all_post_screen.dart';
import '../dependency/dependency/auth/edit/edit_binding.dart';
import '../dependency/dependency/auth/forget_password/forget_password_binding.dart';
import '../dependency/dependency/auth/sign_in/sign_in_binding.dart';
import '../dependency/dependency/auth/sign_up/sign_up_binding.dart';
import '../dependency/dependency/auth/sign_up/sign_up_step_binding.dart';

class AppRoutes {
  static appRoutes() => [

  GetPage(
      name: RoutesName.getSplashScreen0(),
      page: () => SplashScreen0(),
      // binding: SignUpBinding(),
    ),
    GetPage(
      name: RoutesName.getSplashScreen(),
      page: () => SplashScreen(),
      // binding: SignUpBinding(),
    ),
    GetPage(
      name: RoutesName.getOnboardingScreen(),
      page: () => OnboardingScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getRoleScreen(),
      page: () => RoleScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getImageViewScreen(),
      page: () => ImageViewerScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    // GetPage(
    //   name: RoutesName.getLocationPermissionScreen(),
    //   page: () => LocationPermissionScreen(),
      // binding: HomeBinding(), // Corrected here
    // ),
    // GetPage(
    //   name: RoutesName.getNotificationPermissionScreen(),
    //   page: () => NotificationPermissionScreen(),
    //   // binding: HomeBinding(), // Corrected here
    // ),
    GetPage(
      name: RoutesName.getSignUpScreen(),
      page: () => SignUpScreen(),
      binding: SignUpBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getSignInScreen(),
      page: () => SignInScreen(),
      binding: SignInBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getForgetPasswordScreen(),
      page: () => ForgetPasswordScreen(),
      binding: ForgetPasswordBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getOtpScreen(),
      page: () => OtpScreen(),
      binding: SignUpBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getCreateNewPasswordScreen(),
      page: () => CreateNewPasswordScreen(),
      // binding: SignInBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getHomeScreen(),
      page: () => HomeScreen(),
      binding: HomeBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getNavScreen(),
      page: () => NavScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getEditProfileScreen(),
      page: () => EditProfileScreen(),
      binding: EditBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getHelpCenterScreen(),
      page: () => HelpCenterScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getLanguageScreen(),
      page: () => LanguageScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getChangePasswordScreen(),
      page: () => ChangePasswordScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getPrivacyScreen(),
      page: () => PrivacyPolicyScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getTermsOfServiceScreen(),
      page: () => TermsOfServiceScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getJobScreen(),
      page: () => JobScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getBusinessDetailScreen(),
      page: () => BusinessDetailScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getNotificationScreen(),
      page: () => NotificationScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getLearnMoreScreen(),
      page: () => LearnMoreScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getGiveReviewScreen(),
      page: () => GiveReviewScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getChatScreen(),
      page: () => ChatScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getChattingScreen(),
      page: () => ChattingScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getCommunityScreen(),
      page: () => CommunityScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getAddNewPostScreen(),
      page: () => AddNewPostScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getFavoriteScreen(),
      page: () => FavoriteScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getMapScreen(),
      page: () => MapScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getGuideScreen(),
      page: () => GuideScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getFilterScreen(),
      page: () => FilterScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getSearchScreen(),
      page: () => SearchScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getInspirationScreen(),
      page: () => InspirationScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getIdeaAdviceScreen(),
      page: () => IdeaAdviceScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getPostScreen(),
      page: () => PostScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    // GetPage(
    //   name: RoutesName.getEventViewScreen(),
    //   page: () => EventViewAllScreen(),
    //   // binding: HomeBinding(), // Corrected here
    // ),
    GetPage(
      name: RoutesName.getEventProfileScreen(),
      page: () => EventProfileScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getSignUpStepScreen(),
      page: () => SignUpStepScreen(),
      binding: SignUpStepBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getDashboardScreen(),
      page: () => DashboardScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getListingScreen(),
      page: () => ListingScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    // GetPage(
    //   name: RoutesName.getCreateNewOptionScreen(),
    //   page: () => CreateNewOption(),
    //   // binding: HomeBinding(), // Corrected here
    // ),
    GetPage(
      name: RoutesName.getFavoriteDetail(),
      page: () => FavoriteDetailScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getReportScreen(),
      page: () => ReportScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getCommentPost(),
      page: () => CommentPost(),
      // binding: HomeBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getApplyJobScreen(),
      page: () => ApplyJobScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getBusinessProfileScreen(),
      page: () => BusinessProfileScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getPostBlockScreen(),
      page: () => PostBlockScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getPostEventScreen(),
      page: () => PostEventScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getGeneralInfoScreen(),
      page: () => GeneralInfoScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getImageMediaScreen(),
      page: () => ImageMediaScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getContactInfoScreen(),
      page: () => ContactInfoScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getSocialNetworkScreen(),
      page: () => SocialNetworkScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getBusinessHourScreen(),
      page: () => BusinessHourScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getAddressMapScreen(),
      page: () => AddressMapScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getServiceDetailsScreen(),
      page: () => ServiceDetailsScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getFaqScreen(),
      page: () => FaqScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getPromotionScreen(),
      page: () => PromotionScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getEventDetailScreen(),
      page: () => EventDetailsScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getJobDetailScreen(),
      page: () => JobDetailScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getDashboardSearchScreen(),
      page: () => DashboardSearchScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getSponsorshipScreen(),
      page: () => SponsorshipScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    // GetPage(
    //   name: RoutesName.getBusinessProfileCardScreen(),
    //   page: () => BusinessProfileCardScreen(),
    //   // binding: HomeBinding(), // Corrected here
    // ),
    // GetPage(
    //   name: RoutesName.getEventCardScreen(),
    //   page: () => EventCardScreen(),
    //   // binding: HomeBinding(), // Corrected here
    // ),
    // GetPage(
    //   name: RoutesName.getJobCardScreen(),
    //   page: () => JobCardScreen(),
    //   // binding: HomeBinding(), // Corrected here
    // ),
    GetPage(
      name: RoutesName.getMyReferralsScreen(),
      page: () => MyReferralsScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getJobApplicationScreen(),
      page: () => JobApplicationScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    // GetPage(
    //   name: RoutesName.getSendNotificationScreen(),
    //   page: () => SendNotificationScreen(),
    //   // binding: HomeBinding(), // Corrected here
    // ),
    GetPage(
      name: RoutesName.getLiveSupportScreen(),
      page: () => LiveSupportScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getInterestedUserScreen(),
      page: () => InterestedUserScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getNewPollScreen(),
      page: () => NewPollScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getSeeAllPollScreen(),
      page: () => SeeAllPollScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    GetPage(
      name: RoutesName.getSeeAllPostScreen(),
      page: () => SeeAllPostScreen(),
      // binding: HomeBinding(), // Corrected here
    ),
    // GetPage(
    //   name: RoutesName.getEventLearnMoreScreen(),
    //   page: () => EventLearnMoreScreen(),
    //   // binding: HomeBinding(), // Corrected here
    // ),
    // GetPage(
    //   name: RoutesName.getHappenLearnMoreScreen(),
    //   page: () => HappenLearnMoreScreen(),
    //   // binding: HomeBinding(), // Corrected here
    // ),

    GetPage(
      name: RoutesName.getSignUpPrivacyPolicy(),
      page: () => SignUpPrivacyPolicyScreen(),
      // binding: HomeBinding(), // Corrected here
    ),


  ];
}
