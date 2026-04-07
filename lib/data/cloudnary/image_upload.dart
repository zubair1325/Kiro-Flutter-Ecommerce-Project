import 'dart:convert';
import 'dart:io';
import 'package:ecommerce/presentation/controller/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ImageUpload extends StatefulWidget {
  final String? imagePreset;
  bool? isUser;
  ImageUpload({super.key, required this.imagePreset, this.isUser = false});

  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    widget.imagePreset;
  }

  @override
  Widget build(BuildContext context) {
    // return IconButton(
    //   onPressed: () => uploadImage(),
    //   icon: Icon(Icons.photo_camera),
    // );
    return Center(
      child: Stack(
        children: [
          // 🔹 Profile Image
          CircleAvatar(
            radius: 55,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: user?.photoURL != null
                ? NetworkImage(user!.photoURL!)
                : null,
            child: user?.photoURL == null
                ? const Icon(Icons.person, size: 55, color: Colors.grey)
                : null,
          ),

          // 🔹 Edit Icon (Top Right)
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                uploadImage();
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.edit, size: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> uploadImage() async {
    print("------------------------");
    print(widget.isUser);
    final ImagePicker picker = ImagePicker();
    String? imageUrl;

    // 1. Pick an image from gallery
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // This is your local variable 'file'
      File file = File(image.path);

      try {
        final url = Uri.parse(
          'https://api.cloudinary.com/v1_1/dxaj5s787/upload',
        );

        final request = http.MultipartRequest('POST', url)
          ..fields['upload_preset'] = widget.imagePreset!
          ..files.add(
            // FIX: Change '_imageFile!.path' to 'file.path'
            await http.MultipartFile.fromPath('file', file.path),
          );

        final response = await request.send();

        if (response.statusCode == 200) {
          final responseData = await response.stream.toBytes();
          final responseString = String.fromCharCodes(responseData);
          final jsonMap = jsonDecode(responseString);

          setState(() {
            final url = jsonMap['url'];
            imageUrl = url; // Ensure _imageUrl is defined at the class level
          });
          widget.isUser!
              ? AuthController.userProfilePicture(imageUrl.toString())
              : null;
          print("Upload successful: $imageUrl");
        } else {
          print("Upload failed with status: ${response.statusCode}");
        }
      } catch (e) {
        print("Error during upload: $e");
      }
    }
  }
}
