import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:lottie/lottie.dart';
import 'package:prideconnect/screen/profilePage.dart';
import 'package:prideconnect/utils/contstants.dart';
import 'package:url_launcher/url_launcher.dart';
import '../components/scrollutil.dart';
import '../components/tt.dart';

class NGOs extends StatefulWidget {
  @override
  _NGOsState createState() => _NGOsState();
}

class _NGOsState extends State<NGOs> {
  late ScrollController _scrollController;
  String? selectedRadius = "5 km";
  gmaps.Marker? _selectedMarker;
  String? _selectedTitle;
  String? _selectedSnippet;
  gmaps.LatLng? _selectedPosition;
  String? selectedCommunityType = "LGBTQ+";
  String? selectedServiceCategory = "Education";
  bool showngo = false;
  final Completer<gmaps.GoogleMapController> _controller = Completer<gmaps.GoogleMapController>();

  Future<void> _zoomIn() async {
    final controller = await _controller.future;
    controller.animateCamera(gmaps.CameraUpdate.zoomIn());
  }

  Future<void> _zoomOut() async {
    final controller = await _controller.future;
    controller.animateCamera(gmaps.CameraUpdate.zoomOut());
  }

  void _openGoogleMaps(double lat, double lng) async {
    final Uri googleMapsUrl = Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lng");

    if (await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication)) {
      await canLaunchUrl(googleMapsUrl);
    } else {
      throw "Could not open Google Maps.";
    }
  }


  // Initial position (Delhi coordinates)
  static const gmaps.CameraPosition _kDelhi = gmaps.CameraPosition(
    target: gmaps.LatLng(28.5431, 77.1178), // Delhi coordinates
    zoom: 10.0,
  );

  final List<String> radiusOptions = ["1 km", "5 km", "10 km", "20 km"];
  final List<String> communityTypes = ["LGBTQ+", "Women", "Youth", "Seniors"];
  final List<String> serviceCategories = [
    "Education",
    "Healthcare",
    "Job Training",
    "Legal Aid"
  ];

  final Set<gmaps.Marker> _markers = <gmaps.Marker>{};

  @override
  void initState() {
    super.initState();
    _addMallMarkers();
    _scrollController = ScrollController();
  }

  void _onMarkerTapped(gmaps.Marker marker, String title, String snippet) {
    setState(() {
      _selectedMarker = marker;
      _selectedTitle = title;
      _selectedSnippet = snippet;
      _selectedPosition = marker.position;
    });
  }

  void _addMallMarkers() {
    List<Map<String, dynamic>> malls = [
      {
        'id': 'select_citywalk',
        'position': gmaps.LatLng(28.5286, 77.2186),
        'title': 'Select Citywalk',
        'snippet': 'A premier shopping and entertainment destination in Saket.',
      },
      {
        'id': 'ambience_mall',
        'position': gmaps.LatLng(28.5431, 77.1175),
        'title': 'Ambience Mall',
        'snippet': 'One of the largest malls in Delhi, located in Vasant Kunj.',
      },
      {
        'id': 'dlf_promenade',
        'position': gmaps.LatLng(28.5415, 77.1516),
        'title': 'DLF Promenade',
        'snippet': 'A popular mall with a mix of luxury and high-street brands.',
      },
      {
        'id': 'pacifica_mall',
        'position': gmaps.LatLng(28.6905, 77.1478),
        'title': 'Pacifica Mall',
        'snippet': 'A shopping and entertainment hub in Ghaziabad, near Delhi.',
      },
      {
        'id': 'vega_city_mall',
        'position': gmaps.LatLng(28.4125, 77.0444),
        'title': 'Vega City Mall',
        'snippet': 'A modern mall with a variety of retail and dining options.',
      },
    ];

    setState(() {
      _markers.clear(); // Clear existing markers (optional)

      for (var mall in malls) {
        _markers.add(
          gmaps.Marker(
            markerId: gmaps.MarkerId(mall['id']),
            position: mall['position'],
            // icon: gmaps.BitmapDescriptor.defaultMarkerWithHue(gmaps.BitmapDescriptor.defaultMarker),
            onTap: () => _onMarkerTapped(
              gmaps.Marker(markerId: gmaps.MarkerId(mall['id']), position: mall['position']),
              mall['title'],
              mall['snippet'],
            ),
          ),
        );
      }
    });
  }

  Widget _buildCustomInfoBox() {
    if (_selectedMarker == null || _selectedPosition == null) return SizedBox();

    return Positioned(
      top: 100, // Adjust position based on marker location
      left: 50,
      right: 50,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                spreadRadius: 2,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _selectedTitle ?? "Unknown Place",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 4),
              Text(
                _selectedSnippet ?? "No details available.",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_selectedPosition != null) {
                        _openGoogleMaps(_selectedPosition!.latitude, _selectedPosition!.longitude);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey, // Background color
                      foregroundColor: Colors.white, // Text color
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Adjust padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // Rounded corners
                      ),
                    ),
                    child: Text("Contact Us"),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _selectedMarker = null;
                        _selectedPosition = null;
                        _selectedTitle = null;
                        _selectedSnippet = null;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    ScrollUtils.scrollToPosition(
      _scrollController,
      _scrollController.position.minScrollExtent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.PrideAPPCOLOUR,
      appBar: AppBar(
        title: Text(
          "Community",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Constants.PrideAPPCOLOUR,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProfilePage()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/loading.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Lottie.asset(
                'assets/animation/yy.json',
                width: double.infinity,
                height: 400,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 80),
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
                      onPressed: () {
                        setState(() {
                          showngo = !showngo;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.white.withOpacity(.8), // Background color for ElevatedButton
                        minimumSize: const Size(double.infinity, 50), // Max width and height
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Corner radius
                        ),
                      ),
                      child: const Text('Search NGOs',style: TextStyle(color: Constants.PrideAPPCOLOUR),),
                    ),
                  ),
                  // Expanded(
                  //   child: AnimatedButtonn(
                  //     onPressed: () {
                  //       setState(() {
                  //         showngo = !showngo;
                  //       });
                  //       _scrollToBottom();
                  //     },
                  //     child: const Text(
                  //       'Search NGOs',
                  //       style: TextStyle(color: Constants.PrideAPPCOLOUR),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.transparent,
                        side: BorderSide(color: Colors.white),
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Reset',
                        style: TextStyle(
                          color: Constants.WHITE,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (showngo)
                Column(
                  children: [
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
          child:TextField(
            style: const TextStyle(color: Colors.white), // Text color
            decoration: InputDecoration(
              labelText: "Location",
              hintText: "Enter location or use current",
              labelStyle: const TextStyle(color: Colors.white), // Label text color
              hintStyle: const TextStyle(color: Colors.white), // Hint text color
              filled: true,
              fillColor: Colors.transparent, // Background color
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.white, width: 1.5), // Default border color
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.blue, width: 2.0), // Border color when focused
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.red, width: 2.0), // Border color on error
              ),
              suffixIcon: const Icon(Icons.location_on, color: Colors.white), // Icon color
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
              hintText: "Radius",
              labelStyle: const TextStyle(color: Colors.white), // Label text color
              hintStyle: const TextStyle(color: Colors.white), // Hint text color
              filled: true,
              fillColor: Colors.transparent, // Background color
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.white, width: 1.5), // Default border color
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.white, width: 2.0), // Border color when focused
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.white, width: 2.0), // Border color on error
              ),
            ),
            icon: const Icon(Icons.arrow_drop_down, color: Colors.white), // White dropdown arrow
            dropdownColor: Colors.black, // Optional: Changes dropdown menu background color
            items: radiusOptions.map((String radius) {
              return DropdownMenuItem(
                value: radius,
                child: Text(radius, style: const TextStyle(color: Colors.white)), // White text
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
        hintText: value,
        labelStyle: const TextStyle(color: Colors.white), // Label text color
        hintStyle: const TextStyle(color: Colors.white), // Hint text color
        filled: true,
        fillColor: Colors.transparent, // Background color
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.white, width: 1.5), // Default border color
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.white, width: 2.0), // Border color when focused
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.white, width: 2.0), // Border color on error
        ),
      ),
      icon: const Icon(Icons.arrow_drop_down, color: Colors.white), // White dropdown arrow
      dropdownColor: Colors.black,
      items: options.map((String option) {
        return DropdownMenuItem(
          value: option,
          child: Text(option, style: const TextStyle(color: Colors.white)),
        );
      }).toList(),
    );
  }

  Widget _buildMapPlaceholder() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0), // Add border radius
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2.0), // White border
          borderRadius: BorderRadius.circular(16.0), // Match border radius
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14.0), // Slightly smaller to fit inside border
          child: Container(
            height: 500,
            width: double.infinity,
            child: Stack(
              children: [
                gmaps.GoogleMap(
                  mapType: gmaps.MapType.normal,
                  initialCameraPosition: _kDelhi,
                  onMapCreated: (gmaps.GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  markers: _markers,
                  zoomControlsEnabled: false, // Hide default buttons
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                ),

                // Custom Floating Info Box
                _buildCustomInfoBox(),

                // Zoom In/Out Buttons
                Positioned(
                  bottom: 80,
                  right: 16,
                  child: Column(
                    children: [
                      FloatingActionButton(
                        heroTag: "zoomIn",
                        mini: true,
                        onPressed: _zoomIn,
                        child: Icon(Icons.add,color: Colors.white, size: 30),
                        backgroundColor: Constants.PrideAPPCOLOUR,
                      ),
                      SizedBox(height: 10),
                      FloatingActionButton(
                        heroTag: "zoomOut",
                        mini: true,
                        onPressed: _zoomOut,
                        child: Icon(Icons.remove,color: Colors.white, size: 30),
                        backgroundColor: Constants.PrideAPPCOLOUR,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
