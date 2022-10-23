import 'package:helloworld/firebase/controller/main/general/dto.dart';
import 'package:helloworld/firebase/repository/item_repository.dart';

import 'main_ctrl.dart';
import '/firebase/repository/user_repository.dart';
import 'package:helloworld/firebase/controller/ctrl_exception.dart';
import '/firebase/repository/unit_repository.dart';
import '/firebase/repository/fridge_repository.dart';
import '/firebase/repository/user_box_repository.dart';

class UnitController {
  late String uid;
  late String unitID;

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
    //await _checkStatus();
    try {
      unit = await unitRepo.getUnit(unitID);
    } on UnitRepositoryException catch (e) {
      throw CtrlException(e.code);
    }
  }
  UnitDTO getUnit() {
    return UnitDTO(unit.unitID, unit.master, unit.itemNum, unit.warningNum,
        unit.trashNum,unit.lostNum, unit.noHostNum);
  }

  Future<List<FridgeDTO>> getFridgeList() async {
    var fridges = unit.fridges;
    List<FridgeDTO> list = [];
    fridges.forEach((value) async {
      try {
        var fridge = await fridgeRepo.getFridge(value);
        list.add(FridgeDTO(
            fridge.fridgeID,
            fridge.itemNum,
            fridge.manager,
            fridge.warningNum,
            fridge.trashNum,
            fridge.lostNum,
            fridge.noHostNum));
      } on FridgeRepositoryException catch (e) {
        CtrlException(e.code);
      }
    });
    return list;
  }

  Future<void> _checkStatus() async {
    var unit = await unitRepo.getUnit(unitID);
    bool changeLog = false;
    if (_sameDay(unit.last, DateTime.now()) == false) {
      for (var fridgeID in unit.fridges) {
        var fridgeNow = await fridgeRepo.getFridge(fridgeID);
        var boxRepo = UserBoxRepository(unitID, fridgeID);
        boxRepo.init();
        if (_sameDay(fridgeNow.last, DateTime.now()) == false) {
          for (var userID in fridgeNow.users) {
            var userNow = await boxRepo.getUserBox(userID);
            var itemRepo = ItemRepository(unitID, fridgeID, uid);
            itemRepo.init();
            if (_sameDay(userNow.last, DateTime.now()) == false) {
              changeLog = await itemRepo.checkDate();
            }
            if (changeLog) {
              await boxRepo.updateUserStats(userID);
            }
            boxRepo.editLast(userID);
          }
        }
        if (changeLog) {
          await fridgeRepo.updateFridgeStats(fridgeID);
        }
        await fridgeRepo.editLast(fridgeID);
      }
    }
    if (changeLog) {
      await unitRepo.updateUnitStats(unitID);
    }
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
