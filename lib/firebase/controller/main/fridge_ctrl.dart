import 'package:helloworld/firebase/repository/item_repository.dart';

import 'main_ctrl.dart';
import 'general/dto.dart';
import '/firebase/repository/user_box_repository.dart';
import '/firebase/repository/user_repository.dart';
import '/firebase/repository/fridge_repository.dart';
import '../ctrl_exception.dart';

class FridgeController {
  late String uid;
  late String unitID;
  late String fridgeID;
  late String userType;

  //Requesting Pages
  late String reqFridgeID;
  late Fridge fridge;
  late FridgeRepository fridgeRepo;
  late UserBoxRepository userBoxRepo;
  init(String? reqFridgeID) async {
    var user = await getLogInUser();
    uid = user.uid;
    unitID = user.unitID;
    fridgeID = user.fridgeID;
    switch (user.type) {
      case (UserType.master):
        userType = "master";
        if (reqFridgeID == null) {
          throw CtrlException('null-parameter');
        }
        this.reqFridgeID = reqFridgeID!;
        break;

      case (UserType.manager):
        userType = "manager";
        this.reqFridgeID = fridgeID;
        break;

      default:
        throw CtrlException('user-ban');
    }
    fridgeRepo = FridgeRepository(unitID);
    fridgeRepo.init();
    userBoxRepo = UserBoxRepository(unitID, reqFridgeID!);
    userBoxRepo.init();
    try {
      fridge = await fridgeRepo.getFridge(this.reqFridgeID);
    } on FridgeRepositoryException catch (e) {
      throw CtrlException(e.code);
    }
  }

  FridgeDTO getFridge() {
    return FridgeDTO(fridge.fridgeID, fridge.itemNum, fridge.manager,
        fridge.warningNum, fridge.trashNum, fridge.lostNum, fridge.noHostNum);
  }

  Future<List<UserBoxDTO>> getUserList() async {
    List<UserBoxDTO> list = [];
    fridge.users.forEach((value) async {
      var userBox;
      try {
        userBox = await userBoxRepo.getUserBox(fridge.manager);
      } on UserBoxRepositoryException catch (e) {
        CtrlException(e.code);
      }
      list.add(UserBoxDTO(userBox.uid, userBox.itemNum, userBox.warningNum,
          userBox.trashNum, userBox.lostNum));
    });
    return list;
  }

  Future<List<ItemDTO>> getStatusItemList(String status) async {
    List<ItemDTO> list = [];
    await () async{fridge.users.forEach((value) async {
      var itemList;
      try {
        itemList = await userBoxRepo.getItemsQuery(value, "status", status);
        itemList.forEach((value) {
          var type;
          switch (value.type) {
            case (ItemType.drink):
              type = "drink";
              break;
            case (ItemType.food):
              type = "food";
              break;
          }
          list.add(
              ItemDTO(value.itemID, value.itemName, value.uid, status, type));
        });
      } on UserBoxRepositoryException catch (e) {
        CtrlException(e.code);
      }
    });};
    return list;
    //users에 manager 포함되게 변경 필요
  }

  Future<List<ItemDTO>> getNoHostItemList() async {
    List<ItemDTO> list = [];
    try {
      var itemList =
          await userBoxRepo.getItemsQuery("NoHost", "status", "noHost");
      itemList.forEach((value) {
        var type;
        switch (value.type) {
          case (ItemType.drink):
            type = "drink";
            break;
          case (ItemType.food):
            type = "food";
            break;
        }
        list.add(
            ItemDTO(value.itemID, value.itemName, value.uid, "NoHost", type));
      });
    } on UserBoxRepositoryException catch (e) {
      CtrlException(e.code);
    }
    return list;
  }
}
