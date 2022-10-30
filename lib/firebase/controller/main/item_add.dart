import '/firebase/repository/user_box_repository.dart';
import '/firebase/repository/item_repository.dart';
import 'general/dto.dart';
import 'main_ctrl.dart';
import '/firebase/repository/product_repository.dart';

class ItemAddController {
  late UserBoxRepository userBoxRepo;
  late ItemRepository itemRepo;
  late ProductRepository productRepo;
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
    productRepo = ProductRepository();
  }

  List<ItemAddDTO> getByName(String name) {
    var list = productRepo.searchByName(name);
    List<ItemAddDTO> result = [];
    for (var product in list) {
      result.add(ItemAddDTO(product.itemName, product.itemCode, product.type,
          DateTime.now().add(product.day)));
    }
    return result;
  }

  ItemAddDTO? getByCertName(String name) {
    var list = productRepo.searchByName(name);
    for (var product in list) {
      return ItemAddDTO(product.itemName, product.itemCode, product.type,
          DateTime.now().add(product.day));
    }
    return null;
  }

  ItemAddDTO? getByBarcode(String code) {
    var product = productRepo.searchByCode(code);
    if (product == null)
      return null;
    else
      return ItemAddDTO(product.itemName, product.itemCode, product.type,
          DateTime.now().add(product.day));
  }

  Future<void> add(ItemAddDTO item) async {
    ItemType itemType = ItemType.food;
    switch (item.type) {
      case ("drink"):
        itemType = ItemType.drink;
        break;
    }
    var id = await itemRepo.addItem(Item("", item.itemName, item.itemCode, uid,
        DateTime.now(), item.dueDate, ItemStatus.ok, itemType));
    await userBoxRepo.addItems(uid, id);
  }
}
