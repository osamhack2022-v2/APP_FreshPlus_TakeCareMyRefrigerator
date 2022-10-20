//아이템 추가하는 창

import 'package:flutter/material.dart';
import '../barcode_recognition.dart';
import '../receipt_recognition.dart';



class OcrScan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DefaultTabController(
          length: 3,
          child: Scaffold(
            bottomNavigationBar: BottomAppBar(
              shape: CircularNotchedRectangle(),
              notchMargin: 8.0,
              color: Color(0xff2C7B0C),
              child: Container(
                  height: 56.0,
                  child: Row(
                    children: [
                      SizedBox(width: 25.0),
                      IconButton(
                        iconSize: 18.0,
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.menu,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                      SizedBox(width: 11.0),
                      IconButton(
                        iconSize: 16.0,
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                      SizedBox(width: 11.0),
                      IconButton(
                        iconSize: 18.0,
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.home,
                          color: Colors.white,
                        ),
                        onPressed: () {
                        },
                      ),
                    ],
                  )),
            ),
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
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endDocked,
            body: Column(
              children: <Widget>[
                Container(
                  color: Color(0xff2C7B0C),
                  child: TabBar(
                    tabs: [
                      Tab(text: '영수증 인식'),
                      Tab(text: '바코드 인식'),
                      Tab(text: '직접입력'),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      Center(
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            Text(
                              "버튼을 눌러주세요!",
                            ),
                            Text(
                              "영수증이 자동으로 인식됩니다",
                            ),
                            ReceiptRecognition(),
                          ],
                        ),
                      ),
                      Center(
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            Text(
                              "버튼을 눌러주세요!",
                            ),
                            Text(
                              "바코드가 자동으로 인식 됩니다",
                            ),
                            Barcodescanner(),
                            
                          ],
                        ),
                      ),
                      Center(
                        child: EnterItem(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
