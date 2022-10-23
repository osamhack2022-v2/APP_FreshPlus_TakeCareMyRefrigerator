import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../user/u_tab.dart';
import 'package:helloworld/components/general/homepage_drawer.dart';
import 'package:helloworld/components/general/homepage_gauge.dart';
import '/components/item_add/item_add.dart';
import '/firebase/controller/main/user_ctrl.dart';
import '/firebase/controller/main/general/dto.dart';
import '/firebase/controller/main/item_add.dart';

class UPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final UserController ctrl = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          key: _formKey,
          appBar: AppBar(
            backgroundColor: Color(0xff2C7B0C),
            toolbarHeight: 56.0,
            title: Text(
              ctrl.userName + "의 냉장고", //User_Name Firebase에서 받아와야함
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontFamily: "Roboto",
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 8.0,
            color: const Color(0xff2C7B0C),
            child: Container(
                height: 56.0,
                child: Row(
                  children: [
                    SizedBox(width: 11.0),
                    IconButton(
                      iconSize: 16.0,
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.notifications,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                    SizedBox(width: 11.0),
                    IconButton(
                      iconSize: 18.0,
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.sort,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                    AbsorbPointer(
                        absorbing: Navigator.canPop(context) == false,
                        child: IconButton(
                          iconSize: 18.0,
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Get.back();
                          },
                        ))
                  ],
                )),
          ),
          drawer: Container(
            width: 302.0,
            child: HomepageDrawer(),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              var controller = ItemAddController();
              await controller.init();
              Get.to(() => OcrScan(), arguments: controller);
            },
            child: Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 25.0,
              ),
            ),
            backgroundColor: Color(0xffFFB200),
          ),
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(24.0, 22.0, 0.0, 4.0),
                child: Row(children: [
                  HomepageGauge(),
                  SizedBox(width: 8.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("총 물품 : " + ctrl.userBox.itemNum.toString() + "개"),
                      Text("유통기한 임박 : " +
                          ctrl.userBox.warningNum.toString() +
                          "개"),
                      Text("유통기한 경과 : " +
                          ctrl.userBox.trashNum.toString() +
                          "개"),
                    ],
                  )
                ]),
              ),
              Expanded(
                child: UTab(),
              ),
            ],
          ),
        ));
  }
}
