import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/bindings/controller_binder.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/theme/theme.dart';
import 'package:lively_nightlife_nightclub_party/routes/app_routes.dart';

class Lively extends StatelessWidget {
  const Lively({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Lively',
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoute.splashView,
          // initialRoute: AppRoute.onboardingView,
          getPages: AppRoute.routes,
          initialBinding: ControllerBinder(),
          themeMode: ThemeMode.system,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          // translations: AppLocalizations(),
          // locale: const Locale('en', 'US'),
          // fallbackLocale: const Locale('en', 'US'),
        );
      },
    );
  }
}
