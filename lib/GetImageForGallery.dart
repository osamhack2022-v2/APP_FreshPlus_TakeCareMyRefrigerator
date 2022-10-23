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
import 'DisplayPictureScreen.dart';
import 'device_screen.dart';

LoadImageFromGalleryState pageState;

class LoadImageFromGallery extends StatefulWidget {
  @override
  LoadImageFromGalleryState createState() {
    pageState = LoadImageFromGalleryState();
    return pageState;
  }
}

class LoadImageFromGalleryState extends State<LoadImageFromGallery> {
  File _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Load Image From Gallery")),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(10),
              width: 300,
              height: 300,
              child: (_image != null) ? Image.file(_image) : Placeholder(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Text("Gallery"),
                  onPressed: () {
                    getImage(ImageSource.gallery);
                  },
                ),
                RaisedButton(
                  color: Colors.orange,
                  textColor: Colors.white,
                  child: Text("Camera"),
                  onPressed: () {
                    getImage(ImageSource.camera);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void getImage(ImageSource source) async {
    print("getImageFromGallery");
    var image = await ImagePicker.pickImage(source: source);

    setState(() {
      _image = image;
    });
  }
}