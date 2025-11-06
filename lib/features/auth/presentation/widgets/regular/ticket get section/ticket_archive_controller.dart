import 'dart:developer';
import 'package:event_ease/features/auth/presentation/utils/app_url.dart';
import 'package:event_ease/features/auth/presentation/widgets/regular/ticket%20get%20section/ticket_archive_model.dart';
import 'package:event_ease/services/api_service.dart';
import 'package:get/get.dart';

class TicketController extends GetxController {
  var isLoading = false.obs;
  var ticketList = <TicketModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyTickets(); // ✅ Fetch tickets automatically when controller is initialized
  }

  Future<void> fetchMyTickets() async {
    isLoading.value = true;
    try {
      final response = await ApiService.to.getApi(AppUrl.getUserArchive);

      if (response.success && response.data != null) {
        final tickets = List<TicketModel>.from(
          response.data.map((x) => TicketModel.fromJson(x ?? {})),
        );

        ticketList.assignAll(tickets);
        log("Fetched ${ticketList.length} tickets");
      } else {
        Get.snackbar("Error".tr,response.message);
      }
    } catch (e, s) {
      log("Error in fetchMyTickets: $e\n$s");
      Get.snackbar("Error".tr,"Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }
}
