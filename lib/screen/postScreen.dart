import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:prideconnect/screen/profilePage.dart';
import '../components/dashedborder.dart';
import '../components/helpr.dart';
import '../components/logoanimaionwidget.dart';
import '../utils/contstants.dart';

class SelectMedia extends StatefulWidget {
  const SelectMedia({super.key});

  @override
  _SelectMediaState createState() => _SelectMediaState();
}

class _SelectMediaState extends State<SelectMedia> {
  final ImagePicker _picker = ImagePicker();
  List<File> mediaUrls = [];
  bool _isLoading = false;
  static const int maxMediaCount = 1;
  final TextEditingController _captionController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _captionController.dispose();
  }

  void _showLimitWarningDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Limit Reached"),
        content: Text("You can select a maximum of 1 images/videos."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImageFromCamera() async {
    if (mediaUrls.length >= maxMediaCount) {
      _showLimitWarningDialog();
      return;
    }

    final permissionStatus = await Permission.camera.request();
    if (permissionStatus.isGranted) {
      final XFile? media = await _picker.pickImage(source: ImageSource.camera);
      if (media != null) {
        setState(() {
          mediaUrls.add(File(media.path));
        });
      }
    } else {
      print("Camera permission denied");
    }
  }

  Future<void> _pickImagesFromGallery() async {
    if (mediaUrls.length >= maxMediaCount) {
      _showLimitWarningDialog();
      return;
    }

    final permissionStatus = await Permission.photos.request();
    if (!permissionStatus.isGranted) {
      final List<XFile>? images = await _picker.pickMultiImage();
      if (images != null) {
        final availableSlots = maxMediaCount - mediaUrls.length;
        final selectedImages = images.take(availableSlots).map((image) => File(image.path)).toList();

        setState(() {
          mediaUrls.addAll(selectedImages);
        });
      }
    } else {
      print("Gallery permission denied");
    }
  }

  Future<void> _pickVideoFromGallery() async {
    if (mediaUrls.length >= maxMediaCount) {
      _showLimitWarningDialog();
      return;
    }

    final permissionStatus = await Permission.photos.request();
    if (!permissionStatus.isGranted) {
      final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        setState(() {
          mediaUrls.add(File(video.path));
        });
      }
    } else {
      print("Gallery permission denied");
    }
  }

  void _removeMedia(int index) {
    setState(() {
      mediaUrls.removeAt(index);
    });
  }

  void _navigateToAddPost() async {
    if (mediaUrls.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      // Simulate a network call
      await Future.delayed(Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      Dialogs.showSnackbar(context, "Upload Successful");
    } else {
      Dialogs.showSnackbar(context, "Upload At least One Image/Video");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Constants.PrideAPPCOLOUR,
          appBar: AppBar(
            title: Text("Pride Connect", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                    Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset('assets/images/loading.png', fit: BoxFit.contain),
                  ),
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 26.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Lottie.asset(
                      "assets/animation/pq.json",
                      height: 300, // Adjust height
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Photos",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    temp(),
                    const SizedBox(height: 25),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Remark",
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.white),
                        ),
                        const SizedBox(height: 5),
                        TextField(
                          maxLines: 2,
                          controller: _captionController,
                          decoration: InputDecoration(
                            hintText: "Add your remark here",
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 18.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.6),
                                width: 1.0,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.6),
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.6),
                                width: 1.0,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
                          ),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity, // Full width
              height: 50, // Adjustable height
              child: ElevatedButton.icon(
                onPressed: _navigateToAddPost,
                icon: Icon(Icons.send, color: Colors.white),
                label: Text("Post", style: TextStyle(color: Colors.white, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent, // Transparent background
                  side: BorderSide(color: Colors.grey.withOpacity(0.5), width: 2), // White border
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Slightly rounded corners
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20), // Adjust padding
                ),
              ),
            ),
          ),

        ),
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: LogoAnimationWidget(),
            ),
          ),
      ],
    );
  }

  Widget temp() {
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            DashedBorder(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 180,
                width: double.infinity,
                alignment: Alignment.center,
                child: IconButton(
                  icon: Icon(Icons.image_search_rounded, color: Colors.grey.withOpacity(0.5), size: 65),
                  onPressed: () {
                    _pickImageFromCamera();
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: IconButton(
                icon: Icon(Icons.photo_library, color: Colors.grey[700], size: 30),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          tileColor: Constants.APPCOLOUR,
                          leading: Icon(Icons.image, color: Colors.black),
                          title: Text('Pick Image from Gallery', style: TextStyle(color: Colors.black)),
                          onTap: _pickImagesFromGallery,
                        ),
                        ListTile(
                          tileColor: Constants.APPCOLOUR,
                          leading: Icon(Icons.video_library, color: Colors.black),
                          title: Text('Pick Video from Gallery', style: TextStyle(color: Colors.black)),
                          onTap: _pickVideoFromGallery,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        if (mediaUrls.isNotEmpty) ...[
          SizedBox(height: 26),
          Container(
            width: double.infinity,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Recent',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 26),
          Container(
            height: size.height * .25,
            child: GridView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 200 / 150,
              ),
              itemCount: mediaUrls.length,
              itemBuilder: (context, index) {
                final mediaPath = mediaUrls[index];

                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14.0),
                      child: Container(
                        width: 150,
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black.withOpacity(0.3), width: 1),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: mediaPath.path.endsWith('.mp4')
                            ? Container()
                            : Image.file(
                          mediaPath,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 11,
                      child: GestureDetector(
                        onTap: () => _removeMedia(index),
                        child: CircleAvatar(
                          backgroundColor: Constants.WHITE,
                          radius: 12,
                          child: Icon(
                            Icons.close,
                            color: Colors.black,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
        SizedBox(
          height: 10,
        ),
        if (mediaUrls.isNotEmpty) SizedBox(height: 5),
      ],
    );
  }
}