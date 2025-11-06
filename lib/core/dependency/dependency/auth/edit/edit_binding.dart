import 'package:event_ease/features/auth/presentation/controller/profile/edit_controller.dart';
import 'package:get/get.dart';

class EditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EditController(), fenix: true);
  }
}
