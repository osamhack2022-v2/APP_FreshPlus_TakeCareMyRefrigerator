class UserBoxDTO {
  String uid;
  int itemNum;
  int warningNum;
  int trashNum;
  int lostNum;
  int notInNum;
  UserBoxDTO(this.uid, this.itemNum, this.warningNum, this.trashNum,
      this.lostNum, this.notInNum);
}

class UserDTO {
  String uid;
  String userName;
  String unitID;
  String fridgeID;
  String type;
  UserDTO(this.uid, this.userName, this.unitID, this.fridgeID, this.type);
}

class UserPassDTO {
  String userName;
  int itemNum;
  int warningNum;
  int trashNum;
  int lostNum;
  UserPassDTO(this.userName, this.itemNum, this.warningNum, this.trashNum,
      this.lostNum);
}

class ItemDTO {
  String itemID;
  String itemName;
  String itemCode;
  String uid;
  String status;
  String type;
  DateTime dueDate;
  ItemDTO(this.itemID, this.itemName, this.itemCode, this.uid, this.status,
      this.type, this.dueDate);
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
  int trashNum;
  int lostNum;
  int noHostNum;
  UnitDTO(this.unitID, this.master, this.itemNum, this.warningNum,
      this.trashNum, this.lostNum, this.noHostNum);
}

class ItemAddDTO {
  String itemName;
  String itemCode;
  String type;
  DateTime dueDate;
  ItemAddDTO(this.itemName, this.itemCode, this.type, this.dueDate);
}

class MessageDTO {
  String message;
  bool read;
  MessageDTO(this.message, this.read);
}
