import '/firebase/repository/unit_repository.dart';
import '/firebase/repository/fridge_repository.dart';
import '/firebase/repository/user_repository.dart';
import 'general/dto.dart';
import 'main_ctrl.dart';
import '../ctrl_exception.dart';

class FridgeAddController {
  late UnitRepository unitRepo;
  late FridgeRepository fridgeRepo;
  late String uid;
  late String unitID;
  late String userType;
  init() async {
    var user = await getLogInUser();
    uid = user.uid;
    unitID = user.unitID;
    print(user.type);
    if (user.type != UserType.master) throw CtrlException('no-master');
    unitRepo = UnitRepository();
    fridgeRepo = FridgeRepository(unitID);
    fridgeRepo.init();
  }

  Future<void> add(String fridgeID) async {
    await fridgeRepo
        .addFridge(Fridge(fridgeID, "", 0, "", [], 0, 0, 0, 0, DateTime.now()));
    //Error Handling req
    await unitRepo.addFridges(unitID, fridgeID);
    //Error Handling req
  }
}
