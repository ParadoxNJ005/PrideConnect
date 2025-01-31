import 'package:flutter/material.dart';
import 'package:prideconnect/database/Apis.dart';
import 'package:prideconnect/model/chatuser.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool profileVisibility = false;
  bool volunteerInterest = false;
  ChatUser? me;
  bool _isUpdating = false; // To show loading indicator during update

  // Controllers for editable fields
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _ageController;
  late TextEditingController _addressController;
  late TextEditingController _orientationController;
  late TextEditingController _jobTitleController;

  @override
  void initState() {
    super.initState();
    me = APIs.me;

    // Initialize controllers with current user data
    _nameController = TextEditingController(text: me?.name ?? '');
    _phoneController = TextEditingController(text: me?.phone ?? '');
    _ageController = TextEditingController(text: me?.age ?? '');
    _addressController = TextEditingController(text: me?.address ?? '');
    _orientationController = TextEditingController(text: me?.orientation ?? '');
    _jobTitleController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    _nameController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    _orientationController.dispose();
    _jobTitleController.dispose();
    super.dispose();
  }

  // Function to update user data in Firebase
  Future<void> _updateProfile() async {
    setState(() {
      _isUpdating = true; // Show loading indicator
    });

    try {
      // Create a map of updated fields
      Map<String, dynamic> updatedData = {
        'name': _nameController.text,
        'phone': _phoneController.text,
        'age': _ageController.text,
        'address': _addressController.text,
        'orientation': _orientationController.text,
        'jobTitle': _jobTitleController.text,
        // 'profileVisibility': profileVisibility,
        // 'volunteerInterest': volunteerInterest,
      };

      // Call the API to update user data in Firebase
      await APIs.updateUserData(updatedData);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully!')),
      );
    } catch (e) {
      // Show error message if update fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    } finally {
      setState(() {
        _isUpdating = false; // Hide loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (me == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // Add settings navigation logic here
            },
          ),
        ],
      ),
      body: _isUpdating
          ? Center(child: CircularProgressIndicator()) // Show loading indicator while updating
          : SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildProfileHeader(),
            SizedBox(height: 20),
            _buildProfileCompletion(),
            SizedBox(height: 20),
            _buildCoins(),
            SizedBox(height: 20),
            _buildSectionContainer(
              title: 'Personal Information',
              child: _buildPersonalInfo(),
            ),
            _buildSectionContainer(
              title: 'Professional Details',
              child: _buildProfessionalDetails(),
            ),
            _buildSectionContainer(
              title: 'Preferences',
              child: _buildPreferences(),
            ),
            _buildSectionContainer(
              title: 'Community',
              child: _buildCommunity(),
            ),
            _buildSectionContainer(
              title: 'NGO Affiliations',
              child: _buildChipSection(me!.ngos),
            ),
            _buildSectionContainer(
              title: 'Workshops',
              child: _buildChipSection(me!.workshops),
            ),
            _buildSectionContainer(
              title: 'Campaigns',
              child: _buildChipSection(me!.campaign),
            ),
            _buildSectionContainer(
              title: 'Orders',
              child: _buildChipSection(me!.orders),
            ),
            SizedBox(height: 20),
            _buildUpdateButton(), // Update button
            SizedBox(height: 10),
            _buildSignOutButton(), // Sign Out button
          ],
        ),
      ),
    );
  }

  Widget _buildSectionContainer({required String title, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          Divider(color: Colors.grey[300]),
          SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey[300],
            backgroundImage: me!.image.isNotEmpty ? NetworkImage(me!.image) : null,
            child: me!.image.isEmpty ? Icon(Icons.person, size: 40, color: Colors.grey[700]) : null,
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                me!.name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              SizedBox(height: 4),
              Text(
                me!.gender,
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              SizedBox(height: 4),
              Text(
                me!.email, // Email is fixed and cannot be updated
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCompletion() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profile Completion',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          SizedBox(height: 8),
          LinearProgressIndicator(
            value: 0.85,
            backgroundColor: Colors.grey[300],
            color: Colors.black,
            minHeight: 8,
          ),
          SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '85%',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoins() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Coins',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          Text(
            me!.coins.toString(),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfo() {
    return Column(
      children: [
        _buildTextField('Full Name', _nameController),
        _buildTextField('Phone', _phoneController),
        _buildTextField('Age', _ageController),
        _buildTextField('Address', _addressController),
        _buildTextField('Orientation', _orientationController),
      ],
    );
  }

  Widget _buildProfessionalDetails() {
    return Column(
      children: [
        _buildTextField('Job Title', _jobTitleController),
        _buildChipSection(me!.interest),
      ],
    );
  }

  Widget _buildPreferences() {
    return Column(
      children: [
        _buildSwitchTile('Profile Visibility', profileVisibility, (val) => setState(() => profileVisibility = val)),
        _buildSwitchTile('Volunteer Interest', volunteerInterest, (val) => setState(() => volunteerInterest = val)),
      ],
    );
  }

  Widget _buildCommunity() {
    return Column(
      children: [
        _buildChipSection(me!.ngos),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[700]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
      ),
    );
  }

  Widget _buildChipSection(List<String> items) {
    return Wrap(
      spacing: 8.0,
      children: items.map((item) => Chip(
        label: Text(item, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      )).toList(),
    );
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(title, style: TextStyle(fontSize: 16, color: Colors.black87)),
      value: value,
      activeColor: Colors.blue,
      activeTrackColor: Colors.blue.withOpacity(0.3),
      inactiveThumbColor: Colors.grey[600],
      inactiveTrackColor: Colors.grey[400],
      onChanged: onChanged,
    );
  }

  Widget _buildUpdateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: _updateProfile,
        child: Text(
          'Update Profile',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildSignOutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: () async {
          await APIs.Signout();
          Navigator.pop(context);
          print("User Signed Out");
        },
        child: Text(
          'Sign Out',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}