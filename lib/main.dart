import 'package:flutter/material.dart';

import 'config/routes.dart';
import 'config/theme/global_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter CRM',
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: CrmColors.primary),
      //   useMaterial3: true,
      // ),
      debugShowCheckedModeBanner: false,
      theme: GlobalTheme.lightThemeData,
      initialRoute: '/signIn',
      onGenerateRoute:
          (settings) => RouteConfiguration.onGenerateRoute(settings),
      builder: (context, widget) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.noScaling),
          child: widget!,
        );
      },
    );
  }
}
