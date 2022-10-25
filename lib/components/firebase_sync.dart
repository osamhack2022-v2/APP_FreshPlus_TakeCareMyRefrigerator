import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import '/firebase/repository/user_repository.dart';
import '/firebase/repository/fridge_repository.dart';
import '/firebase/repository/user_box_repository.dart';
import '/firebase/repository/item_repository.dart';
import '../main.dart';
import 'package:get/get.dart';
import '/firebase/init.dart';
List<String> name_list = ['activia','appleade','bananamilk','beanmilk',
  'berrymilk','cheese','chicken','egg','idh','picnic'];

class FirebaseSync extends StatelessWidget {
  FirebaseSync({super.key});
  HashMap<String,int> map = Get.arguments;
  @override
  Widget build(BuildContext context) {
    var keys = map.keys.toList();
    _backProcess();
    return Scaffold(appBar: AppBar(
            backgroundColor: Color(0xff2C7B0C),
            toolbarHeight: 56.0,
            title: const Text(
              "Fresh Plus 냉장고 앱",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontFamily: "Roboto",
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          body:ListView.builder(itemCount : keys.length,
            itemBuilder: (context,index){
              return Center(child: Text(keys[index]+"가 "+map[keys[index]].toString()+"개 인식되었습니다.",));
            }));
  }

  Future<void> _backProcess() async {
    await initialize();
    await UserRepository().requestLogIn("admin@admin.io", "adminadmin");
    var fireList = await _firebaseNumList(unitCode,fridgeCode);
    var margin = calMargin(name_list,map,fireList);
    await updateState(unitCode,fridgeCode,name_list,margin);
    await UserRepository().requestLogOut();
    Get.back();
    
  }
  List<int> calMargin(List<String> nameList,
    HashMap<String,int> detectList, HashMap<String,int> fireList){
    var margin = List.generate(nameList.length,(int index)=>0);
    for(int i=0; i<margin.length;i++){
      int detect = 0;
      if(detectList.containsKey(nameList[i])){
        detect = detectList[nameList[i]]!;
      }
      int fire = 0;
      if(fireList.containsKey(nameList[i])){
        fire = fireList[nameList[i]]!;
      }
      margin[i]=detect-fire;
    }
    return margin;
  }

  Future<HashMap<String,int>> _firebaseNumList(String unitID, String fridgeID) async {
    var fridgeRepo = FridgeRepository(unitID);
    fridgeRepo.init();
    var userBoxRepo = UserBoxRepository(unitID,fridgeID);
    userBoxRepo.init();
    var users =(await fridgeRepo.getFridge(fridgeID)).users;
    HashMap<String,int> map = HashMap();
    users.forEach((user) async {
      var items =(await userBoxRepo.getUserBox(user)).items;
      var itemRepo = ItemRepository(unitID,fridgeID,user);
      itemRepo.init();
      items.forEach((item)async{
        var label =(await itemRepo.getItem(item)).itemName;
        if(map.containsKey(label)==true){
          map[label] = map[label]!+1;
        }
        else{
          map[label] = 0;
        }
      });
    });
    return map;
  }
  Future<void> updateState(String unitID, String fridgeID, List<String> nameList,List<int> margin)async{
    var uid ="YRoR5dZ0Xae90pW4Juykucd5l8v2";
    var itemRepo = ItemRepository(unitID,fridgeID,uid);
    itemRepo.init();
    for(int i =0;i<margin.length;i++){
      if(margin[i]>0){
        await itemRepo.addRealItems(nameList[i],margin[i]);
      }
      else if(margin[i]<0){
        //for all user
        //querySearch
        //
        await itemRepo.deleteRealItems(nameList[i],margin[i]);
      }
    }


  }
}