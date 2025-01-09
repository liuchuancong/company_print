import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:company_print/common/index.dart';

Future<void> initSystem() async {
  WidgetsFlutterBinding.ensureInitialized();
  PrefUtil.prefs = await SharedPreferences.getInstance();
  initService();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarContrastEnforced: false,
  ));
}

void initService() {
  Get.put(SettingsService());
}

void main() async {
  await initSystem();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final settings = Get.find<SettingsService>();
      var themeColor = HexColor(settings.themeColorSwitch.value);
      ThemeData lightTheme = MyTheme(primaryColor: themeColor).lightThemeData;
      ThemeData darkTheme = MyTheme(primaryColor: themeColor).darkThemeData;
      return GetMaterialApp(
        title: '纯粹直播',
        themeMode: SettingsService.themeModes[settings.themeModeName.value]!,
        theme: lightTheme.copyWith(appBarTheme: const AppBarTheme(surfaceTintColor: Colors.transparent)),
        darkTheme: darkTheme.copyWith(appBarTheme: const AppBarTheme(surfaceTintColor: Colors.transparent)),
        navigatorObservers: [FlutterSmartDialog.observer],
        builder: FlutterSmartDialog.init(),
        initialRoute: RoutePath.kInitial,
        defaultTransition: Transition.native,
        getPages: AppPages.routes,
      );
    });
  }
}
