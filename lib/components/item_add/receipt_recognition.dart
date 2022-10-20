import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';

class ReceiptRecognition extends StatefulWidget {
  @override
  _ReceiptRecognitionState createState() => _ReceiptRecognitionState();
}

class _ReceiptRecognitionState extends State<ReceiptRecognition> {
  int OCR_CAM = FlutterMobileVision.CAMERA_BACK;
  String word = "TEXT";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 40),
          Center(
            child: RaisedButton(
              onPressed: _read,
              color: Color(0xff2C7B0C),
              child: Text(
                '영수증 인식',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Null> _read() async {
    List<OcrText> words = [];
    try {
      words = await FlutterMobileVision.read(
        camera: OCR_CAM,
        waitTap: true,
      );

      setState(() {
        word = words[0].value;
      });
    } on Exception {
      words.add(OcrText('Unable to recognize the word'));
    }
  }
}
