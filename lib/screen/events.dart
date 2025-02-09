import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prideconnect/components/logoanimaionwidget.dart';
import 'package:prideconnect/screen/profilePage.dart';
import 'package:prideconnect/utils/contstants.dart';

class Events extends StatefulWidget {
  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? selectedVenue; // Null means "View All" is selected

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.PrideAPPCOLOUR,
      appBar: AppBar(
        title: Text("Events Nearby" , style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold),),
        backgroundColor: Constants.PrideAPPCOLOUR, // Set background color to transparent
        elevation: 0, // Remove the shadow
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back,color: Colors.white,)),
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
      body: Column(
        children: [
          // Venue Filter Dropdown
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0 , horizontal: 30),
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('campaign').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const SizedBox();
                }

                // Extract unique venue names
                List<String> venues = snapshot.data!.docs
                    .map((doc) => (doc.data() as Map<String, dynamic>)['venue']?.toString() ?? "")
                    .toSet()
                    .toList();

                // Add "View All" option
                venues.insert(0, "View All");

                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.2), // Border color & thickness
                    borderRadius: BorderRadius.circular(8.0), // Rounded corners
                    color: Colors.white, // Background color
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 4), // Inner padding
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedVenue ?? "View All",
                      hint: const Text(
                        "Choose a venue",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54),
                      ),
                      isExpanded: true,
                      onChanged: (value) {
                        setState(() {
                          selectedVenue = (value == "View All") ? null : value;
                        });
                      },
                      items: venues.map((venue) {
                        return DropdownMenuItem(
                          value: venue,
                          child: Text(
                            venue,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        );
                      }).toList(),
                      dropdownColor: Colors.white, // Dropdown background color
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.black), // Custom dropdown icon
                      borderRadius: BorderRadius.circular(8), // Rounded corners for dropdown
                    ),
                  ),
                );
              },
            ),
          ),

          // Campaigns List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('campaign').snapshots(), // No date sorting
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: LogoAnimationWidget());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No campaigns available."));
                }

                var campaigns = snapshot.data!.docs
                    .map((doc) => doc.data() as Map<String, dynamic>)
                    .where((data) => selectedVenue == null || data['venue'] == selectedVenue)
                    .toList();

                if (campaigns.isEmpty) {
                  return const Center(child: Text("No campaigns found for this venue."));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0 ,vertical: 16),
                  itemCount: campaigns.length,
                  itemBuilder: (context, index) {
                    var data = campaigns[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildEventCard(
                        title: data['name'] ?? "No Title",
                        date: data['date'] ?? "No Date",
                        location: data['venue'] ?? "No Location",
                        capacity: 500, // Modify if needed
                        imageUrl: data['image'] ?? "assets/images/l.png",
                        registerUrl: data['register'] ?? "",
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard({
    required String title,
    required String date,
    required String location,
    required int capacity,
    required String imageUrl,
    required String registerUrl,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8.0),
              topRight: Radius.circular(8.0),
            ),
            child: Image.network(
              imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Image.asset(
                "assets/images/l.png",
                height: 150,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16),
                    const SizedBox(width: 8),
                    Text(date, style: const TextStyle(fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16),
                    const SizedBox(width: 8),
                    Text(location, style: const TextStyle(fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.people, size: 16),
                    const SizedBox(width: 8),
                    Text("Capacity: $capacity", style: const TextStyle(fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (registerUrl.isNotEmpty) {
                            // Open the registration link
                            // launchUrl(Uri.parse(registerUrl));  // Uncomment if using url_launcher
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black.withOpacity(.8),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Register Now'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => Events()));
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.transparent,
                          side: const BorderSide(color: Colors.black),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Learn More',
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                        ),
                      ),
                    ),
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
