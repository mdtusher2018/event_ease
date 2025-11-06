
import 'package:event_ease/core/dependency/dependency/dependency_injection.dart';
import 'package:event_ease/core/routers/routes_name.dart';
import 'package:event_ease/core/theme/theme.dart';
import 'package:event_ease/features/auth/presentation/utils/app_string.dart';
import 'package:event_ease/firebase_options.dart';
import 'package:event_ease/permission_handeler.dart';
import 'package:event_ease/services/socket_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'core/helper/prefs_helper.dart';
import 'core/routers/routes.dart';
import 'features/auth/presentation/controller/theme/theme_controller.dart';
import 'features/auth/presentation/utils/app_translations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await requestAppPermissions();

  await getFirbaseConnected();

  await action();

  runApp(const MyApp());
}

Future<void> action() async {
  await PrefsHelper.getAllPrefData();
  // PrefsHelper.removeAllPrefData();

  if (PrefsHelper.token.isNotEmpty) {
    SocketServices.connectToSocket();
  }

  DependencyInjection dI = DependencyInjection();
  dI.dependencies();
}

Future<void> getFirbaseConnected() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());
    return Obx(() {
      return ScreenUtilInit(
        designSize: const Size(440, 960),
        minTextAdapt: true,
        splitScreenMode: true,
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppString.appTitleText,
          theme: AppTheme.lightThemeMode,
          darkTheme: AppTheme.darkThemeMode,
          themeMode: themeController.themeMode.value,
          // navigatorKey: Get.key,
          translations: AppTranslations(),
          defaultTransition: Transition.noTransition,
          locale: Locale(
            PrefsHelper.localizationLanguageCode,
            PrefsHelper.localizationCountryCode,
          ),
          
          fallbackLocale: const Locale('it', 'IT'),
          initialRoute: RoutesName.getSplashScreen0(),
          getPages: AppRoutes.appRoutes(),
          // home: OnboardingScreen(),
        ),
      );
    });
  }
}
