import 'package:flutter/material.dart';
import 'package:prideconnect/screen/profilePage.dart';
import '../utils/contstants.dart';
import 'aboutpage.dart';
import 'animatedbutton.dart';
import 'cartscreen.dart';
import 'events.dart';
import 'ngos.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.PrideAPPCOLOUR, // Set background color to transparent
        elevation: 0, // Remove the shadow
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/images/loading.png', fit: BoxFit.contain ,),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu,color: Colors.white,),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height*0.9,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/a.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height*0.9,
                  color: Colors.black.withOpacity(0.5),
                ),
                Positioned(
                  bottom: 170,
                  left: 20,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Empowering the\n LGBTQ+ Community,\n One Step at a Time',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Upskilling, connecting, and transforming lives with career opportunities, counseling, and support.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 20),
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_)=>NGOs()));
                            },
                            child: Text('Explore Opportunities'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blue.withOpacity(.8), // Background color for ElevatedButton
                              minimumSize: Size(double.infinity, 50), // Max width and height
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10), // Corner radius
                              ),
                            ),
                          ),
                          SizedBox(height: 10), // Space between buttons
                          OutlinedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_)=>Events()));
                            },
                            child: Text('Join with Google' ,style: TextStyle(color: Colors.white , fontWeight: FontWeight.w500 , fontSize: 18),),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.transparent, // Background color for OutlinedButton
                              side: BorderSide(color: Colors.white),
                              minimumSize: Size(double.infinity, 50), // Max width and height
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10), // Corner radius
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                AnimatedIconButton(scrollController: _scrollController),
              ],
            ),
            // Welcome Section
            Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.grey.withOpacity(0.7),
                        Colors.grey.withOpacity(0.3),
                        Colors.grey.withOpacity(0.1),
                        Colors.white
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical:25 ,horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Welcome to Inclusive\n Learning',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // Text color for visibility on gradient
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Empowering the LGBTQ+ community through education and opportunities.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black.withOpacity(0.8), // Slightly transparent text
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text('Explore Opportunities'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.black.withOpacity(.8), // Background color for ElevatedButton
                            minimumSize: Size(double.infinity, 50), // Max width and height
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10), // Corner radius
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            SizedBox(height: 20),
            // Featured Courses
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Featured Courses',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCourseCard('Web Development', 'Learn modern web technologies', 'assets/images/g.png'),
                  _buildCourseCard('Business Skills', 'Master entrepreneurship', 'assets/images/b.png'),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Upcoming Events
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Upcoming Events',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            _buildEventCard('Career Workshop', 'June 15, 2024 · Virtual', 'assets/images/c.png'),
            SizedBox(height: 20),
            // Success Stories
            Container(
              height: 300,
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(.05), // Background color with some opacity
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
                crossAxisAlignment: CrossAxisAlignment.center, // Center content horizontally
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Success Stories',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30),
                  // Horizontal ScrollView
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // First Card
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            width: 330, // Fixed width for each card
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                              leading: CircleAvatar(
                                backgroundImage: AssetImage('assets/images/d.png'),
                              ),
                              title: Text('Alex Thompson'),
                              subtitle: Text('Software Engineer at Google'),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        // Second Card
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            width: 330, // Fixed width for each card
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                              leading: CircleAvatar(
                                backgroundImage: AssetImage('assets/images/d.png'),
                              ),
                              title: Text('Jamie Lee'),
                              subtitle: Text('Product Manager at Microsoft'),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        // Third Card
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            width: 330, // Fixed width for each card
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                              leading: CircleAvatar(
                                backgroundImage: AssetImage('assets/images/d.png'),
                              ),
                              title: Text('Samira Patel'),
                              subtitle: Text('UX Designer at Facebook'),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        // Fourth Card
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            width: 330, // Fixed width for each card
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                              leading: CircleAvatar(
                                backgroundImage: AssetImage('assets/images/d.png'),
                              ),
                              title: Text('Michael Harris'),
                              subtitle: Text('Data Scientist at Amazon'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Job Opportunities
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Job Opportunities',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            _buildJobCard('Uber She++', 'User India'),
            SizedBox(height: 20),
            // Find Support
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Find Support',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Container(
                height: 300,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16),
                color: Colors.grey.withOpacity(0.1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(borderRadius: BorderRadius.circular(10) ,child: Image.asset('assets/images/f.png',width: double.infinity, fit: BoxFit.cover)),
                    SizedBox(height: 10),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.push(context,MaterialPageRoute(builder: (_)=>CartPage()));
                      },
                      child: Text('Find Nearby NGOs' ,style: TextStyle(color: Colors.white , fontWeight: FontWeight.w500 , fontSize: 18),),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black, // Background color for OutlinedButton
                        side: BorderSide(color: Colors.black),
                        minimumSize: Size(double.infinity, 50), // Max width and height
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Corner radius
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20,)
          ],
        ),
      ),

    );
  }

  Widget _buildCourseCard(String title, String subtitle, String imagePath) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Card(
        child: Container(
          width: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(imagePath, fit: BoxFit.cover, height: 100, width: double.infinity),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Text(subtitle, style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventCard(String title, String date, String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Added vertical padding for spacing
      child: Card(
        elevation: 4, // Adds a slight shadow to the card
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners for the card
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0), // Internal padding for better spacing
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align content to the left
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0), // Rounded corners for the image
                child: Image.asset(
                  imagePath,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 5),
              Text(
                date,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildJobCard(String title, String company) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        child: Column(
          children: [
            ListTile(
                leading: Icon(Icons.work),
                title: Text(title),
                subtitle: Text(company),
             ),
            OutlinedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (builder)=>AboutPage()));
              },
              child: Text('Apply Now' ,style: TextStyle(color: Colors.black , fontWeight: FontWeight.w500 , fontSize: 18),),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.transparent, // Background color for OutlinedButton
                side: BorderSide(color: Colors.black),
                minimumSize: Size(double.infinity, 50), // Max width and height
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Corner radius
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
