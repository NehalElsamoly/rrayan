import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rayan_store/DBhelper/cubit.dart';
import 'package:rayan_store/app_cubit/app_cubit.dart';
import 'package:rayan_store/screens/auth/cubit/authcubit_cubit.dart';
import 'package:rayan_store/screens/cart/cubit/cart_cubit.dart';
import 'package:rayan_store/screens/checkout/tabby_checkout.dart';
import 'package:rayan_store/screens/favourite_screen/cubit/favourite_cubit.dart';
import 'package:rayan_store/screens/orders/cubit/order_cubit.dart';
import 'package:rayan_store/screens/profile/cubit/userprofile_cubit.dart';
import 'package:rayan_store/screens/tabone_screen/cubit/home_cubit.dart';
import 'package:rayan_store/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tabby_flutter_inapp_sdk/tabby_flutter_inapp_sdk.dart';
import 'componnent/constants.dart';
import 'generated/coden_loader.dart';
import 'helpers/dio_helper.dart';
import 'notificationservice/local_notifiaction_service.dart';
import 'screens/country/cubit/country_cubit.dart';
import 'services/locator.dart';
import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  LocalNotificationService.initialize();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {} else if (settings.authorizationStatus == AuthorizationStatus.provisional) {} else {}
  FirebaseMessaging.instance.getInitialMessage().then((message) {
    if (message != null) {
      LocalNotificationService.createanddisplaynotification(message);
    }
  },
  );
  FirebaseMessaging.onMessage.listen((message) {
    LocalNotificationService.createanddisplaynotification(message);
  },
  );
  DioHelper.init();
  if (kDebugMode) {
    print(await FirebaseMessaging.instance.getToken());
  }
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  appName = packageInfo.appName;
  packageName = packageInfo.packageName;
  version = packageInfo.version;
  buildNumber = packageInfo.buildNumber;
  await startShared();
  await deleteUserAccount(appversion: version);
  setupLocator();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.dark,
  ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  HttpOverrides.global = MyHttpOverrides();
  TabbySDK().setup(
    withApiKey: 'pk_96b383b9-0536-4149-a109-c4b3ce9284f1', // Put here your Api key
    environment: Environment.production,
  );
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations', // <-- change patch to your
      assetLoader: const CodegenLoader(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String lang = '';

  getLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      lang = preferences.getString('language').toString();
    });
  }

  @override
  void initState() {
    getLang();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(

        providers: [
          BlocProvider<AppCubit>(
              create: (BuildContext context) => AppCubit()
                ..sizeSelection()
                ..colorSelection()
                ..addressSelection()),
          BlocProvider<CartCubit>(
              create: (BuildContext context) => CartCubit()),
          BlocProvider<OrderCubit>(create: (context) => OrderCubit()),
          BlocProvider<FavouriteCubit>(create: (context) => FavouriteCubit()),
          BlocProvider<CountryCubit>(
              create: (BuildContext context) => CountryCubit()..getCountry()),
          BlocProvider<DataBaseCubit>(
              create: (BuildContext context) => DataBaseCubit()..createDb()),
          BlocProvider<UserprofileCubit>(
              create: (BuildContext context) =>
                  UserprofileCubit()..getAllinfo()),
          BlocProvider<AuthcubitCubit>(
              create: (BuildContext context) => AuthcubitCubit()),
          BlocProvider<HomeCubit>(
              create: (BuildContext context) => HomeCubit()
                ..getHomeitems()
                ..getSetting()),
        ],
        child:
        ScreenUtilInit(
        designSize: const Size(360, 690),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (_, child) {
    return MaterialApp(

    debugShowCheckedModeBanner: false,
    localizationsDelegates: context.localizationDelegates,
    supportedLocales: context.supportedLocales,
    locale: context.locale,
    theme: ThemeData(
      useMaterial3: false,
      primaryColor:mainColor,

    appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.dark,
    ),
    ),
    fontFamily: (lang == 'en') ? 'Nunito' : 'Almarai',
    ),
    home: SplashScreen(),
    routes: {
    '/checkout': (context) => const CheckoutPage(),
    },
    );
    })
    );
  }
}
