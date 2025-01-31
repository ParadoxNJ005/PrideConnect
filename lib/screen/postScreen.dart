import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:video_thumbnail/video_thumbnail.dart';

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
  void dispose(){
    super.dispose();
    _captionController.dispose();
  }

  void _showLimitWarningDialog(){
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


  // Pick images from gallery
  Future<void> _pickImagesFromGallery() async {
    // String useremail = returnUserId();
    // PageTracker.trackGalleryImages("SelectMediaPage", "Dont Know", useremail);

    if (mediaUrls.length >= maxMediaCount) {
      _showLimitWarningDialog();
      return;
    }

    // Request permission for gallery access
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


  // Pick video from gallery
  Future<void> _pickVideoFromGallery() async {
    // String useremail = returnUserId();
    // PageTracker.trackGalleryVideos("SelectMediaPage", "Dont Know", useremail);

    if (mediaUrls.length >= maxMediaCount) {
      _showLimitWarningDialog();
      return;
    }

    // Request permission for gallery access
    final permissionStatus = await Permission.photos.request();
    if (!permissionStatus.isGranted) {
      final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        setState(() {
          mediaUrls.add(File(video.path)); // Correct handling of File
        });
      }
    } else {
      print("Gallery permission denied");
    }
  }


  // Generate thumbnail for video
  Future<String?> _generateThumbnail(String videoPath) async {
    final String thumbnailPath = '${(await getTemporaryDirectory()).path}/thumbnail.png';
    final String? generatedThumbnail = await VideoThumbnail.thumbnailFile(
      video: videoPath,
      thumbnailPath: thumbnailPath,
      imageFormat: ImageFormat.PNG,
      maxWidth: 128,
      maxHeight: 128,
      quality: 75,
    );
    return generatedThumbnail;
  }


  // Remove image/video
  void _removeMedia(int index) {
    setState(() {
      mediaUrls.removeAt(index);
    });
  }

  void _navigateToAddPost() async {
    if (mediaUrls.isNotEmpty) {
      setState(() {
        _isLoading = true; // Start loading
      });

      // SellForm sellForm = SellForm(
      //   city: _CityController.text.toString(),
      //   state: _StateController.text.toString(),
      //   address: _locationController.text.toString(),
      //   orgName: _captionController.text.toString(),
      //   size: selectedScrapSize,
      //   images: [],
      //   remark: _RemarkController.text.toString(),
      //   latitude: _selectedLatitude,  // Example latitude
      //   longitude: _selectedLongitude, // Example longitude
      // );
      //
      // await APIs.sellProductImages(mediaUrls, sellForm); // Pass SellForm data
      // Dialogs.showSnackbar(context, "Upload Successfull");
      // setState(() {
      //   _isLoading = false; // Stop loading
      // });

    } else {
      Dialogs.showSnackbar(context, "Upload At least One Image/Video");
    }
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
        children:[
          Scaffold(
            backgroundColor: Constants.APPCOLOUR,
            appBar: AppBar(
              backgroundColor: Constants.APPCOLOUR,
              automaticallyImplyLeading: false,
              leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back_ios , color: Colors.black,)),
              centerTitle: false,
              elevation: 0.0,
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 26.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      const Text(
                        "Photos",
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      temp(),
                      const SizedBox(height: 25),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Remark",
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                          ),
                          const SizedBox(height: 5),
                          TextField(
                            maxLines: 2,
                            controller: _captionController,
                            decoration: InputDecoration(
                              hintText: "Add your remark here ",
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              hintStyle: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                                fontSize: 18.0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: Colors.black.withOpacity(0.6),
                                  width: 1.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: Colors.black.withOpacity(0.6),
                                  width: 1.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: Colors.black.withOpacity(0.6),
                                  width: 1.0,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
                            ),
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
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
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5), // Overlay color with transparency
              child: const Center(
                child: LogoAnimationWidget(), // Loading indicator
              ),
            ),
        ]
    );
  }
  Widget temp(){
    final size = MediaQuery.of(context).size;
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            DashedBorder(
              color:Colors.grey,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 180,
                width: double.infinity,
                alignment: Alignment.center,
                child: IconButton(icon:  Icon(Icons.image_search_rounded , color: Colors.grey.withOpacity(0.5) , size: 65,), onPressed: (){
                  _pickImageFromCamera();
                }, ),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: IconButton(
                icon: Icon(Icons.photo_library,
                    color: Colors.grey[700], size: 30),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          tileColor: Constants.APPCOLOUR,
                          leading: Icon(Icons.image , color: Colors.black,),
                          title: Text('Pick Image from Gallery' , style: TextStyle(color: Colors.black),),
                          onTap: _pickImagesFromGallery,
                        ),
                        ListTile(
                          tileColor: Constants.APPCOLOUR,
                          leading: Icon(Icons.video_library , color: Colors.black
                            ,),
                          title: Text('Pick Video from Gallery' , style: TextStyle(color: Colors.black),),
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
                    color: Colors.black),
              ),
            ),
          ),
          SizedBox(height: 26),
          Container(
            height: size.height * .25, // Fixed height
            child: GridView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 200 / 150, // Adjust aspect ratio to fit the new dimensions
              ),
              itemCount: mediaUrls.length,
              itemBuilder: (context, index) {
                final mediaPath = mediaUrls[index];

                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14.0),
                      child: Container(
                        width: 150, // Updated fixed width
                        height: 200, // Fixed height
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black.withOpacity(0.3), width: 1),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: mediaPath.path.endsWith('.mp4')
                            ? FutureBuilder<String?>(
                          future: _generateThumbnail(mediaPath.path),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                              return Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.file(
                                    File(snapshot.data!),
                                    width: 150, // Updated fixed width
                                    height: 200, // Fixed height
                                    fit: BoxFit.cover, // Crops to fill the fixed box
                                  ),
                                  Positioned(
                                    bottom: 8,
                                    right: 8,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.black54,
                                      radius: 12,
                                      child: Icon(
                                        Icons.play_arrow,
                                        color: Colors.black,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return const Center(
                                child: LogoAnimationWidget(), // Loading widget
                              );
                            }
                          },
                        )
                            : Image.file(
                          mediaPath,
                          // width: 150, // Updated fixed width
                          // height: 200, // Fixed height
                          fit: BoxFit.cover, // Crops to fill the fixed box
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0, // Top margin
                      right: 11, // Right margin relative to the card
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
        if(mediaUrls.isNotEmpty )
          SizedBox(height: 5),
      ],
    );
  }
}