import 'package:event_ease/features/auth/presentation/controller/auth/otp_controller.dart';
import 'package:event_ease/features/auth/presentation/widgets/regular/home_screen/controller/wizard_controller.dart';
import 'package:get/get.dart';

import '../../../features/auth/presentation/controller/chat/chat_controller.dart';
import '../../../features/auth/presentation/controller/chat/chatting_controller.dart';
import '../../../features/auth/presentation/controller/comment_post_controller.dart';
import '../../../features/auth/presentation/controller/community_controller.dart';
import '../../../features/auth/presentation/controller/favorite/favorite_controller.dart';
import '../../../features/auth/presentation/controller/inspiration/block_controller.dart';
import '../../../features/auth/presentation/controller/inspiration/inspiration_controller.dart';
import '../../../features/auth/presentation/controller/job/job_controller.dart';
import '../../../features/auth/presentation/controller/map/map_controller.dart';
import '../../../features/auth/presentation/controller/notification/notification_controller.dart';
import '../../../features/auth/presentation/controller/notification/permission_controller.dart';
import '../../../features/auth/presentation/controller/profile/business_profile_controller.dart';
import '../../../features/auth/presentation/controller/profile/change_password_controller.dart';
import '../../../features/auth/presentation/controller/profile/help_center_controller.dart';
import '../../../features/auth/presentation/controller/profile/privacy_policy_controller.dart';
import '../../../features/auth/presentation/controller/profile/referrals_controller.dart';
import '../../../features/auth/presentation/controller/profile/term_of_condition_controller.dart';
import '../../../services/api_service.dart';

class DependencyInjection extends Bindings {
  @override
  void dependencies() {
    /// >>>>>>>>>>>>>>>>>>>>>>>> Service >>>>>>>>>>>>>>>>>>
    Get.lazyPut(() => ApiService(), fenix: true);

    Get.lazyPut(() => OtpController(), fenix: true);
    Get.lazyPut(() => ChangePasswordController(), fenix: true);
    Get.lazyPut(() => PrivacyPolicyController(), fenix: true);
    Get.lazyPut(() => TermOfConditionController(), fenix: true);
    Get.lazyPut(() => HelpCenterController(), fenix: true);
    Get.lazyPut(() => InspirationController(), fenix: true);
    Get.lazyPut(() => CommunityController(), fenix: true);
    Get.lazyPut(() => CommentPostController(), fenix: true);
    Get.lazyPut(() => JobController(), fenix: true);
    Get.lazyPut(() => NotificationController(), fenix: true);
    Get.lazyPut(() => ChatController(), fenix: true);
    Get.lazyPut(() => ChattingController(), fenix: true);
    Get.lazyPut(() => ReferralsController(), fenix: true);
    Get.lazyPut(() => MapController(), fenix: true);
    Get.lazyPut(() => BlockController(), fenix: true);
    Get.lazyPut(() => FavoriteController(), fenix: true);
    Get.lazyPut(() => BusinessProfileController(), fenix: true);
    Get.lazyPut(() => WizardController(), fenix: true);
    Get.lazyPut(() => PermissionController(), fenix: true);

    /// >>>>>>>>>>>>>>>>>>>>>>>> Controller >>>>>>>>>>>>>>>>>>
    // Get.lazyPut(() => HomeController(), fenix: true);
    // Get.lazyPut(() => SignInController(), fenix: true);
    // Get.lazyPut(() => SignUpController(), fenix: true);
  }
}
