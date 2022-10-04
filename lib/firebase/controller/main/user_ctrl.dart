import 'package:helloworld/firebase/controller/ctrl_exception.dart';
import 'package:helloworld/firebase/repository/item_repository.dart';
import 'main_ctrl.dart';
import '/firebase/repository/user_repository.dart';
import '/firebase/repository/user_box_repository.dart';
import 'general/dto.dart';

class UserController {
  //Login Status
  late String uid;
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
    switch (user.type) {
      case (UserType.master):
        userType = "master";
        if (reqFridgeID == null || reqUid == null) {
          CtrlException('null-parameter');
        }
        this.reqFridgeID = reqFridgeID!;
        this.reqUid = reqUid!;
        break;

      case (UserType.manager):
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
    try {
      userBox = await userBoxRepo.getUserBox(this.reqUid);
    } on UserBoxRepositoryException catch (e) {
      throw CtrlException(e.code);
    }
  }

  UserBoxDTO getUserBox() {
    return UserBoxDTO(reqUid, userBox.itemNum, userBox.warningNum,
        userBox.trashNum, userBox.lostNum);
  }

  Future<List<ItemDTO>> getWarningItemList() async {
    var items =
        await userBoxRepo.getItemsQuery('this.reqUid', 'status', 'warning');
    return items.map((value) {
      String type;
      switch (value.type) {
        case (ItemType.drink):
          type = "drink";
          break;
        case (ItemType.food):
          type = "food";
          break;
      }
      return ItemDTO(value.itemID, value.itemName, value.uid, "warning", type);
    }).toList();
  }

  Future<List<ItemDTO>> getTrashItemList() async {
    var items =
        await userBoxRepo.getItemsQuery('this.reqUid', 'status', 'warning');
    return items.map((value) {
      String type;
      switch (value.type) {
        case (ItemType.drink):
          type = "drink";
          break;
        case (ItemType.food):
          type = "food";
          break;
      }
      return ItemDTO(value.itemID, value.itemName, value.uid, "trash", type);
    }).toList();
  }

  Future<List<ItemDTO>> getCategoryList(String type) async {
    var items = await userBoxRepo.getItemsQuery('this.reqUid', 'type', type);
    return items.map((value) {
      String type;
      String status ="ok";
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
        case (ItemStatus.noHost):
          status = "noHost";
          break;
        case (ItemStatus.trash):
          status = "trash";
          break;
        case (ItemStatus.warning):
          status = "warning";
          break;
      }
      return ItemDTO(value.itemID, value.itemName, value.uid, status, type);
    }).toList();
  }
}
