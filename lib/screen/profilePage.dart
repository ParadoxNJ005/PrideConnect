import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // State variables
  String fullName = "Sarah Mitchell";
  String genderIdentity = "Non-binary";
  String sexualOrientation = "Pansexual";
  String currentRole = "UX Designer";
  String industry = "Technology";
  String experience = "5 years";
  bool isNgoMember = false;
  bool isAvailableForVolunteering = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture and Name
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/avatar.png'), // Replace with your avatar image
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fullName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "They/Them",
                        style: TextStyle(color: Colors.grey),
                      ),
                      const Text(
                        "85% Profile Complete",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Personal Information Section
              const Text(
                "Personal Information",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: fullName,
                decoration: const InputDecoration(labelText: "Full Name"),
                onChanged: (value) {
                  setState(() {
                    fullName = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: genderIdentity,
                decoration: const InputDecoration(labelText: "Gender Identity"),
                items: ["Non-binary", "Male", "Female", "Other"]
                    .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    genderIdentity = value!;
                  });
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: sexualOrientation,
                decoration:
                const InputDecoration(labelText: "Sexual Orientation"),
                items: ["Pansexual", "Heterosexual", "Homosexual", "Bisexual"]
                    .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    sexualOrientation = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              // Career Information Section
              const Text(
                "Career Information",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: currentRole,
                decoration: const InputDecoration(labelText: "Current Role"),
                onChanged: (value) {
                  setState(() {
                    currentRole = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: industry,
                decoration: const InputDecoration(labelText: "Industry"),
                onChanged: (value) {
                  setState(() {
                    industry = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: experience,
                decoration: const InputDecoration(labelText: "Experience"),
                onChanged: (value) {
                  setState(() {
                    experience = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              // Community Section
              const Text(
                "Community",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SwitchListTile(
                title: const Text("NGO Member"),
                value: isNgoMember,
                onChanged: (value) {
                  setState(() {
                    isNgoMember = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text("Available for Volunteering"),
                value: isAvailableForVolunteering,
                onChanged: (value) {
                  setState(() {
                    isAvailableForVolunteering = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              // Save Changes Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle save changes logic
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Changes Saved!")),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text("Save Changes"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
