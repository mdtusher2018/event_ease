import 'dart:developer';
import 'dart:io';

import 'package:event_ease/core/helper/prefs_helper.dart';
import 'package:event_ease/core/routers/routes_name.dart';
import 'package:event_ease/features/auth/presentation/screen/common/chat/chat_screen.dart';
import 'package:event_ease/features/auth/presentation/screen/regular/community/community_screen.dart';
import 'package:event_ease/features/auth/presentation/screen/regular/favorite/favorite_screen.dart';
import 'package:event_ease/features/auth/presentation/screen/business/dashboard/dashboard_screen.dart';
import 'package:event_ease/features/auth/presentation/screen/business/listing/listing_screen.dart';
import 'package:event_ease/features/auth/presentation/utils/app_icons.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/features/auth/presentation/utils/app_url.dart';
import 'package:event_ease/push_notifications.dart';
import 'package:event_ease/services/api_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/styles.dart';
import 'home/home_screen.dart';
import 'inspiration/inspiration_screen.dart';
import 'package:event_ease/services/socket_service.dart';

class NavScreen extends StatefulWidget {
  const NavScreen({super.key});

  static int selectedIndex = 0;
  static RxBool haveUnreadMassage = false.obs;

  @override
  _NavScreenState createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  late PersistentTabController _controller;
  bool _isDrawerOpen = false; // Add this to track drawer state

  @override
  void initState() {
    super.initState();
    // Get index from arguments, default to 0
    final int initialIndex =
        Get.arguments is Map && Get.arguments['index'] is int
            ? Get.arguments['index']
            : NavScreen.selectedIndex;
    _controller = PersistentTabController(initialIndex: initialIndex);

    _controller.addListener(() {
      setState(() {
        NavScreen.selectedIndex = _controller.index;

        // ✅ Clear unread dot when user goes to chat
        if (PrefsHelper.myRole == "user") {
          if (_controller.index == 4) {
            NavScreen.haveUnreadMassage.value = false;
          }
        } else if (PrefsHelper.myRole == "organizer") {
          if (_controller.index == 3) {
            NavScreen.haveUnreadMassage.value = false;
          }
        }
      });
    });

    if (PrefsHelper.token.isNotEmpty) {
      SocketServices.connectToSocket();
      connecntNotification();
      getUnreadMassage();
    }
  }

  void getUnreadMassage() async {
    try {
      var response = await ApiService.to.getApi(AppUrl.getUnreadMassage);
      if (response.success) {
        log("..............................${response.data}");

        final count = response.data["count"] ?? 0; // ✅ safe extraction
        log("$count .............................."); // ✅ string interpolation

        if (count > 0) {
          NavScreen.haveUnreadMassage.value = true;
        } else {
          NavScreen.haveUnreadMassage.value = false;
        }
      } else {
        log("Error: ${response.message}");
        Get.snackbar("Error".tr, response.message);
      }
    } catch (e, s) {
      log("Exception: $e");
      log("Stacktrace: $s");
    }
  }

  void connecntNotification() async {
    final FirebaseMessaging messaging = FirebaseMessaging.instance;
    String token = await messaging.getToken() ?? "";

    log("device token==============$token");
    if (token.isNotEmpty) {
      final response = await ApiService.to.patchApi(AppUrl.sendFCMToken, {
        "fcmToken": token,
      });
      log(response.message + ">>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<");
    }

    log(".................Firebase Initialized..............");
    // Initialize Notification Service
    final notificationService = NotificationService();
    log(".................Notification..............");
    await notificationService.initialize();
    log(".................Notification Initialized..............");
  }

  // Add method to handle drawer state changes
  void _onDrawerChanged(bool isOpen) {
    setState(() {
      _isDrawerOpen = isOpen;
    });
  }

  // List of screens for the bottom nav bar based on role
  List<Widget> _buildScreens() {
    if (PrefsHelper.myRole == "user") {
      return [
        HomeScreen(onDrawerChanged: _onDrawerChanged),
        // Pass callback to HomeScreen
        FavoriteScreen(),
        InspirationScreen(),
        CommunityScreen(),
        ChatScreen(),
      ];
    } else if (PrefsHelper.myRole == "organizer") {
      return [
        HomeScreen(onDrawerChanged: _onDrawerChanged),
        // Pass callback to HomeScreen
        DashboardScreen(),
        InspirationScreen(),
        ChatScreen(),
        ListingScreen(),
      ];
    }
    return [];
  }

