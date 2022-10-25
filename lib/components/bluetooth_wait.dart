import 'dart:async';

import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:helloworld/components/camera_view.dart';
import 'package:get/get.dart';
import 'package:helloworld/components/object_detector.dart';
import 'package:camera/camera.dart';

class BlueWait extends StatelessWidget {
  const BlueWait({super.key});

  Future<void> timer() async{
    Timer(Duration(seconds:5), ()async{
      var cams = await availableCameras();
      Get.off(()=>ObjectDetectorView(),arguments:cams);
    });
  }

  @override
  Widget build(BuildContext context) {
    timer();
    return Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff2C7B0C),
            toolbarHeight: 56.0,
            title: const Text(
              "Fresh Plus 냉장고 앱",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontFamily: "Roboto",
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          body: Center(child: Text("문열림 대기중"),));
  }
}