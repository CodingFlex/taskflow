import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:toastification/toastification.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:heroine/heroine.dart' show HeroineController;
import 'package:sizer/sizer.dart';
import 'package:taskflow/app/app.bottomsheets.dart';
import 'package:taskflow/app/app.dialogs.dart';
import 'package:taskflow/app/app.locator.dart';
import 'package:taskflow/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:taskflow/ui/common/app_colors.dart';
import 'package:taskflow/services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  await setupLocator();
  await locator<StorageService>().init();
  setupDialogUi();
  setupBottomSheetUi();
  runApp(MainApp(savedThemeMode: savedThemeMode));
}

class MainApp extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;
  const MainApp({super.key, this.savedThemeMode});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: lightTheme,
      dark: darkTheme,
      initial: savedThemeMode ?? AdaptiveThemeMode.system,
      builder: (theme, darkTheme) {
        final brightness = theme.brightness;

        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: brightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark,
            statusBarBrightness: brightness,
          ),
        );

        return Sizer(
          builder: (context, orientation, deviceType) {
            return ToastificationWrapper(
              child: AnimatedTheme(
                data: theme,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOutCubic,
                child: MaterialApp(
                  initialRoute: Routes.splashView,
                  onGenerateRoute: StackedRouter().onGenerateRoute,
                  navigatorKey: StackedService.navigatorKey,
                  navigatorObservers: [
                    StackedService.routeObserver,
                    HeroineController(),
                  ],
                  theme: theme,
                  darkTheme: darkTheme,
                  themeAnimationDuration: const Duration(milliseconds: 400),
                  themeAnimationCurve: Curves.easeInOutCubic,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
