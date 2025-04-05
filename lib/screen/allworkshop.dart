import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prideconnect/components/logoanimaionwidget.dart';
import 'package:prideconnect/screen/profilePage.dart';
import '../utils/contstants.dart';

class AllWorkshopPage extends StatefulWidget {
  @override
  _AllWorkshopPageState createState() => _AllWorkshopPageState();
}

class _AllWorkshopPageState extends State<AllWorkshopPage> {
  final List<String> categories = ["All", "workshops", "courses"];
  String selectedCategory = "All";
  String searchQuery = "";

  List<Map<String, dynamic>> workshops = [];
  List<Map<String, dynamic>> courses = [];
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

      final QuerySnapshot snapshotcourse =
      await FirebaseFirestore.instance.collection('courses').get();

      setState(() {
        workshops = snapshot.docs.map((doc) {
          return {
            "title": doc['title'],
            "date": doc['date'],
            "time": doc['time'],
            "description": doc['description'],
            "speaker": doc['speaker'],
            "tags": doc['tags'], // Add tags
            "image": doc['image'],
          };
        }).toList();

        courses = snapshotcourse.docs.map((doc) {
          return {
            "name": doc['name'],
            "register": doc['register'],
            "rating": doc['rating'],
            "type": doc['type'],
            "coins": doc['coins'],
            "tags": doc['tags'],
            "image": doc['admin'],
            "date": doc['time'],
            "time":"2:00 pm",
            "speaker": doc['speaker'],
            "description": doc['description'],
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

    List<Map<String, dynamic>> filteredItems = (selectedCategory == "All")
        ? [...workshops, ...courses]
        : (selectedCategory == "workshops")
        ? workshops
        : courses;

    filteredItems = filteredItems.where((item) {
      final matchesSearch = item['title'] != null
          ? item['title']
          .toLowerCase()
          .contains(searchQuery.toLowerCase())
          : item['name']
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
      return matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: Constants.PrideAPPCOLOUR,
      appBar: AppBar(
        title: const Text(
          "Career Hub",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Constants.PrideAPPCOLOUR,
        elevation: 0,
        leading: Icon(Icons.arrow_back,color: Colors.white,),
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

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text(
              "Explore and register for our learning sessions",
              style: TextStyle(fontSize: 16, color: Colors.white),
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: categories.map((category) {
                final isSelected = category == selectedCategory;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ChoiceChip(
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
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  return Card(
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(vertical: 8 ,horizontal: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, bottom: 10, right: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                (item['title'] ?? item['name']).length > 30
                                    ? '${(item['title'] ?? item['name']).substring(0, 20)}...'
                                    : (item['title'] ?? item['name']),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                              if (item['tags'] != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Wrap(
                                    spacing: 4,
                                    children: item['tags']
                                        .split(',')
                                        .map<Widget>((tag) {
                                      return Chip(
                                        label: Text(
                                          tag.trim(),
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white),
                                        ),
                                        backgroundColor: Colors.teal,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(50),
                                          side: const BorderSide(
                                              color: Colors.white,
                                              width: 1),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 8),
                          if (item['date'] != null && item['time'] != null)
                            Row(
                              children: [
                                Icon(Icons.calendar_today, size: 16),
                                SizedBox(width: 4),
                                Text(
                                    "${item['date']} • ${item['time']}"),
                              ],
                            ),
                          SizedBox(height: 8),
                          if (item['description'] != null)
                            Text(
                              item['description'],
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              if (item['image'] != null)
                                CircleAvatar(
                                  radius: 16,
                                  backgroundImage: NetworkImage(
                                      item['image']), // Use image URL
                                ),
                              if (item['image'] == null)
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Colors.grey[300],
                                  child: Icon(Icons.person,
                                      color: Colors.white),
                                ),
                              SizedBox(width: 8),
                              if (item['speaker'] != null)
                                Text(
                                  item['speaker'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500),
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
}