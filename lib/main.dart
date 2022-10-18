import 'package:helloworld/firebase/controller/main/item_add.dart';
import 'package:helloworld/firebase/controller/main/user_ctrl.dart';

import 'components/auth/auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'firebase/init.dart';

// import 'firebase/controller/auth/sign_in_ctrl.dart';
import 'firebase/controller/auth/sign_in_ctrl.dart';
import 'firebase/controller/auth/sign_up_ctrl.dart';
import 'firebase/controller/main/general/dto.dart';
import 'firebase/controller/main/fridge_add.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialize();
  // print(await signIn("test.io","testtest"));
  runApp(GetMaterialApp(
    home: Scaffold(body: Hello()),
  ));
}

class Hello extends StatelessWidget {
  const Hello({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
            onPressed: () async {
              print(await signIn("user@user.io", "useruser"));
            },
            child: Text("LogIn")),
        TextButton(
            onPressed: () async {
              FridgeAddController fridgeAdd = FridgeAddCtrl();
              await fridgeAdd.init();
              await fridgeAdd.add("1C1P");
            },
            child: Text("Add Fridge (Only Master)")),
        TextButton(
            onPressed: () async {
              ItemAddCtrl itemAdd = ItemAddCtrl();
              await itemAdd.init();
              await itemAdd
                  .add(ItemAddDTO("바나나우유", "drink", DateTime(2022, 10, 10)));
            },
            child: Text("Add Item")),
        TextButton(
            onPressed: () async {
              UserController uc = UserController();
              await uc.init(null, null);
              var box = await uc.getUserBox();
              print(box.uid);
              var item = await uc.getCategoryList("drink");
              print(item[0].itemName);
            },
            child: Text("Show Item")),
        TextButton(
            onPressed: () async {
              await signUp(
                  "user@user.io", "useruser", "김상병", "777AAA", "1C1P", "user");
            },
            child: Text("SignUpUser")),
      ],
    );
  }
}
