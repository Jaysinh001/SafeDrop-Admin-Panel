import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/data/local_storage/hive_initializer.dart';
import 'core/dependencies/injection_container.dart';
import 'core/routes/route.dart';
import 'core/theme/bloc/theme_bloc.dart';
import 'core/theme/theme.dart';
import 'core/theme/theme_extension.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize Hive
  await HiveInitializer.init();
  await initLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeBloc(),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp.router(
              routerConfig: AppPages.router,
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
              themeMode: state.themeMode,
      
              // themeMode: ThemeMode.system,
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: TextScaler.linear(1.0)),
                  child: child!,
                );
              },
            );
        },
      ),
    );
  }
}
