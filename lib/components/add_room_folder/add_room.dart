// 생활관 추가 페이지 Floating button과 연결됨
import 'package:flutter/material.dart';
import 'package:helloworld/components/add_room_folder/addroom_form.dart';

class AddRoom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                    onPressed: () {},
                  ),
                ],
              )),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Align(
            alignment: Alignment.center,
            child: Icon(
              Icons.send,
              color: Colors.white,
              size: 25.0,
            ),
          ),
          backgroundColor: Color(0xffFFB200),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "생활관 추가",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff2C7B0C),
                  ),
                ),
                SizedBox(
                  height: 47,
                ),
                Text(
                  "아래 정보를 입력하신 후",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff212121),
                  ),
                ),
                Text(
                  "오른쪽 아래 전송버튼을 누르시면 됩니다",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff212121),
                  ),
                ),
                SizedBox(height: 12),
                AddRoomForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
