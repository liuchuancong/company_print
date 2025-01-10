import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:company_print/common/index.dart';
import 'package:chinese_font_library/chinese_font_library.dart';

Future<void> initSystem() async {
  WidgetsFlutterBinding.ensureInitialized();
  PrefUtil.prefs = await SharedPreferences.getInstance();
  await ScreenUtil.ensureScreenSize(); // 确保屏幕大小被正确设置
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
      return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        child: GetMaterialApp(
          title: '账单记录',
          themeMode: SettingsService.themeModes[settings.themeModeName.value]!,
          theme: lightTheme
              .copyWith(appBarTheme: const AppBarTheme(surfaceTintColor: Colors.transparent))
              .useSystemChineseFont(Brightness.light),
          darkTheme: darkTheme
              .copyWith(appBarTheme: const AppBarTheme(surfaceTintColor: Colors.transparent))
              .useSystemChineseFont(Brightness.dark),
          navigatorObservers: [FlutterSmartDialog.observer],
          initialRoute: RoutePath.kInitial,
          defaultTransition: Transition.native,
          getPages: AppPages.routes,
          debugShowCheckedModeBanner: false,
          builder: FlutterSmartDialog.init(
            loadingBuilder: (msg) => Center(
              child: SizedBox(
                width: 64.w,
                height: 64.w,
                child: CircularProgressIndicator(
                  strokeWidth: 8.w,
                  color: Colors.white,
                ),
              ),
            ),
            //字体大小不跟随系统变化
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1.0),
              ),
              child: child!,
            ),
          ),
        ),
      );
    });
  }
}
