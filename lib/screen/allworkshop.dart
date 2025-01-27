import 'package:flutter/material.dart';

import '../utils/contstants.dart';

class AllWorkshopPage extends StatefulWidget {
  @override
  _AllWorkshopPageState createState() => _AllWorkshopPageState();
}

class _AllWorkshopPageState extends State<AllWorkshopPage> {
  final List<String> categories = ["All", "Design", "Technology", "Business"];
  String selectedCategory = "All";
  String searchQuery = "";

  final List<Map<String, dynamic>> workshops = [
    {
      "title": "Advanced UI/UX Workshop",
      "date": "March 15, 2024",
      "time": "2:00 PM",
      "description": "Master advanced UI/UX principles and learn how to create intuitive user experiences through hands-on exercises.",
      "category": "Design",
      "speaker": "Sarah Anderson",
    },
    {
      "title": "React.js Deep Dive",
      "date": "March 18, 2024",
      "time": "10:00 AM",
      "description": "Explore advanced React concepts, hooks, and state management through practical examples and real-world applications.",
      "category": "Technology",
      "speaker": "Michael Chen",
    },
    {
      "title": "Digital Marketing Strategy",
      "date": "March 20, 2024",
      "time": "3:00 PM",
      "description": "Learn effective digital marketing strategies and techniques to grow your business in the modern digital landscape.",
      "category": "Business",
      "speaker": "Emily Rodriguez",
    },
  ];

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
        title: const Text("Upcoming Workshops" ,style: TextStyle(color: Colors.white ,fontWeight: FontWeight.bold),),
        backgroundColor: Constants.PrideAPPCOLOUR,
        elevation: 0,
        // foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
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
              child: ListView.builder(
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
                      padding: const EdgeInsets.all(16.0),
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
                              if (workshop['category'] != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getCategoryColor(
                                        workshop['category']),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    workshop['category'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.calendar_today, size: 16),
                              SizedBox(width: 4),
                              Text("${workshop['date']} • ${workshop['time']}"),
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
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.grey[300],
                                child: Icon(Icons.person, color: Colors.white),
                              ),
                              SizedBox(width: 8),
                              Text(
                                workshop['speaker'],
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              Spacer(),
                              ElevatedButton(
                                onPressed: () {
                                  // Navigator.push(context, MaterialPageRoute(builder: (_)=>NGOs()));
                                },
                                child: Text('Register'),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.black.withOpacity(.8),// Max width and height
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10), // Corner radius
                                  ),
                                ),),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20,)
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
        return Colors.grey;
    }
  }
}
