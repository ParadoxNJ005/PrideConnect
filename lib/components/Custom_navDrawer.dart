import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prideconnect/screen/aboutpage.dart';
import 'package:prideconnect/screen/allworkshop.dart';
import 'package:prideconnect/screen/cartscreen.dart';
import 'package:prideconnect/screen/chatbot.dart';
import 'package:prideconnect/screen/courses.dart';
import 'package:prideconnect/screen/events.dart';
import 'package:prideconnect/screen/explorescreen.dart';
import 'package:prideconnect/screen/landingpage.dart';
import 'package:prideconnect/screen/ngos.dart';
import 'package:prideconnect/screen/profilePage.dart';
import 'package:prideconnect/screen/splashScreen.dart';
import 'package:share_plus/share_plus.dart';
import '../database/Apis.dart';
import '../utils/contstants.dart';
import 'ProfilePicture.dart';

class CustomNavDrawer extends StatefulWidget {
  const CustomNavDrawer({super.key});

  @override
  State<CustomNavDrawer> createState() => _CustomNavDrawerState();
}

class _CustomNavDrawerState extends State<CustomNavDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Constants.PrideAPPCOLOUR,
        child: Column(
          children: <Widget>[
            Container(
                color: Constants.PrideAPPCOLOUR,
                height: 150,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(80),
                      child: Container(
                        height: 60,
                        width: 60,
                        child: ProfilePicture(radius: 60 , name: APIs.me!.name,username: APIs.me!.name,logo: (APIs.me!.image=="")?null:APIs.me!.image,),
                        // child: CachedNetworkImage(
                        //   imageUrl: APIs.me!.imageUrl!,
                        //   imageBuilder: (context, imageProvider) => Container(
                        //     decoration: BoxDecoration(
                        //       image: DecorationImage(
                        //           image: imageProvider,
                        //           fit: BoxFit.cover,
                        //           colorFilter:
                        //           ColorFilter.mode(Colors.white, BlendMode.colorBurn)),
                        //     ),
                        //   ),
                        //   placeholder: (context, url) => CircularProgressIndicator(),
                        //   errorWidget: (context, url, error) => Icon(Icons.error),
                        // ),
                      ),
                    ),
                    title: Text(
                      APIs.me!.name!,
                      style: GoogleFonts.epilogue(
                        textStyle: TextStyle(
                          fontSize: 20,
                          color: Constants.WHITE,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      maxLines: 2, // Limit to 2 lines
                      overflow: TextOverflow.ellipsis, // Adds ellipsis (...) if text overflows
                    ),
                    subtitle: Text(
                      APIs.me!.email!,
                      style: GoogleFonts.epilogue(
                        textStyle: TextStyle(
                          color: Constants.WHITE,
                        ),
                      ),
                    ),
                  ),
                )
            ),
            _list(Icons.shopping_bag, "cart", (){Navigator.push(context, MaterialPageRoute(builder: (_)=>CartPage()));}),
            _list(Icons.chat, "Chatbot", (){Navigator.push(context, MaterialPageRoute(builder: (_)=>ChatBot()));}),
            _list(Icons.person, "Profile", (){Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage()));}),
            _list(Icons.book, "Courses", (){Navigator.push(context, MaterialPageRoute(builder: (_)=>CoursePage()));}),
            _list(Icons.event_available, "Events", (){Navigator.push(context, MaterialPageRoute(builder: (_)=>Events()));}),
            _list(Icons.more_time, "Explore", (){Navigator.push(context, MaterialPageRoute(builder: (_)=>ExplorePage()));}),
            _list(Icons.house, "Ngos", (){Navigator.push(context, MaterialPageRoute(builder: (_)=>NGOs()));}),
            _list(Icons.add_box_outlined, "About Us", (){Navigator.push(context, MaterialPageRoute(builder: (_)=>AboutPage()));}),
            _list(Icons.add_box_outlined, "Workshops", (){Navigator.push(context, MaterialPageRoute(builder: (_)=>AllWorkshopPage()));}),
            _list(Icons.share, "Share", (){Share.share("Hurry Up ⏰!! \n Download SEMBREAKER from Playstore and Boost your College Prep.");}),
            _list(Icons.logout_outlined, "Sign out", ()async{
              await APIs.Signout();

              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=> LandingPage()), (route) => false,);
            }),
            // Spacer(),
            // Text(
            //   'Made with ❤️ By Butter Chicken',
            //   // "",
            //   style: GoogleFonts.epilogue(
            //     textStyle: TextStyle(
            //       fontSize: 15,
            //       color: Constants.BLACK,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
            SizedBox(height: 50,)
          ],
        ),
      );
  }
  Widget _list(IconData icon, String name, VoidCallback onPress){
    return ListTile(
      onTap: onPress,
      leading: IconButton(icon: Icon(icon) , onPressed: onPress,color: Colors.white,),
      title: Text(name,style: GoogleFonts.epilogue(
        textStyle: TextStyle(
          fontSize: 20,
          color: Constants.WHITE,
          fontWeight: FontWeight.bold,
        ),
      )),
    );
  }
}
