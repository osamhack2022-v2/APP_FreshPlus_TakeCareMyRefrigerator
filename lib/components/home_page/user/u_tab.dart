import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/firebase/controller/main/user_ctrl.dart';
import '/firebase/controller/main/general/dto.dart';

class UTab extends StatefulWidget {
  _UTabState createState() => _UTabState();
}

class _UTabState extends State<UTab> with TickerProviderStateMixin {
  CollectionReference product =
      FirebaseFirestore.instance.collection('product');
  final UserController userCtrl = Get.arguments;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  Future<void> _update(DocumentSnapshot documentSnapshot) async {
    nameController.text = documentSnapshot['name'];
    dateController.text = documentSnapshot['date'];

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          child: Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: dateController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: 'date'),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    final String name = nameController.text;
                    final String date = dateController.text;
                    await product
                        .doc(documentSnapshot.id)
                        .update({"name": name, "date": date});
                    nameController.text = "";
                    dateController.text = "";
                    Navigator.of(context).pop();
                  },
                  child: Text('Update'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      length: 4,
      vsync: this, //vsync에 this 형태로 전달해야 애니메이션이 정상 처리됨
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            child: TabBar(
              tabs: [
                Container(
                  color: Color(0xff2C7B0C),
                  height: 56,
                  alignment: Alignment.center,
                  child: Text(
                    '위험물품',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  color: Color(0xff2C7B0C),
                  height: 56,
                  alignment: Alignment.center,
                  child: Text(
                    '유실',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  color: Color(0xff2C7B0C),
                  height: 56,
                  alignment: Alignment.center,
                  child: Text(
                    '음료',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  color: Color(0xff2C7B0C),
                  height: 56,
                  alignment: Alignment.center,
                  child: Text(
                    '즉석식품',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
              labelColor: Color(0xffC8DDC0),
              unselectedLabelColor: Colors.black,
              controller: _tabController,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  child: FutureBuilder(
                    future: userCtrl.getWarningItemList(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<ItemDTO>> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.length > 0) {
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                final ItemDTO item = snapshot.data![index];
                                String imageAddress =
                                    "assets/" + item.itemCode + ".jpg";
                                String state = "안전";
                                switch (item.status) {
                                  case "trash":
                                    state = "위험";
                                    break;
                                  case "warning":
                                    state = "위험";
                                    break;
                                  case "lost":
                                    state = "분실";
                                    break;
                                  default:
                                    break;
                                }
                                int leftDay = 0;
                                return Card(
                                  margin: EdgeInsets.only(
                                      left: 8, right: 8, top: 2, bottom: 2),
                                  child: ListTile(
                                    leading:
                                        Image(image: AssetImage(imageAddress)),
                                    title: Text(item.itemName),
                                    subtitle: Text("유통기한이 $leftDay일 남았습니다."),
                                    trailing: Text(
                                      state,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                    isThreeLine: true,
                                  ),
                                );
                              });
                        } else {
                          return Center(child: Text("아이템이 없습니다"));
                        }
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  child: FutureBuilder(
                    future: userCtrl.getWarningItemList(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<ItemDTO>> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.length > 0) {
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                final ItemDTO item = snapshot.data![index];
                                String imageAddress =
                                    "assets/" + item.itemCode + ".jpg";
                                String state = "안전";
                                switch (item.status) {
                                  case "trash":
                                    state = "위험";
                                    break;
                                  case "warning":
                                    state = "위험";
                                    break;
                                  case "lost":
                                    state = "분실";
                                    break;
                                  default:
                                    break;
                                }
                                int leftDay = 0;
                                return Card(
                                  margin: EdgeInsets.only(
                                      left: 8, right: 8, top: 2, bottom: 2),
                                  child: ListTile(
                                    leading:
                                        Image(image: AssetImage(imageAddress)),
                                    title: Text(item.itemName),
                                    subtitle: Text("유통기한이 $leftDay일 남았습니다."),
                                    trailing: Text(
                                      state,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                    isThreeLine: true,
                                  ),
                                );
                              });
                        } else {
                          return Center(child: Text("아이템이 없습니다"));
                        }
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  child: FutureBuilder(
                    future: userCtrl.getCategoryList("drink"),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<ItemDTO>> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.length > 0) {
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                final ItemDTO item = snapshot.data![index];
                                String imageAddress =
                                    "assets/" + item.itemCode + ".jpg";
                                String state = "안전";
                                switch (item.status) {
                                  case "trash":
                                    state = "위험";
                                    break;
                                  case "warning":
                                    state = "위험";
                                    break;
                                  case "lost":
                                    state = "분실";
                                    break;
                                  default:
                                    break;
                                }
                                int leftDay = 0;
                                return Card(
                                  margin: EdgeInsets.only(
                                      left: 8, right: 8, top: 2, bottom: 2),
                                  child: ListTile(
                                    leading:
                                        Image(image: AssetImage(imageAddress)),
                                    title: Text(item.itemName),
                                    subtitle: Text("유통기한이 $leftDay일 남았습니다."),
                                    trailing: Text(
                                      state,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                    isThreeLine: true,
                                  ),
                                );
                              });
                        } else {
                          return Center(child: Text("아이템이 없습니다"));
                        }
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  child: FutureBuilder(
                    future: userCtrl.getCategoryList("food"),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<ItemDTO>> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.length > 0) {
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                final ItemDTO item = snapshot.data![index];
                                String imageAddress =
                                    "assets/" + item.itemCode + ".jpg";
                                String state = "안전";
                                switch (item.status) {
                                  case "trash":
                                    state = "위험";
                                    break;
                                  case "warning":
                                    state = "위험";
                                    break;
                                  case "lost":
                                    state = "분실";
                                    break;
                                  default:
                                    break;
                                }
                                int leftDay = 0;
                                return Card(
                                  margin: EdgeInsets.only(
                                      left: 8, right: 8, top: 2, bottom: 2),
                                  child: ListTile(
                                    leading:
                                        Image(image: AssetImage(imageAddress)),
                                    title: Text(item.itemName),
                                    subtitle: Text("유통기한이 $leftDay일 남았습니다."),
                                    trailing: Text(
                                      state,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                    isThreeLine: true,
                                  ),
                                );
                              });
                        } else {
                          return Center(child: Text("아이템이 없습니다"));
                        }
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
