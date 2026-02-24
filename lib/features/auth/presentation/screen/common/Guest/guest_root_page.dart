import 'package:event_ease/features/auth/presentation/screen/common/Guest/guest_home_page.dart';
import 'package:event_ease/features/auth/presentation/screen/common/inspiration/inspiration_screen.dart';
import 'package:event_ease/features/auth/presentation/screen/regular/community/community_screen.dart';
import 'package:event_ease/features/auth/presentation/widgets/explore_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:event_ease/features/auth/presentation/utils/app_icons.dart';
import 'package:event_ease/features/auth/presentation/utils/app_colors.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';

class GuestRootPage extends StatefulWidget {
  const GuestRootPage({super.key});

  @override
  _GuestRootPageState createState() => _GuestRootPageState();
}

class _GuestRootPageState extends State<GuestRootPage> {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);

    // Add a listener to the controller to rebuild UI on tab change
    _controller.addListener(() {
      setState(() {}); // Rebuild the UI when the tab changes
    });
  }

  // Empty screens (you can replace these with real ones later)
  List<Widget> _buildScreens() {
    return [
      GuestHomeScreen(),
      _exploreScreen(
        title: "favorite_title", // Replace with localization key for Favorite
        subtitle:
            "favorite_subtitle", // Replace with localization key for Favorite subtitle
        buttonText:
            "favorite_button", // Replace with localization key for Favorite button
        icon: Icons.favorite,
      ),

      InspirationScreen(iAmNotGuest: false),
      CommunityScreen(iAmNotGuest: false),

      _exploreScreen(
        title: "chat_title", // Replace with localization key for Chat
        subtitle:
            "chat_subtitle", // Replace with localization key for Chat subtitle
        buttonText:
            "chat_button", // Replace with localization key for Chat button
        icon: Icons.chat,
      ),
    ];
  }

  Widget _exploreScreen({
    required String title,
    required String subtitle,
    required String buttonText,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: () => showExploreDialog(context), // Show dialog on tap
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 16.0,
        ), // Add padding for spacing
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Add an icon to make it more visually appealing
              Icon(
                icon,
                size: 50,
                color: AppColors.primary, // You can use your theme color here
              ),
              SizedBox(height: 20),
              // Add a more refined text
              Text(
                title.tr,
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary, // Your primary color for text
                ),
              ),
              SizedBox(height: 12),
              // A subtitle with a smaller font size for a professional feel
              Text(
                subtitle.tr,
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors
                      .black54, // Slightly faded text for secondary content
                ),
              ),
              SizedBox(height: 30),
              // A button-like clickable area for a more refined experience
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.primary, // Button color
                  borderRadius: BorderRadius.circular(30), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  buttonText.tr,
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white, // Text color on button
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Navigation bar items
  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
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
      _buildNavBarItem(
        icon: Icon(
          Icons.favorite,
          color: _controller.index == 1
              ? AppColors.primary
              : AppColors.greTab, // Active/inactive for favorite
        ),
        title: AppString.favorite,
      ),
      _buildNavBarItem(
        icon: SvgPicture.asset(
          AppIcons.inspirationIcon,
          height: 24,
          width: 24,
          color: _controller.index == 2
              ? AppColors.primary
              : AppColors.greTab, // Active color for inspiration
        ),
        title: AppString.inspiration,
      ),
      _buildNavBarItem(
        icon: SvgPicture.asset(
          AppIcons.communityIcon,
          height: 24,
          width: 24,
          color: _controller.index == 3
              ? AppColors.primary
              : AppColors.greTab, // Active color for community
        ),
        title: AppString.community,
      ),
      _buildNavBarItem(
        icon: SvgPicture.asset(
          AppIcons.chatIcon,
          height: 30,
          width: 30,
          color: _controller.index == 4
              ? AppColors.primary
              : AppColors.greTab, // Active color for chat
        ),
        title: AppString.chat,
      ),
    ];
  }

  PersistentBottomNavBarItem _buildNavBarItem({
    required Widget icon,
    Widget? inactiveIcon,
    required String title,
  }) {
    return PersistentBottomNavBarItem(
      icon: icon,
      inactiveIcon: inactiveIcon,
      title: title,
      activeColorPrimary: AppColors.primary,
      inactiveColorPrimary: AppColors.greTab,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        navBarStyle: NavBarStyle.style3,
        navBarHeight: 63.0,
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Colors.white,
        ),
        resizeToAvoidBottomInset: true,
      ),
    );
  }
}
