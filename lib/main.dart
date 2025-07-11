import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:visionscan/vision.dart';
import 'extensions/app_theme.dart';
import 'languages/I10n/app_localizations.dart';
import 'presentation/screens/screen_splash.dart';
import 'provider/app_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(AppController());
  await GetStorage.init();
  runApp(const Launcher());
}

class Launcher extends StatefulWidget {

  const Launcher({super.key});

  @override
  State<Launcher> createState() => _LauncherState();
}

class _LauncherState extends State<Launcher> {
  final AppController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(context.screenWidth, context.screenHeight),
      minTextAdapt: true,
      splitScreenMode: true,
      child: Obx(
            () =>
            GetMaterialApp(
              navigatorKey: Get.key,
              title: 'Translator',
              debugShowCheckedModeBanner: false,
              locale: controller.locale.value,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: [
                Locale('en'),
                Locale('de'),
                Locale('fr'),
                Locale('ar'),
                Locale('ja'),
                Locale('es'),
                Locale('id'),
                Locale('af'),
                Locale('pt'),
              ],
              theme: AppTheme.lightTheme,
              themeMode: controller.selectedTheme.value == "light"
                  ? ThemeMode.light
                  : controller.selectedTheme.value == "dark"
                  ? ThemeMode.dark
                  : ThemeMode.dark,
              home: ScreenSplash(),
            ),
      ),
    );
  }
}