  // Bottom navigation bar items based on role
  List<PersistentBottomNavBarItem> _navBarsItems() {
    List<PersistentBottomNavBarItem> items = [
      _buildNavBarItem(
        icon: SizedBox(
          height: 24,
          width: 24,
          child: SvgPicture.asset(
            AppIcons.activeHomeIcon,
            height: 24,
            width: 24,
          ),
        ),
        inactiveIcon: SizedBox(
          height: 24,
          width: 24,
          child: SvgPicture.asset(
            AppIcons.nonActiveHomeIcon,
            height: 24,
            width: 24,
          ),
        ),
        title: AppString.home,
      ),
      if (PrefsHelper.myRole == "user")
        _buildNavBarItem(
          icon: Icon(
            Icons.favorite,
            color:
                NavScreen.selectedIndex == 1
                    ? AppColors.primary
                    : AppColors.greTab,
          ),
          title: AppString.favorite,
        ),
      if (PrefsHelper.myRole == "organizer")
        _buildNavBarItem(
          icon: Icon(
            Icons.dashboard,
            color:
                NavScreen.selectedIndex == 1
                    ? AppColors.primary
                    : AppColors.greTab,
          ),
          title: "Dashboard",
        ),
      _buildNavBarItem(
        icon: Center(
          child: SvgPicture.asset(
            AppIcons.inspirationIcon,
            height: 24,
            width: 24,
            color:
                NavScreen.selectedIndex ==
                        (PrefsHelper.myRole == "user" ? 2 : 2)
                    ? AppColors.primary
                    : AppColors.greTab,
          ),
        ),
        inactiveIcon: Center(
          child: SvgPicture.asset(
            AppIcons.inspirationIcon,
            height: 24,
            width: 24,
            color: AppColors.greTab,
          ),
        ),
        title: AppString.inspiration,
      ),
      if (PrefsHelper.myRole == "user")
        _buildNavBarItem(
          icon: Center(
            child: SvgPicture.asset(
              AppIcons.communityIcon,
              height: 24,
              width: 24,
              color:
                  NavScreen.selectedIndex == 3
                      ? AppColors.primary
                      : AppColors.greTab,
            ),
          ),
          inactiveIcon: Center(
            child: SvgPicture.asset(
              AppIcons.communityIcon,
              height: 24,
              width: 24,
              color: AppColors.greTab,
            ),
          ),
          title: "Community",
        ),
      _buildNavBarItem(
        icon: Center(
          child: Obx(() {
            return Stack(
              alignment: Alignment.topRight,
              children: [
                SvgPicture.asset(
                  AppIcons.chatIcon,
                  height: 30,
                  width: 30,
                  color:
                      NavScreen.selectedIndex ==
                              (PrefsHelper.myRole == "user" ? 4 : 3)
                          ? AppColors.primary
                          : AppColors.greTab,
                ),
                Positioned(
                  child: Icon(
                    Icons.circle,
                    color:
                        (NavScreen.haveUnreadMassage.value)
                            ? Colors.red
                            : Colors.transparent,
                    size: 12,
                  ),
                ),
              ],
            );
          }),
        ),
        inactiveIcon: Center(
          child: Obx(() {
            return Stack(
              alignment: Alignment.topRight,
              children: [
                SvgPicture.asset(
                  AppIcons.chatIcon,
                  height: 30,
                  width: 30,
                  color: AppColors.greTab,
                ),
                Positioned(
                  child: Icon(
                    Icons.circle,
                    color:
                        (NavScreen.haveUnreadMassage.value)
                            ? Colors.red
                            : Colors.transparent,
                    size: 12,
                  ),
                ),
              ],
            );
          }),
        ),
        title: AppString.chat,
      ),
      if (PrefsHelper.myRole == "organizer")
        _buildNavBarItem(
          icon: Center(
            child: SvgPicture.asset(
              AppIcons.listingIcon,
              height: 24,
              width: 24,
              color:
                  NavScreen.selectedIndex == 4
                      ? AppColors.primary
                      : AppColors.greTab,
            ),
          ),
          inactiveIcon: Center(
            child: SvgPicture.asset(
              AppIcons.listingIcon,
              height: 24,
              width: 24,
              color: AppColors.greTab,
            ),
          ),
          title: "Listing",
        ),
    ];

    return items;
  }

  PersistentBottomNavBarItem _buildNavBarItem({
    required Widget icon,
    Widget? inactiveIcon,
    required String title,
    double iconSize = 24.0,
  }) {
    return PersistentBottomNavBarItem(
      icon: icon,
      inactiveIcon: inactiveIcon,
      iconSize: iconSize,
      title: title,
      activeColorPrimary: AppColors.primary,
      inactiveColorPrimary: AppColors.greTab,
      // Remove the direct textStyle property as it's causing the error
    );
  }

  // Floating action button with responsive design
  Widget _buildFloatingActionButton() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return FloatingActionButton(
          onPressed: () {
            Get.toNamed(RoutesName.map);
          },
          backgroundColor: AppColors.primary,
          mini: true,
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          child: IntrinsicWidth(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    AppString.maps,
                    style: styleForBoldText.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 5),
                SvgPicture.asset(AppIcons.mapIcon, height: 24, width: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return Scaffold(
      body: Stack(
        children: [
          // Wrap the PersistentTabView with GetX for responsive sizing
          MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(1.0)),
            child: Theme(
              // Apply Outfit font to the whole PersistentTabView using Theme
              data: Theme.of(context).copyWith(
                // Override the text style for the navigation bar items
                textTheme: Theme.of(context).textTheme.copyWith(
                  // This affects the text style in bottom navigation
                  bodyMedium: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
              ),
              child: PersistentTabView(
                context,
                controller: _controller,
                screens: _buildScreens(),
                items: _navBarsItems(),
                navBarStyle: NavBarStyle.style3,
                navBarHeight: 63.0,
                padding: EdgeInsets.only(bottom: 5),
                decoration: NavBarDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  colorBehindNavBar: Colors.white,
                ),
                resizeToAvoidBottomInset: true,
              ),
            ),
          ),
          // Positioned Floating Action Button with dynamic positioning using GetX
          // Modified condition to include drawer state check
          if (_controller.index == 0 &&
              !_isDrawerOpen) // Add this condition to hide when drawer is open
            Positioned(
              bottom: Platform.isIOS? 120.h : 80.h,
              left: 130.w,
              right: 130.w,
              child: _buildFloatingActionButton(),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
