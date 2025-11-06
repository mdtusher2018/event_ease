import 'package:event_ease/features/auth/presentation/controller/auth/forget_password_controller.dart';
import 'package:get/get.dart';

class ForgetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ForgetPasswordController(), fenix: true);
  }
}
