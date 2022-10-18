class UserBoxDTO {
  String uid;
  int itemNum;
  int warningNum;
  int trashNum;
  int lostNum;
  UserBoxDTO(
      this.uid, this.itemNum, this.warningNum, this.trashNum, this.lostNum);
}

class ItemDTO {
  String itemID;
  String itemName;
  String uid;
  String status;
  String type;
  ItemDTO(this.itemID, this.itemName, this.uid, this.status, this.type);
}

class FridgeDTO {
  String fridgeID;
  int itemNum;
  String manager;
  int warningNum;
  int trashNum;
  int lostNum;
  int noHostNum;
  FridgeDTO(this.fridgeID, this.itemNum, this.manager, this.warningNum,
      this.trashNum, this.lostNum, this.noHostNum);
}

class UnitDTO {
  String unitID;
  String master;
  int itemNum;
  int warningNum;
  int lostNum;
  int noHostNum;
  UnitDTO(this.unitID, this.master, this.itemNum, this.warningNum, this.lostNum,
      this.noHostNum);
}

class ItemAddDTO {
  String itemName;
  String type;
  DateTime dueDate;
  ItemAddDTO(this.itemName, this.type, this.dueDate);
}

class MessageDTO {
  String message;
  bool read;
  MessageDTO(this.message,this.read);
}
