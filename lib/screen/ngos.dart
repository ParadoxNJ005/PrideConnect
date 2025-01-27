import 'package:flutter/material.dart';

class NGOs extends StatefulWidget {
  @override
  _NGOsState createState() => _NGOsState();
}

class _NGOsState extends State<NGOs> {
  String? selectedRadius = "5 km";
  String? selectedCommunityType = "LGBTQ+";
  String? selectedServiceCategory = "Education";

  final List<String> radiusOptions = ["1 km", "5 km", "10 km", "20 km"];
  final List<String> communityTypes = ["LGBTQ+", "Women", "Youth", "Seniors"];
  final List<String> serviceCategories = [
    "Education",
    "Healthcare",
    "Job Training",
    "Legal Aid"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Community Connect",
          style: TextStyle(fontFamily: 'Cursive', fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Connect with NGOs Near You",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildLocationInput(),
                const SizedBox(height: 16),
                _buildDropdown(
                  label: "Community Type",
                  value: selectedCommunityType,
                  options: communityTypes,
                  onChanged: (value) {
                    setState(() {
                      selectedCommunityType = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                _buildDropdown(
                  label: "Service Category",
                  value: selectedServiceCategory,
                  options: serviceCategories,
                  onChanged: (value) {
                    setState(() {
                      selectedServiceCategory = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black.withOpacity(.8), // Background color for ElevatedButton
                          minimumSize: const Size(double.infinity, 50), // Max width and height
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Corner radius
                          ),
                        ),
                        child: const Text('Search NGOs'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: (){},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.transparent, // Background color for OutlinedButton
                          side: BorderSide(color: Colors.black),
                          minimumSize: Size(double.infinity, 50), // Max width and height
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Corner radius
                          ),
                        ),
                        child: const Text('Reset' ,style: TextStyle(color: Colors.black , fontWeight: FontWeight.w500 , fontSize: 18),),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () {
                    // Handle Toggle Map action
                  },
                  icon: const Icon(Icons.map),
                  label: const Text("Toggle Map"),
                ),
                const SizedBox(height: 16),
                _buildMapPlaceholder(),
                const SizedBox(height: 16),
                _buildNGOCard(
                  name: "Rainbow Support Network",
                  communityType: "LGBTQ+",
                  distance: "2.3 km",
                  services: "Healthcare, Mental Health",
                  rating: 4.2,
                ),
                const SizedBox(height: 16),
                _buildNGOCard(
                  name: "Pride Community Center",
                  communityType: "LGBTQ+",
                  distance: "3.1 km",
                  services: "Legal Aid, Education",
                  rating: 4.8,
                ),
                const SizedBox(height: 16),
                _buildNGOCard(
                  name: "Queer Youth Alliance",
                  communityType: "Youth Support Services",
                  distance: "4.5 km",
                  services: "Job Training, Education",
                  rating: 4.1,
                ),
              ],
            ),
          ),
      ),
    );
  }

  Widget _buildLocationInput() {
    return Row(
      children: [
        SizedBox(
          width: 250,
          child: TextField(
            decoration: InputDecoration(
              labelText: "Location",
              hintText: "Enter location or use current",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              suffixIcon: const Icon(Icons.location_on),
            ),
          ),
        ),
        const SizedBox(width: 8), // Adjust spacing to prevent overflow
        Flexible(
          flex: 1,
          child: DropdownButtonFormField<String>(
            value: selectedRadius,
            onChanged: (value) {
              setState(() {
                selectedRadius = value;
              });
            },
            decoration: InputDecoration(
              labelText: "Radius",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            items: radiusOptions.map((String radius) {
              return DropdownMenuItem(
                value: radius,
                child: Text(radius),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      items: options.map((String option) {
        return DropdownMenuItem(
          value: option,
          child: Text(option),
        );
      }).toList(),
    );
  }

  Widget _buildMapPlaceholder() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0), // Add border radius
      child: Container(
        height: 200,
        width: double.infinity,
        color: Colors.grey[300],
        child: Image.asset(
          "assets/images/f.png",
          fit: BoxFit.cover,
        ),
      ),
    );
  }


  Widget _buildNGOCard({
    required String name,
    required String communityType,
    required String distance,
    required String services,
    required double rating,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    communityType,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "$distance away · $services",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        rating.toString(),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.phone),
              onPressed: () {
                // Handle phone call action
              },
            ),
          ],
        ),
      ),
    );
  }
}
