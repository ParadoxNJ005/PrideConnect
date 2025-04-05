import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prideconnect/screen/homescreen.dart';
import 'package:prideconnect/screen/splashScreen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyD0aLaffkTRZxYEBc7qUs13DSfpkdCeGM0",
        appId: '1:1066404534395:android:adf471ea8c842347796ade',
        messagingSenderId: "1066404534395",
        projectId: "first-e6681",
      ),
    );

    // Setup Crashlytics for error tracking
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  } catch (e) {
    debugPrint("Error during Firebase initialization: $e");
  }

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Set the status bar color
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: MaterialApp(
        // theme: ThemeData(
        //   splashColor: Constants.SKYBLUE,
        //   fontFamily: 'Montserrat',
        //   primaryColor: Constants.DARK_SKYBLUE,
        //   primaryIconTheme: const IconThemeData(color: Colors.white),
        //   indicatorColor: Constants.WHITE,
        //   primaryTextTheme: const TextTheme(
        //     headlineMedium: TextStyle(color: Colors.white),
        //   ),
        //   tabBarTheme: const TabBarTheme(
        //     labelColor: Constants.WHITE,
        //     labelStyle: TextStyle(fontWeight: FontWeight.w600),
        //     unselectedLabelColor: Constants.SKYBLUE,
        //     unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
        //   ),
        //   pageTransitionsTheme: const PageTransitionsTheme(
        //     builders: {
        //       TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
        //       TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        //     },
        //   ),
        //   colorScheme: ColorScheme.fromSwatch().copyWith(
        //     secondary: Constants.SKYBLUE,
        //   ),
        // ),
        title: 'Spectrum',
        debugShowCheckedModeBanner: false,
        routes: {
          '/home': (context) => HomeScreen(),
        },
        home: SplashScreens(),
      ),
    );
  }
}
