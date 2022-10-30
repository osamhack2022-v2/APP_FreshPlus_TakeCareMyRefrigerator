import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/firebase/controller/main/user_ctrl.dart';
import '/firebase/controller/main/general/dto.dart';
import 'dart:async';

class UTab extends StatefulWidget {
  _UTabState createState() => _UTabState();
}

class _UTabState extends State<UTab> with TickerProviderStateMixin {
  CollectionReference product =
      FirebaseFirestore.instance.collection('product');
  final UserController userCtrl = Get.arguments;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  late Future<List<ItemDTO>> future1;
  late Future<List<ItemDTO>> future2;
  late Future<List<ItemDTO>> future3;
  late Future<List<ItemDTO>> future4;
  int _leftDay(DateTime day, DateTime now) {
    final diff = day.difference(now);
    return diff.inDays;
  }

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
    future1 = userCtrl.getWarningTrashList();
    future2 = userCtrl.getLostItemList();
    future3 = userCtrl.getCategoryList("drink");
    future4 = userCtrl.getCategoryList("food");

    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {});
  }

  void refresh1() {
    setState(() {
      future1 = userCtrl.getWarningTrashList();
      future2 = userCtrl.getLostItemList();
      future3 = userCtrl.getCategoryList("drink");
      future4 = userCtrl.getCategoryList("food");
    });
  }

  Widget card(AsyncSnapshot<List<ItemDTO>> snapshot) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) {
          final ItemDTO item = snapshot.data![index];
          String imageAddress = "assets/item_image/" + item.itemCode + ".jpg";
          String state = "안전";
          Color color = Colors.green;
          int leftDay = _leftDay(item.dueDate, DateTime.now());
          String subtitle = "유통기한이 $leftDay일 남았습니다";
          switch (item.status) {
            case "trash":
              state = "위험";
              color = Colors.red;
              subtitle = "유통기한이 지났습니다. 빨리 버려주세요";
              break;
            case "warning":
              state = "주의";
              color = Colors.orange;
              break;
            case "lost":
              state = "분실";
              color = Colors.purple;
              subtitle = "제품이 분실되었습니다.";
              break;
            case "notIn":
              state = "미입고";
              color = Colors.grey;
              break;
            default:
              break;
          }
          return Card(
            margin: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
            child: ExpansionTile(
              key: Key(index.toString()), //attention
              leading: Image(image: AssetImage(imageAddress)),
              title: Text(item.itemName),
              subtitle: Text(subtitle),
              trailing: Text(
                state,
                style: TextStyle(
                  color: color,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Roboto',
                ),
              ),
              children: <Widget>[
                SizedBox(
                  height: 194,
                  width: 375,
                  child: Image(
                    image: AssetImage(imageAddress),
                    fit: BoxFit.scaleDown,
                  ),
                ),
                Text(
                  item.itemName +
                      "의 유통기한은" +
                      item.dueDate.toString() +
                      "까지입니다.",
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                    letterSpacing: 1.25,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 16, 14, 28),
                  child: Row(
                    children: [
                      Spacer(),
                      TextButton(
                          onPressed: () {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('물품삭제'),
                                content: const Text('물품을 삭제하시겠습니까?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () async {
                                      userCtrl.deleteItem(item.itemID);
                                      refresh1();
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Yes'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('No'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Text(
                            '물품삭제',
                            style: TextStyle(
                              color: Color(0xff2C7B0C),
                              fontSize: 14,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.25,
                            ),
                          )),
                      SizedBox(width: 14),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.transparent,
              indicatorWeight: 0.1,
              tabs: [
                Container(
                  height: 56,
                  alignment: Alignment.center,
                  child: Text(
                    '위험물품',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w300,
                      color: _tabController.index == 0
                          ? Color(0xff7fb77e)
                          : Colors.grey,
                    ),
                  ),
                ),
                Container(
                  height: 56,
                  alignment: Alignment.center,
                  child: Text(
                    '유실',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w300,
                      color: _tabController.index == 1
                          ? Color(0xff7fb77e)
                          : Colors.grey,
                    ),
                  ),
                ),
                Container(
                  height: 56,
                  alignment: Alignment.center,
                  child: Text(
                    '음료',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w300,
                      color: _tabController.index == 2
                          ? Color(0xff7fb77e)
                          : Colors.grey,
                    ),
                  ),
                ),
                Container(
                  height: 56,
                  alignment: Alignment.center,
                  child: Text(
                    '즉석식품',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w300,
                      color: _tabController.index == 3
                          ? Color(0xff7fb77e)
                          : Colors.grey,
                    ),
                  ),
                ),
              ],
              labelColor: Color(0xffC8DDC0),
              unselectedLabelColor: Colors.black,
            ),
          ),
          Container(height: 1),
          Container(height: 1, color: Color(0xffdddddd)),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  child: FutureBuilder(
                    future: future1,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<ItemDTO>> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.length > 0) {
                          snapshot.data!.sort((a, b) {
                            return a.dueDate.compareTo(b.dueDate);
                          });
                          return card(snapshot);
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
                    future: future2,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<ItemDTO>> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.length > 0) {
                          snapshot.data!.sort((a, b) {
                            return a.dueDate.compareTo(b.dueDate);
                          });
                          return card(snapshot);
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
                    future: future3,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<ItemDTO>> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.length > 0) {
                          snapshot.data!.sort((a, b) {
                            return a.dueDate.compareTo(b.dueDate);
                          });
                          return card(snapshot);
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
                    future: future4,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<ItemDTO>> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.length > 0) {
                          snapshot.data!.sort((a, b) {
                            return a.dueDate.compareTo(b.dueDate);
                          });
                          return card(snapshot);
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
