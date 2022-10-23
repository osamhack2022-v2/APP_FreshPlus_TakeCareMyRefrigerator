import 'package:flutter/material.dart';
import 'package:sub_app/components/bluetooth.dart';
import 'firebase/init.dart';
import 'package:get/get.dart';
import '/firebase/dto.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized;
  await initialize();
  runApp(GetMaterialApp(
      home: Scaffold(
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
          body: StartForm())));
}

class UnitCodeController extends GetxController {
  var name = "".obs;
  void change(String newName) {
    name = newName.obs;
  }
}

class FridgeCodeController extends GetxController {
  var name = "".obs;
  void change(String newName) {
    name = newName.obs;
  }
}

class StartForm extends StatelessWidget {
  StartForm({super.key});
  UnitCodeController unit = UnitCodeController();
  FridgeCodeController fridge = FridgeCodeController();
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        const Text("부대코드"),
        TextField(
          onChanged: (value) => unit.change(value),
        ),
        const Text("냉장고코드"),
        TextField(
          onChanged: (value) => fridge.change(value),
        ),
        ElevatedButton(
            onPressed: () {
              FridgeInfo fridgeInfo =
                  FridgeInfo(unit.name.value, fridge.name.value);
              Get.to(() => MyHomePage(title:"블루투스 연결"), arguments: fridgeInfo);
            },
            child: const Text("실행"))
      ],
    ));
  }
}
