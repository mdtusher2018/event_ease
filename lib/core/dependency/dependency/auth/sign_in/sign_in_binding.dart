import 'package:get/get.dart';
import '../../../../../features/auth/presentation/controller/auth/sign_in_controller.dart';

class SignInBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignInController(), fenix: true);
  }
}
