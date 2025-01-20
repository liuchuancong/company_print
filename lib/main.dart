import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:company_print/common/index.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:company_print/utils/event_bus.dart';
import 'package:chinese_font_library/chinese_font_library.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> initSystem() async {
  WidgetsFlutterBinding.ensureInitialized();
  WakelockPlus.enable();
  PrefUtil.prefs = await SharedPreferences.getInstance();
  await ScreenUtil.ensureScreenSize(); // 确保屏幕大小被正确设置
  initService();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarContrastEnforced: false,
  ));
  initRefresh();
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
  StreamSubscription<dynamic>? wakelockPlusSubscription;
  @override
  void initState() {
    super.initState();
    setInitScreen();
    listenWakelock();
  }

  listenWakelock() {
    wakelockPlusSubscription = EventBus.instance.listen('enableScreenKeepOn', (data) {
      if (data == true) {
        WakelockPlus.toggle(enable: true);
      } else {
        WakelockPlus.toggle(enable: false);
      }
    });
  }

  setInitScreen() {
    final settings = Get.find<SettingsService>();
    WakelockPlus.toggle(enable: settings.enableScreenKeepOn.value);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final settings = Get.find<SettingsService>();
      var themeColor = HexColor(settings.themeColorSwitch.value);
      ThemeData lightTheme = MyTheme(primaryColor: themeColor).lightThemeData;
      ThemeData darkTheme = MyTheme(primaryColor: themeColor).darkThemeData;
      return ScreenUtilInit(
        designSize: const Size(1280, 800),
        minTextAdapt: true,
        splitScreenMode: true,
        child: GetMaterialApp(
          title: '账单记录',
          themeMode: SettingsService.themeModes[settings.themeModeName.value]!,
          theme: lightTheme.useSystemChineseFont(Brightness.light),
          darkTheme: darkTheme.useSystemChineseFont(Brightness.dark),
          navigatorObservers: [FlutterSmartDialog.observer],
          initialRoute: RoutePath.kInitial,
          defaultTransition: Transition.native,
          getPages: AppPages.routes,
          debugShowCheckedModeBanner: false,
          supportedLocales: const [
            Locale('zh', ''),
          ],
          locale: const Locale('zh', ''),
          localizationsDelegates: const [GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
          builder: FlutterSmartDialog.init(
            loadingBuilder: (msg) => Center(
              child: SizedBox(
                width: 5.w,
                height: 5.w,
                child: CircularProgressIndicator(
                  strokeWidth: 0.2.w,
                  color: Colors.white,
                ),
              ),
            ),
            //字体大小不跟随系统变化
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1.1),
              ),
              child: child!,
            ),
          ),
        ),
      );
    });
  }
}

initRefresh() {
  EasyRefresh.defaultHeaderBuilder = () => const ClassicHeader(
        armedText: '松开加载',
        dragText: '上拉刷新',
        readyText: '加载中...',
        processingText: '正在刷新...',
        noMoreText: '没有更多数据了',
        failedText: '加载失败',
        messageText: '上次加载时间 %T',
        processedText: '加载成功',
      );
  EasyRefresh.defaultFooterBuilder = () => const ClassicFooter(
        armedText: '松开加载',
        dragText: '下拉刷新',
        readyText: '加载中...',
        processingText: '正在刷新...',
        noMoreText: '没有更多数据了',
        failedText: '加载失败',
        messageText: '上次加载时间 %T',
        processedText: '加载成功',
      );
}
