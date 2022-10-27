import '/firebase/repository/item_repository.dart';

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
    print(user.type);
    switch (user.type) {
      case ("master"):
        userType = "master";
        if (reqFridgeID == null) {
          throw CtrlException('null-parameter');
        }
        this.reqFridgeID = reqFridgeID;
        break;

      case ("manager"):
        userType = "manager";
        this.reqFridgeID = fridgeID;
        break;

      default:
        throw CtrlException('user-ban');
    }
    fridgeRepo = FridgeRepository(unitID);
    fridgeRepo.init();
    userBoxRepo = UserBoxRepository(unitID, this.reqFridgeID);
    userBoxRepo.init();
    await _checkStatus();
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
        userBox = await userBoxRepo.getUserBox(value);
      } on UserBoxRepositoryException catch (e) {
        CtrlException(e.code);
      }
      list.add(UserBoxDTO(userBox.uid, userBox.itemNum, userBox.warningNum,
          userBox.trashNum, userBox.lostNum,userBox.notInNum));
    });
    return list;
  }

  Future<List<ItemDTO>> getStatusItemList(String status) async {
    List<ItemDTO> list = [];
    await () async {
      fridge.users.forEach((value) async {
        List<Item> itemList;
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
            list.add(ItemDTO(value.itemID, value.itemCode, value.itemName,
                value.uid, status, type, value.dueDate));
          });
        } on UserBoxRepositoryException catch (e) {
          CtrlException(e.code);
        }
      });
    };
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
        list.add(ItemDTO(value.itemID, value.itemName, value.itemCode,
            value.uid, "NoHost", type, value.dueDate));
      });
    } on UserBoxRepositoryException catch (e) {
      CtrlException(e.code);
    }
    return list;
  }

  Future<void> _checkStatus() async {
    var fridge = await fridgeRepo.getFridge(fridgeID);
    bool changeLog = false;
    if (_sameDay(fridge.last, DateTime.now()) == false) {
      print("check Started");
      var userlist = fridge.users;
      userlist.add(fridge.manager);
      for (var uid in userlist) {
        print(uid);
        var user = await userBoxRepo.getUserBox(uid);
        var itemRepo = ItemRepository(unitID, fridgeID, uid);
        itemRepo.init();
        if (_sameDay(user.last, DateTime.now()) == false) {
          changeLog = await itemRepo.checkDate();
        }
        await userBoxRepo.updateUserStats(uid);
        await userBoxRepo.editLast(uid);
      }
    }
    await fridgeRepo.updateFridgeStats(fridgeID);
    await fridgeRepo.editLast(fridgeID);
  }

  bool _sameDay(DateTime a, DateTime b) {
    if (a.year == b.year) {
      if (a.month == b.month) {
        if (a.day == b.day) {
          return true;
        }
      }
    }
    return false;
  }
}
