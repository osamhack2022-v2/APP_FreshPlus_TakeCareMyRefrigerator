import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/firebase/controller/main/unit_ctrl.dart';
import '/firebase/controller/main/general/dto.dart';

class MTab extends StatefulWidget {
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
            child: 
                Container(
                  child: FutureBuilder(
                    future: unitCtrl.getFridgeList(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<FridgeDTO>> snapshot) {
                      if (snapshot.hasData) {
                      
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
                                child: ListTile(
                                  leading: CircleAvatar(
                                      backgroundImage:
                                          AssetImage("assets/member.jpg")),
                                  title: Text(fridge.fridgeID),
                                  subtitle: Column(
                                    children: <Widget>[
                                      Text("유통기한 임박 제품 "+ fridge.warningNum.toString()+"개"),
                                      Text("유통기한 경과 제품 "+ fridge.trashNum.toString()+"개"),
                                    ],
                                  ),
                                  isThreeLine: true,
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
