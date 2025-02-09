import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:prideconnect/components/bottomnav.dart';
import '../components/helpr.dart';
import '../database/Apis.dart';
import 'homescreen.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {


  Future<void> _refreshPage() async {
    // Fetch the current user or other necessary data
    await APIs.loadCurrentUser();

    // Simulate additional data fetching
    await Future.delayed(Duration(seconds: 2));

    // Update the state to reflect changes
    setState((){
      APIs.HaveImage = (APIs.me != null);
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<UserCredential?> signInWithGoogle() async {
      try {
        debugPrint("Checking internet connectivity.");
        await InternetAddress.lookup('google.com');
        debugPrint("Internet connectivity confirmed.");

        debugPrint("Initiating Google Sign-In.");
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

        if (googleUser == null) {
          debugPrint("Google Sign-In canceled by user.");
          return null;
        }

        debugPrint("Google user signed in: ${googleUser.email}");
        final GoogleSignInAuthentication? googleAuth =
        await googleUser.authentication;

        debugPrint("Google Auth credentials retrieved. Access Token: ${googleAuth?.accessToken}, ID Token: ${googleAuth?.idToken}");

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        debugPrint("Signing in with Firebase using Google credentials.");
        return await APIs.auth.signInWithCredential(credential);
      } catch (e) {
        debugPrint("Error during _signInWithGoogle: $e");
        Dialogs.showSnackbar(context, "Something Went Wrong(Check Internet!!)");
        return null;
      }
    }

    handleGoogleBtnClick() {
      Dialogs.showProgressBar(context);
      debugPrint("Google Sign-In initiated.");

      signInWithGoogle().then((user) async {
        Navigator.pop(context);
        debugPrint("Sign-In process completed.");

        if (user != null) {
          final email = user.user?.email;
          debugPrint("User email retrieved: $email");

          if (email != null) {
            if (await APIs.userExists()) {
              debugPrint("User exists in the database. Navigating to HomeScreen.");
              await APIs.fetchAndStoreCurrentUser();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => BottomNav()),
              );
            } else {
              debugPrint("New user detected. Creating Google user entry.");
              APIs.createGoogleUser().then((value) async {
                await APIs.fetchAndStoreCurrentUser();
                debugPrint("Google user created successfully.");
                // Uncomment this if you want to navigate to CollegeDetails screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => BottomNav()),
                );
              }).catchError((e) {
                debugPrint("Error creating Google user: $e");
              });
            }
          } else {
            debugPrint("Invalid college email. Prompting user.");
            Dialogs.showSnackbar(context, "⚠️ Login Via Valid College Id!!");

            debugPrint("Signing out the user from Firebase and Google.");
            await FirebaseAuth.instance.signOut();
            await GoogleSignIn().signOut();
          }
          _refreshPage();
        } else {
          debugPrint("User is null. Sign-In failed or canceled.");
        }
      }).catchError((e) {
        debugPrint("Error during Google Sign-In process: $e");
      });
    }

    return Scaffold(
      backgroundColor: Color(0xFF1A1A2E), // Dark background color
      body: Column(
        children: [
          // Spacer to push content to the top
          Spacer(),
          // Lottie Animation in place of Image
          Lottie.asset(
            'assets/animation/pq.json', // Add your Lottie file in assets folder
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 20),
          Text(
            "Spectrum",
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Your identity, your career, your pride",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white60,
              fontSize: 17,
            ),
          ),
          // Spacer to push the button to the bottom
          Spacer(),
          // Google Login Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: ElevatedButton.icon(
              onPressed: () {
                handleGoogleBtnClick();
              },
              icon: Icon(Icons.g_mobiledata, color: Colors.white),
              label: Text("Login with Google"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white10,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}