import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/contstants.dart';
import 'bottomnav.dart';

class SplashScreens extends StatefulWidget {
  const SplashScreens({super.key});

  @override
  _SplashScreensState createState() => _SplashScreensState();
}

class _SplashScreensState extends State<SplashScreens>{

  @override
  void initState(){
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Constants.PrideAPPCOLOUR,
    ));
    // Navigate after 4 seconds
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> BottomNav()));
      // _navigateToNextScreen();
    });

  }

  @override
  void dispose(){
    super.dispose();
  }

  // Future<void> _navigateToNextScreen() async {
  //   final storage = new FlutterSecureStorage();
  //   final temp = await storage.read(key: "me");
  //   log("${temp}");
  //
  //   if (temp != null) {
  //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>HomePage()));
  //   } else {
  //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>Landingpage()));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.PrideAPPCOLOUR,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              'assets/images/logo.png', // Replace with your SVG file path
              height: 280, // Adjust height as needed
              width: 280, // Adjust width as needed
            ),
          ),
          SizedBox(height: 40,),// Linear Progress Bar at the bottom
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10), // Adjust the radius for rounded corners
              child: LinearProgressIndicator(
                backgroundColor: Colors.tealAccent.withOpacity(0.2), // Background color of the progress bar
                valueColor: AlwaysStoppedAnimation<Color>(Colors.teal.shade200), // Progress color
                minHeight: 8, // Height of the progress bar
              ),
            ),
          ),
        ],
      ),
    );
  }
}