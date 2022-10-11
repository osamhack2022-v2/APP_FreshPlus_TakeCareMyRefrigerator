import 'package:helloworld/firebase/controller/main/general/dto.dart';

import 'main_ctrl.dart';
import '/firebase/repository/user_repository.dart';
import 'package:helloworld/firebase/controller/ctrl_exception.dart';
import '/firebase/repository/unit_repository.dart';
import '/firebase/repository/fridge_repository.dart';

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
    if (user.type != UserType.master) throw CtrlException('no-master');
    unitRepo = UnitRepository();
    fridgeRepo = FridgeRepository(unitID);
    try {
      unit = await unitRepo.getUnit(unitID);
    } on UnitRepositoryException catch (e) {
      throw CtrlException(e.code);
    }
  }
  UnitDTO getUnit(){
    return UnitDTO(unit.unitID, unit.master, unit.itemNum, 
    unit.warningNum, unit.lostNum, unit.noHostNum);
  }
  Future<List<FridgeDTO>> getFridgeList() async{
    var fridges = unit.fridges;
    List<FridgeDTO> list = [];
    fridges.forEach((value) async {
      try{
        var fridge = await fridgeRepo.getFridge(value);
        list.add(FridgeDTO(fridge.fridgeID, fridge.itemNum,
         fridge.manager, fridge.warningNum, fridge.trashNum, 
         fridge.lostNum, fridge.noHostNum));
      } on FridgeRepositoryException catch(e){
        CtrlException(e.code);
      }
    });
    return list;
  }
}
