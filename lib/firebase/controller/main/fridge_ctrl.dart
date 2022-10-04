import 'main_ctrl.dart';
import 'general/dto.dart';
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
  late String reqUid;
  late Fridge fridge;

  init(String? reqFridgeID, String? reqUid) async {
    var user = await getLogInUser();
    uid = user.uid;
    unitID = user.unitID;
    fridgeID = user.fridgeID;
    switch (user.type) {
      case (UserType.manager):
        userType = "manager";
        if (reqFridgeID == null || reqUid == null) {
          throw CtrlException('null-parameter');
        }
        this.reqFridgeID = reqFridgeID!;
        this.reqUid = reqUid!;
        break;

      case (UserType.master):
        userType = "master";
        if (reqUid == null) {
          CtrlException('null-parameter');
        }
        this.reqFridgeID = fridgeID;
        this.reqUid = reqUid!;
        break;

      default:
        throw CtrlException('user-ban');
        break;
    }
  }
  FridgeDTO getFridge() {

  }
  Future<List<UserDTO>> getUserList() async{

  }
  Future<List<ItemDTO>> getStatusItemList(String status) async{

  }
  Future<List<ItemDTO>> getNoHostItemList() async{

  }

}
