import '/firebase/repository/user_box_repository.dart';
import '/firebase/repository/item_repository.dart';
import 'general/dto.dart';
import 'main_ctrl.dart';


class ItemAddController{
  late UserBoxRepository userBoxRepo;
  late ItemRepository itemRepo;
  late String uid;
  late String unitID;
  late String fridgeID;
  late String userType;
  init() async {
    var user = await getLogInUser();
    uid = user.uid;
    unitID = user.unitID;
    fridgeID = user.fridgeID;
    userBoxRepo = UserBoxRepository(unitID, fridgeID);
    userBoxRepo.init();
    itemRepo = ItemRepository(unitID, fridgeID, uid);
    itemRepo.init();
  }

  Future<void> add(ItemAddDTO item) async{
    ItemType itemType=ItemType.food;
    switch(item.type){
      case("drink"):
        itemType = ItemType.drink;
        break;

    }
    var id = await itemRepo.addItem(Item("", item.itemName,item.itemCode, uid, DateTime.now(), item.dueDate, ItemStatus.ok, itemType));
    await userBoxRepo.addItems(uid,id);
  }
}