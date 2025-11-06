import 'package:get/get.dart';
import '../../../../../features/auth/presentation/controller/auth/sign_up_controller.dart';

class SignUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignUpController(), fenix: true);
  }
}
