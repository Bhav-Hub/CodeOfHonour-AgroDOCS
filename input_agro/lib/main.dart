import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ImagePickerDemo(),
    );
  }
}

class ImagePickerDemo extends StatefulWidget {
  @override
  _ImagePickerDemoState createState() => _ImagePickerDemoState();
}

class _ImagePickerDemoState extends State<ImagePickerDemo> {
  File? _image;

  Future<void> _shareImage() async {
    if (_image != null) {
      var request = http.MultipartRequest('POST', Uri.parse('http://192.168.0.148:8080/upload'));
      request.files.add(await http.MultipartFile.fromPath('image', _image!.path));

      var response = await request.send();
      if (response.statusCode == 200) {
        print('Image uploaded successfully');
      } else {
        print('Failed to upload image. Status code: ${response.statusCode}');
      }
    }
  }


  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }


  Future<void> _shareImageDrive() async {
    if (_image != null) {
      await FlutterShare.shareFile(
        title: 'Share Image',
        text: 'Check out this image',
        filePath: _image!.path,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Demo'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: _shareImageDrive,
          ),
        ],
      ),
      body: Container(
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     // image: AssetImage('assets/background_image.jpg'), // Replace with your actual image asset path
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _image == null ? Text('No image selected.') : Image.file(_image!),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => _getImage(ImageSource.camera),
                child: Text('Take a Picture'),
              ),
              ElevatedButton(
                onPressed: () => _getImage(ImageSource.gallery),
                child: Text('Pick an Image from Gallery'),
              ),
              ElevatedButton(
                onPressed: _shareImage, // Call the _shareImageWithServer method
                child: Text('Share Image with Server'),
              ),
              ElevatedButton(
                onPressed: _shareImageDrive,
                child: Text('Share Image'),
              ),
              GestureDetector(
                onTap: () {
                  const url = 'https://drive.google.com/drive/folders/17qfHKRH5ookWEExGeKQwrgc6s_Qb8EPb?usp=sharing';
                  launch(url); // Use the launch method to open the URL
                },
                child: Text(
                  'Visit Google Drive',
                  style: TextStyle(
                    decoration: TextDecoration.underline, // Underline the text
                    color: Colors.blue, // Change the text color to blue
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}