import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class FeaturedCoursesCarousel extends StatelessWidget {
  const FeaturedCoursesCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: CarouselSlider(
        items: [
          _buildCourseCard(
              "Advanced Data Science",
              "Master machine learning and AI fundamentals",
              "assets/images/g.png",
              12),
          _buildCourseCard(
              "UI/UX Design", "Learn user interface design", "assets/images/g.png", 12),
        ],
        options: CarouselOptions(
          height: 290,
          enlargeCenterPage: true,
          enableInfiniteScroll: true, // Enable infinite scroll
          viewportFraction: 1,
          autoPlay: true, // Enable auto-play
          autoPlayInterval: Duration(seconds: 3), // Set auto-play interval (e.g., 3 seconds)
          autoPlayAnimationDuration: Duration(milliseconds: 800), // Animation duration
          autoPlayCurve: Curves.fastOutSlowIn, // Animation curve
        ),
      ),
    );
  }

  Widget _buildCourseCard(String title, String subtitle, String imagePath, int duration) {
    return Card(
      elevation: 5, // Add elevation for shadow effect
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Rounded corners for the card
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.asset(
              imagePath,
              height: 155,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
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
                  subtitle,
                  maxLines: 1,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: List.generate(
                        5,
                            (index) => Icon(
                          Icons.star,
                          size: 17,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                    Text("$duration weeks"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}