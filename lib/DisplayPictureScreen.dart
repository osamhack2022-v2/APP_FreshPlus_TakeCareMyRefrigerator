import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:gallery_saver/gallery_saver.dart';

import 'main.dart';
import 'MainPage.dart';
import 'TakePictureScreen.dart';
import 'GetImageForGallery.dart';
import 'device_screen.dart';

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Center(
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 300,
              height: 500,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(File(imagePath)),//File Image를 삽입
                  fit: BoxFit.contain
                ),
              ),
            )
             FlatButton(
              child: 
              Text('집으로가자',style: TextStyle(fontSize: 24)),
              onPressed: () => Navigator.popUntil(context, ModalRoute.withName("/")),
              color: Colors.green,
              textColor: Colors.white,                    
             ),
            // Image.file(File(imagePath)),
          ],
        ),
      ),
      



    );
  }
}