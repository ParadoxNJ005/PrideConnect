import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:prideconnect/screen/homescreen.dart';
import 'package:prideconnect/screen/splashScreen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBLysTDQ5ZZYfGy5EB1hzr6UpMNss2U33Q",
        appId: '1:713083156511:android:61ad2890f9d3d219fb3d2a',
        messagingSenderId: "713083156511",
        projectId: "sembreaker-49515",
      ),
    );
    print('[FIREBASE] Firebase initialized successfully');

    // Introduce a delay before calling set()
    // await Future.delayed(Duration(milliseconds: 500)); // Adjust delay as needed
    //set(); // Assuming 'set()' is defined elsewhere
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  } catch (e) {
    print('Error initializing Firebase:$e');
  }

  // Request notification permission and initialize notifications if granted
  bool permissionGranted = await requestNotificationPermission();

  if (permissionGranted) {
    // If permission granted, subscribe to topic and initialize notifications
    FirebaseMessaging.instance.subscribeToTopic('all').then((_) {
      print('Subscribed to "all" topic');
    }).catchError((error) {
      print('Failed to subscribe to topic: $error');
    });

    // await FirebaseApi().initNotifications();
  } else {
    print('Notifications will not be initialized as permission is denied.');
  }
  runApp(MyApp());
}

Future<bool> requestNotificationPermission() async {
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

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
    return true; // Permission granted
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
    return true; // Provisional permission granted, still allow notifications
  } else {
    print('User declined or has not accepted permission');
    return false; // Permission denied
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // late FirebaseMessaging firebaseMessaging;

  @override
  void initState() {
    super.initState();
    // Set the status bar color to blue
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
    ));

    // firebaseMessaging = FirebaseMessaging.instance;
    // firebaseMessaging.subscribeToTopic('notifications');
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: MaterialApp(
          title: 'SemBreaker',
          debugShowCheckedModeBanner: false,
          // Define your routes here (remove the '/' entry since you have 'home')
          routes: {
            '/home': (context) => HomeScreen(), // Route for your home screen
            //'/signin': (context) => SignIn(),
            //'/about': (context) => AboutUs(),
            //'///admin': (context) => Admin(),
            //'/announcements': (context) => Announcements(),
            // '/pdf': (context) => PDFScreen(),
            // '/semisterAskingPage': (context) => SemsiterAskingPage(),
            //'/subject': (context) => Subject(), // You might need to adjust this based onhow you pass data to Subject
          },
          home: const SplashScreens()
      ),
    );
  }
}
