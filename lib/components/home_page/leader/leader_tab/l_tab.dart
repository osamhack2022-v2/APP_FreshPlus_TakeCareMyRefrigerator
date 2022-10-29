import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/firebase/controller/main/fridge_ctrl.dart';
import '/firebase/controller/main/general/dto.dart';
import '/firebase/controller/main/user_ctrl.dart';
import '../../user/u_page.dart';
import '/firebase/repository/user_repository.dart';

import '../leader_page/l_page.dart';

class LTab extends StatefulWidget {
  SortController sortCtrl;
  LTab(this.sortCtrl);
  _LTabState createState() => _LTabState();
}

class _LTabState extends State<LTab>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  CollectionReference product =
      FirebaseFirestore.instance.collection('product');
  final FridgeController fridgeCtrl = Get.arguments;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final userRepo = UserRepository();
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

  @override
  bool get wantKeepAlive => true;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this, //vsync에 this 형태로 전달해야 애니메이션이 정상 처리됨
    );
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {});
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
            default:
              break;
          }
          return Card(
            margin: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
            child: ExpansionTile(
              key: Key(index.toString()), //attention
              leading: Image(image: AssetImage(imageAddress)),
              title: Text(item.itemName),
              subtitle: Text(item.dueDate.toString()),
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
                FutureBuilder(
                  future: userRepo.getUser(item.uid),
                  builder: (context, AsyncSnapshot<User> snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data!.fridgeID +
                          "소속 " +
                          snapshot.data!.userName);
                    }
                    return Text("이름을 불러오는 중입니다.");
                  },
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
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: Colors.transparent,
              indicatorWeight: 0.1,
              tabs: [
                Container(
                  height: 56,
                  alignment: Alignment.center,
                  child: Text(
                    '분대원',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
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
                    '위험물품',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
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
                    '유실',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
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
                    '미등록',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
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
                  child: FutureBuilder(
                    future: fridgeCtrl.getUserList(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<UserBoxDTO>> snapshot) {
                      if (snapshot.hasData) {
                        if (true) {
                          print(1);
                          snapshot.data!.sort(
                            (a, b) {
                              var res = a.trashNum.compareTo(b.trashNum);
                              if (res != 0)
                                return -1 * res;
                              else {
                                res = a.warningNum.compareTo(b.warningNum);
                                if (res != 0)
                                  return -1 * res;
                                else {
                                  res = a.itemNum.compareTo(b.itemNum);
                                  return -1 * res;
                                }
                              }
                            },
                          );
                        } else {
                          print(2);
                          snapshot.data!.sort(((a, b) {
                            return -1 * a.itemNum.compareTo(b.itemNum);
                          }));
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            var user = snapshot.data![index];
                            String subtitle = "  유통기한 임박제품 " +
                                user.warningNum.toString() +
                                "개\n  유통기한 경과제품 " +
                                user.trashNum.toString() +
                                "개";
                            return GestureDetector(
                              onTap: () async {
                                var userCtrl = UserController();
                                await userCtrl.init(
                                    fridgeCtrl.reqFridgeID, user.uid);
                                Get.to(() => UPage(), arguments: userCtrl);
                              },
                              child: Card(
                                margin: EdgeInsets.only(
                                    left: 8, right: 8, top: 2, bottom: 2),
                                child: ExpansionTile(
                                  leading: CircleAvatar(
                                      backgroundImage:
                                          AssetImage("assets/member.jpg")),
                                  title: Text(user.userName),
                                  subtitle: Text(
                                    subtitle,
                                  ),
                                  children: <Widget>[
                                    // SizedBox(
                                    //   width: double.infinity,
                                    //   child: Image(
                                    //     image: AssetImage("assets/ettest.jpg"),
                                    //     fit: BoxFit.fitWidth,
                                    //   ),
                                    // ),
                                    Container(
                                        child: Text(
                                          "  총 물품" +
                                              user.itemNum.toString() +
                                              "개\n" +
                                              subtitle,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey,
                                            letterSpacing: 1.25,
                                          ),
                                        ),
                                        alignment: Alignment.centerLeft),
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 16, 14, 10),
                                      child: Row(
                                        children: [
                                          Spacer(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
                Container(
                  child: FutureBuilder(
                    future: fridgeCtrl.getWarningTrashItem(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<ItemDTO>> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.length > 0) {
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
                  child: FutureBuilder(
                    future: fridgeCtrl.getStatusItemList("lost"),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<ItemDTO>> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.length > 0) {
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
                  child: FutureBuilder(
                    future: fridgeCtrl.getNoHostItemList(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<ItemDTO>> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.length > 0) {
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
