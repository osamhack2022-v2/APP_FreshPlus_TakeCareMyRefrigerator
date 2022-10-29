import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../leader_tab/l_tab.dart';
import '/components/general/homepage_drawer.dart';
import '/components/general/homepage_gauge.dart';
import '/firebase/controller/main/user_ctrl.dart';
import '/firebase/controller/main/fridge_ctrl.dart';
import '../../user/u_page.dart';

class SortController extends GetxController {
  bool warningSort = false;
  void on() {
    warningSort = true;
  }

  void off() {
    warningSort = false;
  }
}

class ManagerPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final FridgeController fridgeCtrl = Get.arguments;
  final SortController sortCtrl = SortController();
  @override
  int score(int itemNum, int warningNum, int trashNum) {
    if (trashNum > 1)
      return 100 - (80 + trashNum);
    else if (warningNum > 1)
      return 100 - (40 + 30 * warningNum / itemNum).toInt();
    else
      return 80;
  }

  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          key: _formKey,
          appBar: AppBar(
              backgroundColor: Color(0xff7FB77E),
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
            color: Color(0xff7FB77E),
            child: Container(
                height: 56.0,
                child: Row(
                  children: [
                    SizedBox(width: 11.0),
                    SizedBox(width: 11.0),
                    IconButton(
                      iconSize: 18.0,
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.sort,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text(
                              '유저 정렬 순서 바꾸기',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                                color: Color(0xDE000000),
                              ),
                            ),
                            content: Text('경과한 식품의 개수나 경과\n기간을 기준으로 정렬할 수 있습니다',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w400,
                                  color: Color(0x99000000),
                                )),
                            actions: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Spacer(),
                                  Container(
                                    height: 36,
                                    width: 89,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          sortCtrl.off();
                                          Navigator.of(context).pop();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: sortCtrl.warningSort
                                              ? Color(0xff2C7B0C)
                                              : Colors.blue,
                                        ),
                                        child: Text(
                                          '물품개수',
                                          style: TextStyle(
                                            color: Color(0xffFFFFFF),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Roboto',
                                          ),
                                        )),
                                  ),
                                  Spacer(),
                                  Container(
                                    height: 36,
                                    width: 89,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          sortCtrl.on();
                                          Navigator.of(context).pop();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: sortCtrl.warningSort
                                              ? Colors.blue
                                              : Color(0xff2C7B0C),
                                        ),
                                        child: Text(
                                          '경과기간',
                                          style: TextStyle(
                                            color: Color(0xffFFFFFF),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Roboto',
                                          ),
                                        )),
                                  ),
                                  Spacer(),
                                ],
                              ),
                              SizedBox(height: 12),
                            ],
                          ),
                        );
                      },
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
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(24.0, 22.0, 0.0, 4.0),
                child: Row(children: [
                  HomepageGauge(score(
                      fridgeCtrl.fridge.itemNum,
                      fridgeCtrl.fridge.warningNum,
                      fridgeCtrl.fridge.trashNum)),
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
              Container(height: 1, color: Color(0xffdddddd)),
              Container(height: 1),
              Expanded(
                child: LTab(sortCtrl),
              ),
            ],
          ),
        ));
  }
}
