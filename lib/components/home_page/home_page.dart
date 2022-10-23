import 'dart:async';
import 'package:flutter/material.dart';
import 'package:helloworld/firebase/controller/main/general/dto.dart';
import '../general/homepage_logo.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '/firebase/controller/main/main_ctrl.dart';
import 'user/u_page.dart';
import 'master/master_page/m_page.dart';
import 'leader/leader_page/l_page.dart';
import '/firebase/controller/main/user_ctrl.dart';
import '/firebase/controller/main/fridge_ctrl.dart';
import '/firebase/controller/main/unit_ctrl.dart';

class HomePage extends StatelessWidget {
  @override
  HomePage({super.key}) {
    sendToPage();
  }
  late Timer timer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.2), BlendMode.dstATop),
                  image: const AssetImage("assets/splash_background.jpg")),
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 30.0),
              HomepageLogo(),
              const SizedBox(height: 221.0),
              const SpinKitFadingCircle(
                color: Color(0xff2C7B0C),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> sendToPage() async {
    var user = await getLogInUser();
    switch (user.type) {
      case ("manager"):
      print(1);
        var fridgeCtrl = FridgeController();
        await fridgeCtrl.init(null);
        Get.offAll(() => ManagerPage(), arguments: fridgeCtrl);
        break;
      case ("master"):
        var unitCtrl = UnitController();
        await unitCtrl.init();
        Get.offAll(() => const MPage(),arguments:unitCtrl);
        break;
      default:
        var userCtrl = UserController();
        await userCtrl.init(null, null);
        Get.offAll(() => UPage(), arguments: userCtrl);

        break;
    }
  }
}
