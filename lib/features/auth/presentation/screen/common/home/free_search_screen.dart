import 'dart:developer';
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/app_icons.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/utils/app_url.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'package:event_ease/features/auth/presentation/widgets/regular/home_screen/build_header.dart';
import 'package:event_ease/features/auth/presentation/widgets/regular/home_screen/controller/wizard_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import '../../../widgets/custom_search_field.dart';

class FreeSearchScreen extends StatefulWidget {
  @override
  _FreeSearchScreenState createState() => _FreeSearchScreenState();
}

class _FreeSearchScreenState extends State<FreeSearchScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();
  final WizardController wizardController = Get.find<WizardController>();

  late TabController _tabController;
  TextEditingController addressSearchController = TextEditingController();
  double? selectedLat;
  double? selectedLng;

   final LocationController locationController = Get.put(LocationController());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // 👈 2 tabs
    log("businessData ====== ${wizardController.buissness}");
  }

  @override
  void dispose() {
    searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Stack(
          children: [
            Column(
              children: [
                buildHeader(),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: CustomSearchField(
                    hintText: AppString.search,
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: Icon(Icons.close),
                    controller: searchController,
                    readOnly: false,
                    onChanged: (p0) {
                      setState(() {});
                    },
                    onPressedSuffix: () {
                      searchController.clear();
                      setState(() {});
                    },
                  ),
                ),
                SizedBox(height: 16),
            
                /// 📌 TabBar
                /// Professional-looking TabBar
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    padding: EdgeInsets.all(0),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black87,
                    dividerColor: Colors.transparent,
                    labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                    tabs: const [Tab(text: "Business"), Tab(text: "Event")],
                  ),
                ),
            
                SizedBox(height: 4),
            
                /// 📌 TabBarView
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [_buildBusinessList(), _buildEventList()],
                  ),
                ),
              ],
            ),
        
          if (wizardController.isFilter.value || wizardController.isEventFilter.value)
              Container(
           
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
        
          ],
        );
      }
    );
  }

  /// Business List
  Widget _buildBusinessList() {
    return Obx(() {
      final query = searchController.text.toLowerCase();
      final filtered =
          wizardController.buissness.where((result) {
            final name = result["name"]?.toLowerCase() ?? '';
            return name.contains(query);
          }).toList();

      return _buildResultList(filtered, isBusiness: true);
    });
  }

  /// Event List
  Widget _buildEventList() {
    return Obx(() {
      final query = searchController.text.toLowerCase();
      final filtered =
          wizardController.event.where((result) {
            final name = result["name"]?.toLowerCase() ?? 'N/A';
            return name.contains(query);
          }).toList();

      return _buildResultList(filtered, isBusiness: false);
    });
  }

  /// Reusable List Builder
  Widget _buildResultList(List<dynamic> results, {required bool isBusiness}) {
    if (results.isEmpty) {
      return const Center(child: Text("No results found"));
    }
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final data = results[index];
        return ListTile(
          leading: Icon(isBusiness ? Icons.business : Icons.event),
          title: Text(
            data["name"] ?? '',
            style: styleForNormalText.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
            ),
          ),
          onTap: () {
            if (isBusiness) {
              wizardController.getFreeSearchData(
                searchValue: data["name"] ?? "",
                isBusiness: isBusiness,
                customAddress: address.value,
                customCity: city.value,
                customTown: town.value,
                customFulladdress:addressSearchController.text.isNotEmpty
                                        ? addressSearchController.text
                                        : address.value.isNotEmpty
                                        ? address.value
                                        : locationController.userAddress.value,
                customLocation: addressSearchController.text.isNotEmpty,
                customLatitude: selectedLat.toString(),
                customLongitude: selectedLng.toString(),
              );
            } else {
              wizardController.getFreeEventSearchData(
                searchValue: data["name"] ?? "",
                   customAddress: address.value,
                customCity: city.value,
                customTown: town.value,
                customFulladdress:  addressSearchController.text.isNotEmpty
                                        ? addressSearchController.text
                                        : address.value.isNotEmpty
                                        ? address.value
                                        : locationController.userAddress.value,
                customLocation: addressSearchController.text.isNotEmpty,
                customLatitude: selectedLat.toString(),
                customLongitude: selectedLng.toString(),
              );
            }
          },
        );
      },
    );
  }

  RxString address = "".obs;
  RxString city = "".obs;
  RxString town = "".obs;


  Widget buildHeader() {
   

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
       
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   "${AppString.hello} ${PrefsHelper.myName}",
                //   style: styleForBoldText.copyWith(
                //     color: AppColors.darkGrey,
                //     fontSize: 18.sp,
                //   ),
                // ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Obx(() {
                        return Theme(
                          data: ThemeData(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            tilePadding: EdgeInsets.zero,
                            childrenPadding: EdgeInsets.zero,
                            minTileHeight: 0,
                            title: Row(
                              children: [
                                SvgPicture.asset(
                                  AppIcons.location2,
                                  height: 16.h,
                                  width: 16.w,
                                ),
                                SizedBox(width: 5.w),
                                Flexible(
                                  child: Text(
                                    addressSearchController.text.isNotEmpty
                                        ? addressSearchController.text
                                        : address.value.isNotEmpty
                                        ? address.value
                                        : locationController.userAddress.value,
                                    style: styleForNormalText.copyWith(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            children: [
                            
                              GooglePlaceAutoCompleteTextField(
                                boxDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                textEditingController: addressSearchController,
                                googleAPIKey: AppUrl.googleMapPlaceKey,
                                
                                focusNode: FocusNode(),
                                inputDecoration: InputDecoration(
                                  hintText: AppString.searchLocation,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.primary,
                                    ),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  hintStyle: styleForNormalText,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.primary,
                                    ),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                ),
                                debounceTime: 800,
                                isLatLngRequired: true,
                                getPlaceDetailWithLatLng: (prediction) async {
                                  selectedLat = double.tryParse(
                                    prediction.lat ?? "0.0",
                                  );
                                  selectedLng = double.tryParse(
                                    prediction.lng ?? "0.0",
                                  );

                                  log(
                                    "$selectedLat ................selected lat",
                                  );
                                  log(
                                    "$selectedLng ................selected lng",
                                  );

                                  if (selectedLat != null &&
                                      selectedLng != null) {
                                    List<Placemark>
                                    placemarks = await placemarkFromCoordinates(
                                      selectedLat!,
                                      selectedLng!, // ✅ FIXED: use lng not lat twice
                                    );

                                    if (placemarks.isNotEmpty) {
                                      Placemark place = placemarks.first;
                                      address.value =
                                          "${place.street}, ${place.subLocality}";
                                      city.value = place.locality ?? "";
                                      town.value = place.subLocality ?? "";
                                    }
                                  }
                                },
                                itemClick: (prediction) {
                                  addressSearchController.text =
                                      prediction.description ?? "";
                                  address.value =
                                      prediction.description ??
                                      ""; // ✅ Update Rx value

                                  addressSearchController
                                      .selection = TextSelection.fromPosition(
                                    TextPosition(
                                      offset:
                                          prediction.description?.length ?? 0,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
