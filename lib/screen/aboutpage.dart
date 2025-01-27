import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Community Connect",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              color: Colors.grey.withOpacity(.1),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Image.asset("assets/images/a.png" , width: 200, height: 200),
                  const SizedBox(height: 16),
                  const Text(
                    "Empowering\n Dreams, Embracing\n Diversity",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Building bridges to equal career opportunities through upskilling and community support",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                  SizedBox(height: 20,)
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Stats Section
            Container(
              height: 300,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(.1),
                borderRadius: BorderRadius.circular(0), // Add border radius here
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  _StatWidget(title: "5000+", subtitle: "Community Members" ),
                  SizedBox(height: 20,),
                  _StatWidget(title: "200+", subtitle: "Success Stories"),
                  SizedBox(height: 20,),
                  _StatWidget(title: "50+", subtitle: "Corporate Partners"),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Core Values Section
            Center(
              child: Text(
                "Our Core Values",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 15),
            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
                childAspectRatio: 1.3,
              ),
              children: const [
                _CoreValueWidget(icon: Icons.favorite, title: "Inclusivity", subtitle: "Embracing\n all identities",color: Colors.pink,),
                _CoreValueWidget(icon: Icons.support, title: "Support", subtitle: "Always here for you",color: Colors.purple,),
                _CoreValueWidget(icon: Icons.school, title: "Growth", subtitle: "Continuous\n learning",color: Colors.blueAccent,),
                _CoreValueWidget(icon: Icons.people, title: "Community", subtitle: "Stronger together",color: Colors.green,),
              ],
            ),
            const SizedBox(height: 30),

            // Meet Our Team Section
            const Center(
              child: Text(
                "Meet Our Team",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 25),
            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              children: const [
                _TeamMemberWidget(name: "Sarah Chen", role: "Founder & CEO"),
                _TeamMemberWidget(name: "Alex Rivera", role: "Community Director"),
                _TeamMemberWidget(name: "Jordan Taylor", role: "Programs Lead"),
                _TeamMemberWidget(name: "Mei Wong", role: "Partnerships Head"),
              ],
            ),
            const SizedBox(height: 30),
            const Center(
              child: Text(
                "Join Our Journey",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Explore Opportunities' ,style: TextStyle(color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      backgroundColor: Colors.blueAccent.withOpacity(.8), // Max width and height
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Corner radius
                      ),
                    ),
                  ),
                  SizedBox(height: 10), // Space between buttons
                  OutlinedButton(
                    onPressed: () {},
                    child: Text('Join with Google' ,style: TextStyle(color: Colors.blueAccent , fontWeight: FontWeight.w500),),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blueAccent,
                      backgroundColor: Colors.transparent, // Background color for OutlinedButton
                      side: BorderSide(color: Colors.blueAccent), // Max width and height
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Corner radius
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.whatshot, size: 30),
                SizedBox(width: 40),
                Icon(Icons.whatshot, size: 30),
                SizedBox(width: 40),
                Icon(Icons.language, size: 30),
              ],
            ),
            const SizedBox(height: 30),
            //
            // // Feedback Section
            // const Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 16.0),
            //   child: Text(
            //     "Share Your Feedback",
            //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            //   ),
            // ),
            // const SizedBox(height: 10),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
            //   child: Column(
            //     children: [
            //       const TextField(
            //         decoration: InputDecoration(
            //           labelText: "Name",
            //           border: OutlineInputBorder(),
            //         ),
            //       ),
            //       const SizedBox(height: 10),
            //       const TextField(
            //         decoration: InputDecoration(
            //           labelText: "Email",
            //           border: OutlineInputBorder(),
            //         ),
            //       ),
            //       const SizedBox(height: 10),
            //       const TextField(
            //         maxLines: 4,
            //         decoration: InputDecoration(
            //           labelText: "Message",
            //           border: OutlineInputBorder(),
            //         ),
            //       ),
            //       const SizedBox(height: 10),
            //       ElevatedButton(
            //         onPressed: () {},
            //         style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            //         child: const Text("Send Feedback"),
            //       ),
            //     ],
            //   ),
            // ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _StatWidget extends StatelessWidget {
  final String title;
  final String subtitle;

  const _StatWidget({Key? key, required this.title, required this.subtitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold ,color: Colors.purple)),
        const SizedBox(height: 5),
        Text(subtitle, style: const TextStyle(fontSize: 15, color: Colors.black54)),
      ],
    );
  }
}

class _CoreValueWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _CoreValueWidget({Key? key, required this.icon, required this.title, required this.subtitle, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color,size: 30,),
          const SizedBox(width: 18),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold ,fontSize: 17)),
              SizedBox(height: 8,),
              Text(subtitle, textAlign: TextAlign.center , style: const TextStyle(fontSize: 15, color: Colors.black54)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SuccessStoryWidget extends StatelessWidget {
  final String title;
  final String description;

  const _SuccessStoryWidget({Key? key, required this.title, required this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade200,
        ),
        child: Row(
          children: [
            const Placeholder(fallbackHeight: 80, fallbackWidth: 80),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text(description, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TeamMemberWidget extends StatelessWidget {
  final String name;
  final String role;

  const _TeamMemberWidget({Key? key, required this.name, required this.role}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipOval(child: Image.asset("assets/images/d.png" , fit: BoxFit.contain,)),
        const SizedBox(height: 10),
        Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(role, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
