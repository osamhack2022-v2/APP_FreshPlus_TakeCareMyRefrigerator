import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:helloworld/firebase/controller/main/general/dto.dart';
import 'package:helloworld/firebase/controller/main/unit_ctrl.dart';
import '../master_tab/m_tab.dart';
import 'package:helloworld/components/general/homepage_drawer.dart';
import 'package:helloworld/components/general/homepage_gauge.dart';
import 'fridge_add.dart';

class MPage extends StatefulWidget {
  const MPage({Key? key}) : super(key: key);
  _MPageState createState() => _MPageState();
}

class _MPageState extends State<MPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isClcked = true;
  final UnitController unitCtrl = Get.arguments;
  late UnitDTO unit;
  @override
  Widget build(BuildContext context) {
    unit = unitCtrl.getUnit();
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          key: _formKey,
          appBar: AppBar(
            backgroundColor: Color(0xff2C7B0C),
            toolbarHeight: 56.0,
            title: Text(
              unit.unitID + "의 부대 냉장고", //User_Name Firebase에서 받아와야함
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontFamily: "Roboto",
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
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
                        _isClcked
                            ? Icons.notifications
                            : Icons.notifications_off,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _isClcked = !_isClcked;
                        });
                      },
                    ),
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
                            title: const Text(
                              '생활관 정렬 순서 바꾸기',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                                color: Color(0xDE000000),
                              ),
                            ),
                            content: const Text(
                                '경과한 식품의 개수나 경과\n기간을 기준으로 정렬할 수 있습니다',
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
                                          Navigator.of(context).pop();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Color(0xff2C7B0C),
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
                                          Navigator.of(context).pop();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Color(0xff2C7B0C),
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
                  ],
                )),
          ),
          drawer: Container(
            width: 302.0,
            child: HomepageDrawer(),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Get.to(() => FridgeAdd());
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
                      Text("총 물품 : " + unit.itemNum.toString() + "개"),
                      Text("유통기한 임박 : " + unit.warningNum.toString() + "개"),
                      Text("유통기한 경과 : " + unit.trashNum.toString() + "개"),
                      Text("유실된 물품 : " + unit.lostNum.toString() + "개"),
                      Text("미등록 물품 : " + unit.noHostNum.toString() + "개"),
                    ],
                  )
                ]),
              ),
              Expanded(
                child: MTab(),
              ),
            ],
          ),
        ));
  }
}
