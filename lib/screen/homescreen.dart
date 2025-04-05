import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:prideconnect/screen/profilePage.dart';

import '../components/Custom_navDrawer.dart';
import '../components/animatedbutton.dart';
import '../utils/contstants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;
  Timer? _timer;
  int _selectedIndex = 0;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  final List<Map<String, String>> successStories = [
    {
      "name": "Sarah Mitchell",
      "quote": "Finding my authentic self led me to my dream career in tech leadership.",
      "image": "assets/images/ll.png"
    },
    {
      "name": "Alex Rivera",
      "quote": "Thanks to this community, I gained the confidence to launch my own startup.",
      "image": "assets/images/ll.png"
    },
    {
      "name": "Jamie Lee",
      "quote": "The mentorship program helped me secure my dream job.",
      "image": "assets/images/ll.png"
    }
  ];

  void _startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 4), (timer) {
      if (_currentPage < successStories.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0E1624),
      appBar: AppBar(
        title: Text("Spectrum" , style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold),),
        backgroundColor: Constants.PrideAPPCOLOUR, // Set background color to transparent
        elevation: 0, // Remove the shadow
        leading: Builder(
          builder: (context) => IconButton(
            icon: SvgPicture.asset(
              "assets/svgIcons/hamburger.svg",
              color: Constants.WHITE,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        // leading:
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Image.asset('assets/images/loading.png', fit: BoxFit.contain ,),
        // ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: InkWell(
              onTap: (){Navigator.push(context, MaterialPageRoute(builder: (_)=>ProfilePage()));},
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/images/loading.png', fit: BoxFit.contain ,),
              ),
            ),
          ),
        ],
      ),
      drawer: const CustomNavDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),

              // Greeting Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text("Hi,", style: TextStyle(fontSize: 20, color: Colors.white)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text("Sarah", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
              ),

              // Lottie Animation
              SizedBox(height: 10),
              Center(
                child: Lottie.asset('assets/animation/nodatafound.json', height: 350),
              ),

              SizedBox(height: 28),
              _buildEmpowermentBox(),
              Center(child: Icon(
                Icons.keyboard_arrow_down,
                size: 50,
                color: Colors.white,
              ),),

              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "Success Stories",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              SizedBox(height: 15),

              // Auto-Scrolling PageView
              SizedBox(
                height: 250,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: successStories.length,
                  itemBuilder: (context, index) {
                    return _buildSuccessStoryCard(successStories[index]);
                  },
                ),
              ),

              SizedBox(height: 30),

              // Our Mission Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "Our Mission",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              SizedBox(height: 15),

              _buildMissionGrid(),

              SizedBox(height: 30),

              // Our Partners Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "Our Partners",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              SizedBox(height: 15),
              _buildPartners(),

              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "Recent Jobs",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              SizedBox(height: 15),
              buildJobOpenings(),

              SizedBox(height: 30),

              // Our Partners Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "Get Involved",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              SizedBox(height: 15),
              _buildGetInvolved(),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Empowering LGBTQ+ Dreams Box
  Widget _buildEmpowermentBox() {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Empowering LGBTQ+ Dreams", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),textAlign: TextAlign.center,),
            SizedBox(height: 5),
            Text("Your identity, your career, your pride", style: TextStyle(fontSize: 18, color: Colors.white)),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.white),
                ),
              ),
              onPressed: () {},
              child: Text("Explore", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildSuccessStoryCard(Map<String, String> story) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Color(0xFF1E2A3A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              story["image"]!,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  story["name"]!,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 5),
                Text(
                  '"${story["quote"]!}"',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Our Mission Section
  Widget _buildMissionGrid() {
    final List<Map<String, IconData>> missions = [
      {"Career Growth": Icons.work},
      {"Community": Icons.groups},
      {"Safe Space": Icons.security},
      {"Support": Icons.favorite},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: missions.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio:1.5, crossAxisSpacing: 10, mainAxisSpacing: 10),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.white)),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(missions[index].values.first, color: Colors.white,size: 45,),
                SizedBox(height: 10),
                Text(missions[index].keys.first, style: TextStyle(color: Colors.white,fontSize: 18)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildJobOpenings() {
    // Sample job opening data with image URLs
    final List<Map<String, dynamic>> jobOpenings = [
      {
        'imageUrl': 'https://tse1.mm.bing.net/th?id=OIP.C19WrK-kUeJMhOzi6EjHtQHaHa&pid=Api&P=0&h=180',
        'companyName': 'Google',
        'subtitle': 'Female , Ews , LGBTQ'
      },
      {
        'imageUrl': 'https://logospng.org/download/uber/logo-uber-preta-4096.png',
        'companyName': 'Uber She++',
        'subtitle': 'Reservation for lgbtq+'
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: jobOpenings.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white, width: 1.5),
          ),
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Company Image from URL
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: Image.network(
                        jobOpenings[index]['imageUrl'],
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                                  : null,
                              color: Colors.white,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.broken_image, size: 80, color: Colors.white);
                        },
                      ),
                    ),
                    SizedBox(width: 15),
                    // Company Name and Subtitle
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            jobOpenings[index]['companyName'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            jobOpenings[index]['subtitle'],
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                // Apply Now Button
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      // Add your apply logic here
                      print('Applied to ${jobOpenings[index]['companyName']}');
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.white, width: 1.5),
                      ),
                    ),
                    child: Text(
                      'Apply Now',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Our Partners Section
  Widget _buildPartners() {
    final List<Map<String, String>> missions = [
      {'assets/images/p1.png': 'assets/images/c.png'},
      {'assets/images/p2.png': 'assets/images/c.png'},
      {'assets/images/p3.png': 'assets/images/c.png'},
      {'assets/images/p4.png': 'assets/images/c.png'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: missions.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio:1.5, crossAxisSpacing: 10, mainAxisSpacing: 10),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.white)),
          child: Center(
            child: Column(
              children: [
                Container(
                  height: 110,
                  width: 110,
                  child: Image.asset(missions[index].keys.first),
                ),
                SizedBox(height: 10),
                // Text(missions[index].keys.first, style: TextStyle(color: Colors.white,fontSize: 18)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGetInvolved() {
    final List<Map<String, IconData>> involvementOptions = [
      {"Join Our Network": Icons.connect_without_contact},
      {"Mentorship Program": Icons.school},
      {"Resource Hub": Icons.lightbulb},
    ];

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.transparent, // Adjust background color as needed
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Column(
        children: involvementOptions.map((option) {
          return ListTile(
            leading: Icon(option.values.first, color: Colors.white , size: 40,),
            title: Text(option.keys.first, style: TextStyle(color: Colors.white , fontSize: 18)),
            subtitle: Text("Learn and connect", style: TextStyle(color: Colors.grey)),
          );
        }).toList(),
      ),
    );
  }
}