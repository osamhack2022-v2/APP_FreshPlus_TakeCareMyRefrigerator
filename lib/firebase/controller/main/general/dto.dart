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
  ItemDTO(this.itemID, this.itemName, this.uid, this.status,this.type);
}

class UserDTO{

}

class FridgeDTO{
  
}