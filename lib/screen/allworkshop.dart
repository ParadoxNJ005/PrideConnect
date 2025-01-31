import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prideconnect/components/logoanimaionwidget.dart';
import '../utils/contstants.dart';

class AllWorkshopPage extends StatefulWidget {
  @override
  _AllWorkshopPageState createState() => _AllWorkshopPageState();
}

class _AllWorkshopPageState extends State<AllWorkshopPage> {
  final List<String> categories = ["All", "Design", "Technology", "Business"];
  String selectedCategory = "All";
  String searchQuery = "";

  List<Map<String, dynamic>> workshops = [];
  bool isLoading = true; // Add a loading state

  @override
  void initState() {
    super.initState();
    _fetchWorkshops();
  }

  Future<void> _fetchWorkshops() async {
    try {
      final QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('workshops').get();

      setState(() {
        workshops = snapshot.docs.map((doc) {
          return {
            "title": doc['title'],
            "date": doc['date'],
            "time": doc['time'],
            "description": doc['description'],
            "category": doc['category'],
            "speaker": doc['speaker'],
            "tags": doc['tags'], // Add tags
            "image": doc['image'], // Add image URL
          };
        }).toList();
        isLoading = false; // Data has been loaded
      });
    } catch (e) {
      print("Error fetching workshops: $e");
      setState(() {
        isLoading = false; // Stop loading even if there's an error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredWorkshops = workshops.where((workshop) {
      final matchesCategory =
          selectedCategory == "All" || workshop['category'] == selectedCategory;
      final matchesSearch = workshop['title']
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Upcoming Workshops",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Constants.PrideAPPCOLOUR,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text(
              "Explore and register for our learning sessions",
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: "Search workshops...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: categories.map((category) {
                final isSelected = category == selectedCategory;
                return ChoiceChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                  selectedColor: Colors.blue[100],
                  backgroundColor: Colors.grey[200],
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.blue : Colors.black,
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? Center(
                child: LogoAnimationWidget(), // Show loading indicator
              )
                  : ListView.builder(
                itemCount: filteredWorkshops.length,
                itemBuilder: (context, index) {
                  final workshop = filteredWorkshops[index];
                  return Card(
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0 ,bottom: 10 , right: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                workshop['title'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                              if (workshop['tags'] != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Wrap(
                                    spacing: 4,
                                    children: workshop['tags']
                                        .split(',')
                                        .map<Widget>((tag) {
                                      return Chip(
                                        label: Text(
                                          tag.trim(),
                                          style: const TextStyle(fontSize: 12, color: Colors.white),
                                        ),
                                        backgroundColor: _getCategoryColor(workshop['tags']),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(50), // Fully rounded border
                                          side: const BorderSide(color: Colors.white, width: 1), // Optional border
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              // if (workshop['tags'] != null)
                              //   Container(
                              //     padding: const EdgeInsets.symmetric(
                              //       horizontal: 8,
                              //       vertical: 4,
                              //     ),
                              //     decoration: BoxDecoration(
                              //       color: _getCategoryColor(
                              //           workshop['tags']),
                              //       borderRadius: BorderRadius.circular(8),
                              //     ),
                              //     child: Text(
                              //       workshop['tags'],
                              //       style: TextStyle(
                              //         color: Colors.white,
                              //         fontSize: 12,
                              //         fontWeight: FontWeight.bold,
                              //       ),
                              //     ),
                              //   ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.calendar_today, size: 16),
                              SizedBox(width: 4),
                              Text(
                                  "${workshop['date']} • ${workshop['time']}"),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            workshop['description'],
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              // Display speaker image if available
                              if (workshop['image'] != null)
                                CircleAvatar(
                                  radius: 16,
                                  backgroundImage: NetworkImage(
                                      workshop['image']), // Use image URL
                                ),
                              if (workshop['image'] == null)
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Colors.grey[300],
                                  child: Icon(Icons.person,
                                      color: Colors.white),
                                ),
                              SizedBox(width: 8),
                              Text(
                                workshop['speaker'],
                                style:
                                TextStyle(fontWeight: FontWeight.w500),
                              ),
                              Spacer(),
                              ElevatedButton(
                                onPressed: () {
                                  // Navigator.push(context, MaterialPageRoute(builder: (_)=>NGOs()));
                                },
                                child: Text('Register'),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor:
                                  Colors.black.withOpacity(.8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Display tags if available
                          // if (workshop['tags'] != null)
                          //   Padding(
                          //     padding: const EdgeInsets.only(top: 8.0),
                          //     child: Wrap(
                          //       spacing: 4,
                          //       children: workshop['tags']
                          //           .split(',')
                          //           .map<Widget>((tag) {
                          //         return Chip(
                          //           label: Text(
                          //             tag.trim(),
                          //             style: TextStyle(fontSize: 12),
                          //           ),
                          //           backgroundColor: Colors.grey[200],
                          //         );
                          //       }).toList(),
                          //     ),
                          //   ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case "Design":
        return Colors.green;
      case "Technology":
        return Colors.blue;
      case "Business":
        return Colors.purple;
      default:
        return Colors.teal;
    }
  }
}