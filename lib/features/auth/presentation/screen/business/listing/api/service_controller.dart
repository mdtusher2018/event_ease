import 'dart:developer';
import 'package:event_ease/features/auth/presentation/screen/business/listing/api/service_model.dart';
import 'package:event_ease/features/auth/presentation/utils/app_url.dart';
import 'package:event_ease/services/api_service.dart';
import 'package:get/get.dart';

class SupportedServicesController extends GetxController {
  /// Supported services (primary list)
  var services = <SupportedService>[].obs;
  var selectedIds = <String>[].obs;
  final List<String> eventTypes = [];

  /// Additional services
  var additionalServices = <SupportedService>[].obs;
  var selectedAdditionalIds = <String>[].obs;
  final List<String> additionalEventTypes = [];

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchServices();
    fetchAdditionalServices();
  }


  /// Fetch supported services from API
  Future<void> fetchServices() async {
    isLoading.value = true;
    try {
      final ApiResponse response = await ApiService.to.getApi(
        AppUrl.supportedService,
      );

      if (response.success && response.data != null) {
        List<dynamic> dataList = response.data['data'] ?? [];
        services.value = dataList
            .map((e) => SupportedService.fromJson(e))
            .toList()
            .cast<SupportedService>();

        log("Fetched ${services.length} supported services");
      } else {
        Get.snackbar("Error".tr,response.message);
      }
    } catch (e, s) {
      log("Error fetching services: $e\n$s");
      Get.snackbar("Error".tr,"Failed to load services");
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch additional services from API
  Future<void> fetchAdditionalServices() async {
    try {
      final ApiResponse response = await ApiService.to.getApi(
        AppUrl.extraServices
      );

      if (response.success && response.data != null) {
        List<dynamic> dataList = response.data['data'] ?? [];
        additionalServices.value = dataList
            .map((e) => SupportedService.fromJson(e))
            .toList()
            .cast<SupportedService>();

        log("Fetched ${additionalServices.length} additional services");
      } else {
        Get.snackbar("Error".tr,response.message);
      }
    } catch (e, s) {
      log("Error fetching additional services: $e\n$s");
      Get.snackbar("Error".tr,"Failed to load additional services");
    }
  }

  /// Toggle selection for supported services
  void toggleSelection(String id) {
    final service = services.firstWhereOrNull((s) => s.id == id);

    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
      if (service != null) eventTypes.remove(service.name);
    } else {
      selectedIds.add(id);
      if (service != null && !eventTypes.contains(service.name)) {
        eventTypes.add(service.name);
      }
    }

    log("Selected Supported IDs: $selectedIds");
    log("Event Types: $eventTypes");
  }
  

  /// Toggle selection for additional services
  void toggleAdditionalSelection(String id) {
    final service = additionalServices.firstWhereOrNull((s) => s.id == id);

    if (selectedAdditionalIds.contains(id)) {
      selectedAdditionalIds.remove(id);
      if (service != null) additionalEventTypes.remove(service.name);
    } else {
      selectedAdditionalIds.add(id);
      if (service != null &&
          !additionalEventTypes.contains(service.name)) {
        additionalEventTypes.add(service.name);
      }
    }

    log("Selected Additional IDs: $selectedAdditionalIds");
    log("Additional Event Types: $additionalEventTypes");
  }

  /// Clear all selections
  void clearSelection() {
    selectedIds.clear();
    eventTypes.clear();
    selectedAdditionalIds.clear();
    additionalEventTypes.clear();
  }

  /// Check if a service is selected
  bool isSelected(String id) => selectedIds.contains(id);

  /// Check if an additional service is selected
  bool isAdditionalSelected(String id) =>
      selectedAdditionalIds.contains(id);
}
