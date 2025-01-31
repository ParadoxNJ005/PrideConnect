import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../model/chatuser.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static User get user=> auth.currentUser!;                          //google user
  static FirebaseFirestore firestore = FirebaseFirestore.instance;                    //no usage
  static final user_uid = auth.currentUser!.uid;
  static ChatUser? me;
  static bool HaveImage = false;

//-----------------------------Fetch the user data-------------------------------------------------//
  static Future<void> myInfo() async{
    final storage = new FlutterSecureStorage();
    await firestore.collection('users').doc(user_uid).get().then((user) async {
      if (user.exists) {

        // me = ChatUser.fromJson(user.data()!);
        // var res = (ChatUser.fromJson(user.data()!)).toJson();
        // await storage.write(key: "me", value: jsonEncode(res));
      } else {
      }
    });
  }

  static Future<void> fetchCartData() async {
    try {
      // Reference to the 'cart' collection
      CollectionReference cartCollection = FirebaseFirestore.instance.collection('cart');

      // Fetch all documents in the collection
      QuerySnapshot querySnapshot = await cartCollection.get();

      // Iterate through each document and print the data
      for (var doc in querySnapshot.docs) {
        print('Document ID: ${doc.id}');
        print('Data: ${doc.data()}');
      }
    } catch (e) {
      // Handle errors
      print('Error fetching cart data: $e');
    }
  }

  /// Load the current user from local storage
  static Future<void> loadCurrentUser() async {
    final storage = new FlutterSecureStorage();
    try {
      final String? userData = await storage.read(key: 'currentUser');
      if (userData != null) {
        APIs.me = ChatUser.fromJson(jsonDecode(userData));
        print('User loaded from local storage.');
      } else {
        print('No user data found in local storage.');
      }
    } catch (e) {
      print('Error loading user from local storage: $e');
    }
  }

  /// Update user data in Firestore and local storage
  static Future<void> updateUserData(Map<String, dynamic> updatedData) async {
    if (APIs.me == null || APIs.me!.uid.isEmpty) {
      throw Exception("User ID is missing. Cannot update data.");
    }
    final storage = new FlutterSecureStorage();
    try {
      // Reference to the user document in Firestore
      DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(APIs.me!.uid);

      // Update the document with new data
      await userRef.update(updatedData);

      // Merge updated data with the existing user data
      final updatedUser = APIs.me!.copyWith(updatedData);

      // Update local storage with new user data
      await storage.write(key: 'currentUser', value: jsonEncode(updatedUser.toJson()));

      // Update the global user instance
      APIs.me = updatedUser;

      print("User data updated successfully in Firestore and local storage!");
    } catch (e) {
      print("Failed to update user data: $e");
      throw e; // Re-throw for UI handling
    }
  }

  static Future<void> fetchAndStoreCurrentUser() async {
    final FlutterSecureStorage storage = FlutterSecureStorage();
    try {
      // Get the current authenticated user
      final User? currentUser = auth.currentUser;

      if (currentUser == null) {
        print('No user is currently signed in.');
        return;
      }

      // Fetch the user document from Firestore
      final DocumentSnapshot userDoc = await firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists) {
        // Convert Firestore data to ChatUser object
        me = ChatUser.fromJson(userDoc.data() as Map<String, dynamic>);

        // Store the user data in local storage as JSON
        await storage.write(key: 'currentUser', value: jsonEncode(me!.toJson()));

        print('Current user fetched and stored successfully.');
      } else {
        print('User document does not exist in Firestore.');
      }
    } catch (e) {
      print('Error fetching or storing current user: $e');
    }
  }

//-----------------------------check user exists-----------------------------------//
  static Future<bool> userExists() async {
    final user = auth.currentUser;
    if (user != null) {
      final doc = await firestore.collection('users').doc(user.uid).get();
      return doc.exists;
    }
    return false;
  }

//-----------------------------create user through google-----------------------------------//
  static Future<void> createGoogleUser() async {
    try {
      // Ensure required fields are provided with default values
      final chatUser = ChatUser(
        uid: user.uid,
        name: user.displayName ?? "", // Handle null displayName
        email: user.email ?? "", // Handle null email
        image: user.photoURL ?? "", // Handle null photoURL
        orientation: "", // Default value
        address: "", // Default value
        gender: "", // Default value
        coins: "100", // Default value
        ngos: [], // Default empty list
        phone: user.phoneNumber??"", // Default value
        interest: [], // Default empty list
        workshops: [], // Default empty list
        campaign: [], // Default empty list
        orders: [], // Default empty list
        age: "", // Default value
      );

      await firestore
          .collection('users')
          .doc(user.uid)
          .set(chatUser.toJson());
    } catch (e) {
      // Handle any errors that occur during the process
      print('Error creating Google user: $e');
      rethrow; // Optionally rethrow the error if needed
    }
  }


//-----------------------------Google Sign IN-----------------------------------//
  static Future<UserCredential?> googleSignIn()async{
    try{
      await InternetAddress.lookup('google.com');

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return await auth.signInWithCredential(credential);
    } catch (e) {
      return null;
    }
  }


// //----------------------------Sign Out User From the Application-----------------------------------//
  static Future<void> Signout() async{
    final storage = new FlutterSecureStorage();
    await auth.signOut();
    await storage.delete(key: "currentUser");
    me = null;
    HaveImage = false;
  }

}
