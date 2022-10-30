import 'package:FreshPlus/firebase/controller/main/general/dto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../user/u_tab.dart';
import '/components/general/homepage_drawer.dart';
import '/components/general/homepage_gauge.dart';
import '/components/item_add/item_add.dart';
import '/firebase/controller/main/user_ctrl.dart';
import '/firebase/controller/main/item_add.dart';

class UPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final UserController ctrl = Get.arguments;
  int score(int itemNum, int warningNum, int trashNum) {
    if (trashNum >= 1)
      return 100 - (80 + trashNum);
    else if (warningNum >= 1)
      return 100 - (40 + 30 * warningNum / itemNum).toInt();
    else
      return 80;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          key: _formKey,
          appBar: AppBar(
            backgroundColor: Color(0xff7FB77E),
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
            color: const Color(0xff7FB77E),
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
                      onPressed: () {
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  title: Text('지난알림'),
                                  content: Container(
                                    height: 1400,
                                    width: 600,
                                    child: Container(
                                      height: 150,
                                      child: FutureBuilder(
                                          future: ctrl.getMessages(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<List<MessageDTO>>
                                                  snapshot) {
                                            if (snapshot.hasData) {
                                              return ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      snapshot.data!.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final message = snapshot
                                                        .data![index].message;
                                                    return Card(
                                                      child: Text(message,
                                                          style: TextStyle(
                                                              fontSize: 30)),
                                                    );
                                                  });
                                            }
                                            return Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }),
                                    ),
                                  ),
                                  actions: <Widget>[
                                    Row(
                                      children: [
                                        Spacer(),
                                        SizedBox(
                                            width: 300,
                                            child: ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                              Color>(
                                                          Color(0xff2C7B0C)),
                                                ),
                                                onPressed: () => Get.back(),
                                                child: Text(
                                                  'Back',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'Roboto',
                                                    fontWeight: FontWeight.w400,
                                                    letterSpacing: 1.25,
                                                  ),
                                                ))),
                                        Spacer(),
                                      ],
                                    ),
                                    SizedBox(height: 10)
                                  ],
                                ));
                      },
                    ),
                    SizedBox(width: 11.0),
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
                  HomepageGauge(score(ctrl.userBox.itemNum,
                      ctrl.userBox.warningNum, ctrl.userBox.trashNum)),
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
              Container(height: 1, color: Color(0xffdddddd)),
              Container(height: 1),
              Expanded(
                child: UTab(),
              ),
            ],
          ),
        ));
  }
}
