// course_page.dart
import 'package:flutter/material.dart';

import '../components/featuredcoursescarausel.dart';

class CoursePage extends StatefulWidget {
  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/images/loading.png', height: 30),
            Row(
              children: [
                Icon(Icons.notifications_outlined, color: Colors.black),
                SizedBox(width: 10),
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/g.png'),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Featured Courses
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Featured Courses",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text("View More"),
                  ),
                ],
              ),
              SizedBox(height: 10),
              FeaturedCoursesCarousel(), // Use the carousel widget here
              SizedBox(height: 20),

              // Upcoming Workshops
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Upcoming Workshops",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text("View More"),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _buildWorkshopCard("Web Development Bootcamp",
                  "March 15, 2024 - 2:00 PM", Icons.code, "Register"),
              SizedBox(height: 10),
              _buildWorkshopCard("Digital Marketing Workshop",
                  "March 18, 2024 - 10:00 AM", Icons.mark_email_read, "Register"),
              SizedBox(height: 20),

              // Job Opportunities
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Job Opportunities",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text("View More"),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _buildJobCard(
                  "Senior Product Designer",
                  "TechCorp Solutions",
                  "Remote",
                  "Full-time",
                  "assets/images/g.png",
                  "Apply Now"),
              SizedBox(height: 10),
              _buildJobCard(
                  "Frontend Developer",
                  "InnovateLab",
                  "Hybrid",
                  "Full-time",
                  "assets/images/g.png",
                  "Apply Now"),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widgets
  Widget _buildWorkshopCard(String title, String dateTime, IconData icon, String buttonText) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 5),
                  Text(
                    dateTime,
                    maxLines: 1,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: (){},
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black.withOpacity(.8), // Background color for ElevatedButton
                // minimumSize: Size(double.infinity, 50), // Max width and height
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Corner radius
                ),
              ),
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobCard(String title, String company, String location, String type,
      String logoPath, String buttonText) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Image.asset(logoPath, height: 40),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 5),
                  Text(
                    company,
                    maxLines: 1,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      _buildChip(location, Colors.blue[50]!),
                      SizedBox(width: 5),
                      _buildChip(type, Colors.green[50]!),
                    ],
                  )
                ],
              ),
            ),
            ElevatedButton(
              onPressed: (){},
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black.withOpacity(.8), // Background color for ElevatedButton
                // minimumSize: Size(double.infinity, 50), // Max width and height
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Corner radius
                ),
              ),
              child: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, color: Colors.black),
      ),
    );
  }
}