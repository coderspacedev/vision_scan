import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:visionscan/vision.dart';

import 'cubit/app_cubit.dart';
import 'cubit/app_state.dart';
import 'I10n/app_localizations.dart';
import 'navigation/app_router.dart';
import 'navigation/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  final appCubit = VisionCubit(GetStorage());
  await GetStorage.init();
  AppTheme.setLightColors(
    CoderColor(
      primary: Color(0xFFFFFFFF),
      background: Color(0xFFF2F2F7),
      card: Color(0xFFE6E6E6),
      cardText: Color(0xFF101010),
      text: Color(0xFF101010),
      accent: Color(0xFF510CFF),
      accentText: Color(0xFFFFFFFF),
    ),
  );
  AppTheme.setDarkColors(
    CoderColor(
      primary: Color(0xFF161616),
      background: Color(0xFF161616),
      card: Color(0xFF272727),
      cardText: Color(0xFFFFFFFF),
      text: Color(0xFFFFFFFF),
      accent: Color(0xFF510CFF),
      accentText: Color(0xFFFFFFFF),
    ),
  );
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );
  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (context) => appCubit)],
      child: Launcher(),
    ),
  );
}

final appRouterDelegate = AppRouterDelegate(routes: appRoutes);
final appRouteParser = AppRouteInformationParser(appRoutes);

class Launcher extends StatefulWidget {
  const Launcher({super.key});

  @override
  State<Launcher> createState() => _LauncherState();
}

class _LauncherState extends State<Launcher> {
  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.platformBrightnessOf(context);
    AppTheme.autoSwitch(brightness);

    return BlocBuilder<VisionCubit, VisionState>(
      builder: (context, state) {
        return MaterialApp.router(
          title: 'Vision Ai',
          debugShowCheckedModeBanner: false,
          locale: state.locale,
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
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: AppTheme.colors.background,
            canvasColor: AppTheme.colors.background,
            cardColor: AppTheme.colors.card,
            primaryColor: AppTheme.colors.primary,
            useMaterial3: false,
            appBarTheme: AppBarTheme(
              backgroundColor: AppTheme.colors.background,
              foregroundColor: AppTheme.colors.text,
              centerTitle: false,
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: AppTheme.colors.background,
            canvasColor: AppTheme.colors.background,
            cardColor: AppTheme.colors.card,
            primaryColor: AppTheme.colors.primary,
            useMaterial3: false,
            appBarTheme: AppBarTheme(
              backgroundColor: AppTheme.colors.background,
              foregroundColor: AppTheme.colors.text,
              centerTitle: false,
            ),
          ),
          themeMode: ThemeMode.system,
          routerDelegate: appRouterDelegate,
          routeInformationParser: appRouteParser,
        );
      },
    );
  }
}
