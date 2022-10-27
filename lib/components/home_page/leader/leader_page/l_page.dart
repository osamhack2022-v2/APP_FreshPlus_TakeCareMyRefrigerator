import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../leader_tab/l_tab.dart';
import '/components/general/homepage_drawer.dart';
import '/components/general/homepage_gauge.dart';
import 'package:get/get.dart';
import '/firebase/controller/main/user_ctrl.dart';
import '/firebase/controller/main/fridge_ctrl.dart';
import '../../user/u_page.dart';

class ManagerPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final FridgeController fridgeCtrl = Get.arguments;
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
                fridgeCtrl.fridgeID + " 냉장고", //User_Name Firebase에서 받아와야함
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w500,
                ),
              ),
              actions: <Widget>[
                IconButton(
                  iconSize: 16.0,
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.currency_exchange,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    var userCtrl = UserController();
                    await userCtrl.init(null, fridgeCtrl.fridge.manager);
                    Get.to(() => UPage(), arguments: userCtrl);
                  },
                ),
              ]),
          bottomNavigationBar: BottomAppBar(
            shape: CircularNotchedRectangle(),
            notchMargin: 8.0,
            color: Color(0xff2C7B0C),
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
                  ],
                )),
          ),
          drawer: Container(
            width: 302.0,
            child: HomepageDrawer(),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
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
                      Text("총 물품 : " +
                          fridgeCtrl.fridge.itemNum.toString() +
                          "개"),
                      Text("유통기한 임박 : " +
                          fridgeCtrl.fridge.warningNum.toString() +
                          "개"),
                      Text("유통기한 경과 : " +
                          fridgeCtrl.fridge.trashNum.toString() +
                          "개"),
                      Text("유실된 물품 : " +
                          fridgeCtrl.fridge.lostNum.toString() +
                          "개"),
                      Text("미등록 물품 : " +
                          fridgeCtrl.fridge.noHostNum.toString() +
                          "개"),
                    ],
                  )
                ]),
              ),
              Expanded(
                child: LTab(),
              ),
            ],
          ),
        ));
  }
}
