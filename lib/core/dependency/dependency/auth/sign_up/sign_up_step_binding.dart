import 'package:event_ease/features/auth/presentation/controller/auth/sign_up_step_controller.dart';
import 'package:get/get.dart';

class SignUpStepBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignUpStepController(), fenix: true);
  }
}
