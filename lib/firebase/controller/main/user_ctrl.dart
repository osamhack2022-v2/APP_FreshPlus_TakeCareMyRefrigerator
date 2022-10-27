import '/firebase/controller/ctrl_exception.dart';
import '/firebase/repository/item_repository.dart';
import 'main_ctrl.dart';
import '/firebase/repository/user_repository.dart';
import '/firebase/repository/user_box_repository.dart';
import 'general/dto.dart';

class UserController {
  //Login Status
  late String uid;
  late String userName;
  late String unitID;
  late String fridgeID;
  late String userType;

  //Requesting Pages
  late String reqFridgeID;
  late String reqUid;
  late UserBox userBox;
  late UserBoxRepository userBoxRepo;
  init(String? reqFridgeID, String? reqUid) async {
    var user = await getLogInUser();
    uid = user.uid;
    unitID = user.unitID;
    fridgeID = user.fridgeID;
    userName = user.userName;
    print(user.type);
    switch (user.type) {
      case ("master"):
        userType = "master";
        if (reqFridgeID == null || reqUid == null) {
          CtrlException('null-parameter');
        }
        this.reqFridgeID = reqFridgeID!;
        this.reqUid = reqUid!;
        break;

      case ("manager"):
        userType = "manager";
        if (reqUid == null) {
          CtrlException('null-parameter');
        }
        this.reqFridgeID = fridgeID;
        this.reqUid = reqUid!;
        break;

      default:
        userType = "user";
        this.reqFridgeID = fridgeID;
        this.reqUid = uid;
        break;
    }

    userBoxRepo = UserBoxRepository(unitID, this.reqFridgeID);
    userBoxRepo.init();
    await _checkStatus();
    try {
      userBox = await userBoxRepo.getUserBox(this.reqUid);
    } on UserBoxRepositoryException catch (e) {
      throw CtrlException(e.code);
    }
  }

  UserBoxDTO getUserBox() {
    return UserBoxDTO(reqUid, userBox.itemNum, userBox.warningNum,
        userBox.trashNum, userBox.lostNum,userBox.notInNum);
  }

  Future<List<ItemDTO>> getWarningItemList() async {
    var items =
        await userBoxRepo.getItemsQuery('this.reqUid', 'status', 'warning');
    return items.map((value) {
      String type = "drink";
      switch (value.type) {
        case (ItemType.drink):
          type = "drink";
          break;
        case (ItemType.food):
          type = "food";
          break;
      }
      return ItemDTO(value.itemID, value.itemName, value.itemCode, value.uid,
          "warning", type, value.dueDate);
    }).toList();
  }

  Future<List<ItemDTO>> getTrashItemList() async {
    var items =
        await userBoxRepo.getItemsQuery('this.reqUid', 'status', 'warning');
    return items.map((value) {
      String type = "drink";
      switch (value.type) {
        case (ItemType.drink):
          type = "drink";
          break;
        case (ItemType.food):
          type = "food";
          break;
      }
      return ItemDTO(value.itemID, value.itemName, value.itemCode, value.uid,
          "trash", type, value.dueDate);
    }).toList();
  }

  Future<List<ItemDTO>> getCategoryList(String type) async {
    var items = await userBoxRepo.getItemsQuery(reqUid, 'type', type);
    print(items.length);
    return items.map((value) {
      String type = "drink";
      String status = "ok";
      switch (value.type) {
        case (ItemType.drink):
          type = "drink";
          break;
        case (ItemType.food):
          type = "food";
          break;
      }
      switch (value.status) {
        case (ItemStatus.lost):
          status = "lost";
          break;
        case (ItemStatus.notIn):
          status = "noHost";
          break;
        case (ItemStatus.trash):
          status = "trash";
          break;
        case (ItemStatus.warning):
          status = "warning";
          break;
        default:
          break;
      }
      return ItemDTO(value.itemID, value.itemName, value.itemCode, value.uid,
          status, type, value.dueDate);
    }).toList();
  }

  Future<void> _checkStatus() async {
    print("CheckStatus Started");
    var user = await userBoxRepo.getUserBox(uid);
    var itemRepo = ItemRepository(unitID, fridgeID, uid);
    bool changeLog = false;
    itemRepo.init();
    if (_sameDay(user.last, DateTime.now()) == false) {
      print("CHecking Status Really");
      changeLog = await itemRepo.checkDate();
    }
    if (changeLog) {
      print("Update User Stats");
      await userBoxRepo.updateUserStats(uid);
    }
    await userBoxRepo.editLast(uid);
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
