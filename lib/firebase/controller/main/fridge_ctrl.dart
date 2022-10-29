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
  late String managerName;
  //Requesting Pages
  late String reqFridgeID;
  late Fridge fridge;
  late FridgeRepository fridgeRepo;
  late UserBoxRepository userBoxRepo;
  late UserRepository userRepo;
  init(String? reqFridgeID) async {
    var user = await getLogInUser();
    uid = user.uid;
    unitID = user.unitID;
    fridgeID = user.fridgeID;
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
    userRepo = UserRepository();
    fridgeRepo = FridgeRepository(unitID);
    fridgeRepo.init();
    userBoxRepo = UserBoxRepository(unitID, this.reqFridgeID);
    userBoxRepo.init();
    await _checkStatus();
    try {
      print(6);
      fridge = await fridgeRepo.getFridge(this.reqFridgeID);
      managerName = (await userRepo.getUser(fridge.manager)).userName;
    } on FridgeRepositoryException catch (e) {
      throw CtrlException(e.code);
    }
  }

  FridgeDTO getFridge() {
    return FridgeDTO(
        fridge.fridgeID,
        fridge.itemNum,
        fridge.manager,
        managerName,
        fridge.warningNum,
        fridge.trashNum,
        fridge.lostNum,
        fridge.noHostNum);
  }

  Future<List<UserBoxDTO>> getUserList() async {
    List<UserBoxDTO> list = [];
    List<String> userList = fridge.users;
    for (int i = 0; i < userList.length; i++) {
      UserBox userBox;
      try {
        print(userList.length.toString() + "userListLength25");
        print(userList);
        userBox = await userBoxRepo.getUserBox(userList[i]);
        print(userList.length.toString() + "userListLength33");
        print(userList);
        String name = (await userRepo.getUser(userList[i])).userName;
        list.add(UserBoxDTO(
            userBox.uid,
            name,
            userBox.itemNum,
            userBox.warningNum,
            userBox.trashNum,
            userBox.lostNum,
            userBox.notInNum));
      } on UserBoxRepositoryException catch (e) {
        CtrlException(e.code);
      }
    }
    print("listlength" + list.length.toString());
    return list;
  }

  Future<List<ItemDTO>> getStatusItemList(String status) async {
    List<ItemDTO> list = [];
    List<String> userList = [...fridge.users];
    userList.add(fridge.manager);
    for (int i = 0; i < userList.length; i++) {
      List<Item> itemList = [];
      try {
        itemList =
            await userBoxRepo.getItemsQuery(userList[i], "status", status);
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
              value.uid, status, type, value.dueDate));
        });
      } on UserBoxRepositoryException catch (e) {
        CtrlException(e.code);
      }
      ;
    }

    return list;
    //users에 manager 포함되게 변경 필요
  }

  Future<List<ItemDTO>> getWarningTrashItem() async {
    var list = await getStatusItemList("warning");
    var list2 = await getStatusItemList("trash");
    print(list2);
    print(list);
    list.addAll(list2);
    return list;
  }

  Future<List<ItemDTO>> getNoHostItemList() async {
    List<ItemDTO> list = [];
    try {
      return (await userBoxRepo.getNoHost()).map((value) {
        var type = "food";
        switch (value.type) {
          case (ItemType.drink):
            type = "drink";
            break;
          case (ItemType.food):
            type = "food";
            break;
        }
        return ItemDTO(value.itemID, value.itemCode, value.itemName, value.uid,
            "ok", type, value.dueDate);
      }).toList();
    } on UserBoxRepositoryException catch (e) {
      CtrlException(e.code);
    }
    return list;
  }

  Future<void> _checkStatus() async {
    var fridge = await fridgeRepo.getFridge(this.reqFridgeID);
    bool changeLog = false;
    print("check Started");
    var userlist = [...fridge.users];
    userlist.add(fridge.manager);
    for (var uid in userlist) {
      print(uid);
      var user = await userBoxRepo.getUserBox(uid);
      var itemRepo = ItemRepository(unitID, this.reqFridgeID, uid);
      itemRepo.init();
      if (_sameDay(user.last, DateTime.now()) == false)
        changeLog = await itemRepo.checkDate();
      await userBoxRepo.updateUserStats(uid);
      await userBoxRepo.editLast(uid);
    }
    await fridgeRepo.updateFridgeStats(this.reqFridgeID);
    await fridgeRepo.editLast(this.reqFridgeID);
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
