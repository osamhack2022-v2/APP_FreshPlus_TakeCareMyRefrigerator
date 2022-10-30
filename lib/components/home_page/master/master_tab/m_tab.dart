import 'package:FreshPlus/components/home_page/leader/leader_page/l_page.dart';
import 'package:FreshPlus/firebase/controller/main/fridge_ctrl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/firebase/controller/main/unit_ctrl.dart';
import '/firebase/controller/main/general/dto.dart';
import '/firebase/repository/user_repository.dart';

class MTab extends StatefulWidget {
  SortController sortCtrl;
  MTab(this.sortCtrl);
  _MTabState createState() => _MTabState();
}

class _MTabState extends State<MTab>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  CollectionReference product =
      FirebaseFirestore.instance.collection('product');
  final UnitController unitCtrl = Get.arguments;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController fridgeIDController = TextEditingController();
  final userRepo = UserRepository();

  Future<void> _update(DocumentSnapshot documentSnapshot) async {
    nameController.text = documentSnapshot['name'];
    dateController.text = documentSnapshot['date'];
    numberController.text = documentSnapshot['number'];

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
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _tabController = TabController(
      length: 3,
      vsync: this, //vsync에 this 형태로 전달해야 애니메이션이 정상 처리됨
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: FutureBuilder(
                future: unitCtrl.getFridgeList(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<FridgeDTO>> snapshot) {
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
                        var fridge = snapshot.data![index];
                        return GestureDetector(
                            //onTap: () => Get.to(),
                            child: Card(
                              margin: EdgeInsets.only(
                                  left: 8, right: 8, top: 2, bottom: 2),
                              child: ExpansionTile(
                                leading: CircleAvatar(
                                    backgroundImage:
                                        AssetImage("assets/member.jpg")),
                                title: Text(fridge.fridgeID),
                                subtitle: Text("유통기한 임박제품" +
                                    fridge.warningNum.toString() +
                                    "개\n유통기한 경과제품" +
                                    fridge.trashNum.toString() +
                                    "개"),
                                children: <Widget>[
                                  SizedBox(
                                    width: double.infinity,
                                    // child: Image(
                                    //   image: AssetImage("assets/ettest.jpg"),
                                    //   fit: BoxFit.fitWidth,
                                    // ),
                                  ),
                                  Container(
                                      child: Text(
                                        "  제품 수 " +
                                            fridge.itemNum.toString() +
                                            "\n  분대장 " +
                                            fridge.managerName +
                                            "\n  유통기한 임박제품 " +
                                            fridge.warningNum.toString() +
                                            "\n  유통기한 경과제품 " +
                                            fridge.trashNum.toString(),
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
                                    padding: EdgeInsets.fromLTRB(0, 16, 14, 28),
                                    child: Row(
                                      children: [
                                        Spacer(),
                                        TextButton(
                                            onPressed: () {
                                              showDialog<String>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        AlertDialog(
                                                  title: const Text('생활관삭제'),
                                                  content: const Text(
                                                      '생활관을 삭제하시겠습니까?'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        //_signOut();
                                                        //Get.to(LoginPage());
                                                      },
                                                      child: const Text('Yes'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(),
                                                      child: const Text('No'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            child: Text(
                                              '생활관삭제',
                                              style: TextStyle(
                                                color: Color(0xff2C7B0C),
                                                fontSize: 14,
                                                fontFamily: 'Roboto',
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 1.25,
                                              ),
                                            )),
                                        SizedBox(width: 14),
                                        TextButton(
                                            onPressed: () {
                                              showDialog<String>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        AlertDialog(
                                                  title: const Text('분대장변경'),
                                                  content: const Text(
                                                      '분대장을 변경하시겠습니까?'),
                                                  actionsAlignment:
                                                      MainAxisAlignment.center,
                                                  actions: <Widget>[
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              12, 0, 12, 12),
                                                      child: SizedBox(
                                                        width: double.infinity,
                                                        height: 36,
                                                        child: ElevatedButton(
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all<Color>(
                                                                        Color(
                                                                            0xff2C7B0C)),
                                                          ),
                                                          onPressed: () {},
                                                          child:
                                                              const Text('확인'),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                            child: Text(
                                              '분대장변경',
                                              style: TextStyle(
                                                color: Color(0xff2C7B0C),
                                                fontSize: 14,
                                                fontFamily: 'Roboto',
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 1.25,
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () async {
                              var fridgeCtrl = FridgeController();
                              await fridgeCtrl.init(fridge.fridgeID);
                              Get.to(() => ManagerPage(),
                                  arguments: fridgeCtrl);
                            });
                      },
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
  /*
  factory _MTabState.fromDocument(DocumentSnapshot doc) {
    return _MTabState(
        name: doc['name'], date: doc['date'], number: doc['number']);
  }
  */
}
