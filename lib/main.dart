import 'package:flutter/material.dart';
import 'components/bluetooth_list.dart';
import 'firebase/init.dart';
import 'package:get/get.dart';
import '/firebase/dto.dart';

String unitCode = "777AAA";
String fridgeCode = "1C1P";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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


class StartForm extends StatelessWidget {
  StartForm({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        const Text("부대코드"),
        Text(unitCode),
        const Text("냉장고코드"),
        Text(fridgeCode),
        ElevatedButton(
            onPressed: () {
              FridgeInfo fridgeInfo =
                  FridgeInfo(unitCode, fridgeCode);
              Get.to(() => MyHomePage(title:"블루투스 연결"), arguments: fridgeInfo);
            },
            child: const Text("실행"))
      ],
    ));
  }
}
