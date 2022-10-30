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
  late ItemRepository itemRepo;
  late String reqFridgeID;
  late String reqUid;
  late UserBox userBox;
  late UserBoxRepository userBoxRepo;
  late UserRepository userRepo;
  init(String? reqFridgeID, String? reqUid) async {
    var user = await getLogInUser();
    uid = user.uid;
    unitID = user.unitID;
    fridgeID = user.fridgeID;
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
    userRepo = UserRepository();
    userName = (await userRepo.getUser(this.reqUid)).userName;
    userBoxRepo = UserBoxRepository(unitID, this.reqFridgeID);
    userBoxRepo.init();
    itemRepo = ItemRepository(unitID, this.reqFridgeID, this.reqUid);
    itemRepo.init();
    await _checkStatus();
    try {
      userBox = await userBoxRepo.getUserBox(this.reqUid);
    } on UserBoxRepositoryException catch (e) {
      throw CtrlException(e.code);
    }
  }

  UserBoxDTO getUserBox() {
    return UserBoxDTO(reqUid, userName, userBox.itemNum, userBox.warningNum,
        userBox.trashNum, userBox.lostNum, userBox.notInNum);
  }

  Future<List<ItemDTO>> getWarningItemList() async {
    var items = await userBoxRepo.getItemsQuery(reqUid, 'status', 'warning');
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
    var items = await userBoxRepo.getItemsQuery(reqUid, 'status', 'trash');
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

  Future<List<ItemDTO>> getWarningTrashList() async {
    var items = (await getTrashItemList());
    items.addAll((await getWarningItemList()));
    return items;
  }

  Future<List<ItemDTO>> getLostItemList() async {
    var items = await userBoxRepo.getItemsQuery(reqUid, 'status', 'lost');
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
          "lost", type, value.dueDate);
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
          status = "notIn";
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

  Future<void> deleteItem(String itemID) async {
    await itemRepo.deleteItem(itemID);
    await userBoxRepo.deleteItems(reqUid, itemID);
    await userBoxRepo.editItemNum(reqUid, -1);
  }

  Future<void> _checkStatus() async {
    print("CheckStatus Started");
    var itemRepo = ItemRepository(unitID, reqFridgeID, reqUid);
    bool changeLog = false;
    itemRepo.init();
    print("CHecking Status Really");
    changeLog = await itemRepo.checkDate();
    await userBoxRepo.updateUserStats(reqUid);
    await userBoxRepo.editLast(reqUid);
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

  Future<List<MessageDTO>> getMessages() async {
    var unread = await userRepo.getUnreadMessage(reqUid);
    //var read = await userRepo.getReadMessage(uid);
    List<MessageDTO> unreadDTO = unread.map((value) {
      return MessageDTO(value, false);
    }).toList();
    // List<MessageDTO> readDTO = read.map((value) {
    //   return MessageDTO(value, true);
    // }).toList();
    // unreadDTO.addAll(readDTO);
    return unreadDTO;
  }
}
