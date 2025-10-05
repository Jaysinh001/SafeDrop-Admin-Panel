import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/routes/app_routes.dart';
import 'core/routes/route.dart';
import 'core/theme/theme.dart';
import 'core/theme/theme_extension.dart';
import 'shared/widgets/error_screens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      // Apply our custom themes
      theme: AppTheme.lightTheme.copyWith(
        extensions: [AdminThemeExtension.light],
      ),
      darkTheme: AppTheme.darkTheme.copyWith(
        extensions: [AdminThemeExtension.dark],
      ),
      // Other configurations
      debugShowCheckedModeBanner: false,
      // Theme mode (you can make this dynamic)
      themeMode: ThemeMode.light,
      // themeMode: ThemeMode.system,
      unknownRoute: GetPage(
        name: AppRoutes.notFound,
        page: () => NotFoundScreen(),
      ),
    );
  }
}
