import '/firebase/controller/main/general/dto.dart';
import '/firebase/repository/item_repository.dart';

import 'main_ctrl.dart';
import '/firebase/repository/user_repository.dart';
import '/firebase/controller/ctrl_exception.dart';
import '/firebase/repository/unit_repository.dart';
import '/firebase/repository/fridge_repository.dart';
import '/firebase/repository/user_box_repository.dart';

class UnitController {
  late String uid;
  late String unitID;
  late UserRepository userRepo;
  late UnitRepository unitRepo;
  late FridgeRepository fridgeRepo;
  late Unit unit;
  init() async {
    var user = await getLogInUser();
    uid = user.uid;
    unitID = user.unitID;
    if (user.type != "master") throw CtrlException('no-master');
    unitRepo = UnitRepository();
    fridgeRepo = FridgeRepository(unitID);
    fridgeRepo.init();
    userRepo = UserRepository();
    await _checkStatus();
    try {
      unit = await unitRepo.getUnit(unitID);
    } on UnitRepositoryException catch (e) {
      throw CtrlException(e.code);
    }
  }

  UnitDTO getUnit() {
    return UnitDTO(unit.unitID, unit.master, unit.itemNum, unit.warningNum,
        unit.trashNum, unit.lostNum, unit.noHostNum);
  }

  Future<List<FridgeDTO>> getFridgeList() async {
    var fridges = unit.fridges;
    List<FridgeDTO> list = [];
    for (int i = 0; i < fridges.length; i++) {
      try {
        var fridge = await fridgeRepo.getFridge(fridges[i]);
        String managerName = "";
        if (fridge.manager != "")
          managerName = (await userRepo.getUser(fridge.manager)).userName;

        list.add(FridgeDTO(
            fridge.fridgeID,
            fridge.itemNum,
            fridge.manager,
            managerName,
            fridge.warningNum,
            fridge.trashNum,
            fridge.lostNum,
            fridge.noHostNum));
      } on FridgeRepositoryException catch (e) {
        CtrlException(e.code);
      }
    }
    return list;
  }

  Future<void> _checkStatus() async {
    var unit = await unitRepo.getUnit(unitID);
    bool changeLog = false;
    for (var fridgeID in unit.fridges) {
      var fridgeNow = await fridgeRepo.getFridge(fridgeID);
      var boxRepo = UserBoxRepository(unitID, fridgeID);
      boxRepo.init();
      for (var userID in fridgeNow.users) {
        var userNow = await boxRepo.getUserBox(userID);
        var itemRepo = ItemRepository(unitID, fridgeID, uid);
        itemRepo.init();
        changeLog = await itemRepo.checkDate();
        await boxRepo.updateUserStats(userID);
        boxRepo.editLast(userID);
      }
      await fridgeRepo.updateFridgeStats(fridgeID);
      await fridgeRepo.editLast(fridgeID);
    }
    await unitRepo.updateUnitStats(unitID);
    await unitRepo.editLast(unitID);
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
