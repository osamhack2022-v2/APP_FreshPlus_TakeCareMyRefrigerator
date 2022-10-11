import 'package:cloud_firestore/cloud_firestore.dart';

enum ItemStatus { ok, lost, noHost, warning, trash }

enum ItemType { drink, food }

class Item {
  String itemID;
  String itemName;
  String uid;
  DateTime inDate;
  DateTime dueDate;
  ItemStatus status;
  ItemType type;
  Item(this.itemID, this.itemName, this.uid, this.inDate, this.dueDate,
      this.status, this.type);
}

class ItemRepositoryException {
  String code;
  ItemRepositoryException(this.code);
}

class ItemRepository {
  String unitID;
  String fridgeID;
  String uid;
  CollectionReference? itemsRef;
  ItemRepository(this.unitID, this.fridgeID, this.uid);

  void init() {
    itemsRef = FirebaseFirestore.instance
        .collection('unit')
        .doc(unitID)
        .collection('fridges')
        .doc(fridgeID)
        .collection('userBoxes')
        .doc(uid)
        .collection('items');
    if (itemsRef == null) throw ItemRepositoryException("null-items");
  }

  Future<String> addItem(Item item) async {
    //itemID자율배정입니다.
    var itemDoc = {
      'itemID': "",
      'itemName': item.itemName,
      'uid': item.uid,
      'inDate': Timestamp.fromDate(item.inDate),
      'dueDate': Timestamp.fromDate(item.dueDate),
    };
    switch (item.status) {
      case (ItemStatus.ok):
        itemDoc['status'] = 'ok';
        break;
      case (ItemStatus.lost):
        itemDoc['status'] = 'lost';
        break;
      case (ItemStatus.noHost):
        itemDoc['status'] = 'noHost';
        break;
      case (ItemStatus.trash):
        itemDoc['status'] = 'trash';
        break;
      case (ItemStatus.warning):
        itemDoc['status'] = 'warning';
        break;
    }
    switch (item.type) {
      case (ItemType.drink):
        itemDoc['type'] = 'drink';
        break;
      case (ItemType.food):
        itemDoc['type'] = 'food';
        break;
    }
    DocumentReference docRef = await itemsRef!.add(itemDoc);
    await docRef.update({'itemID': docRef.id});
    return docRef.id;
  }

  Future<void> deleteItem(String itemID) async {
    //check it is null?
    DocumentReference itemRef = itemsRef!.doc(itemID);
    itemRef.delete();
  }

  Future<void> editItemName(String itemID, String itemName) async {
    DocumentSnapshot itemSnapshot = await itemsRef!.doc(itemID).get();
    if (itemSnapshot.exists == false) throw ItemRepositoryException('no-item');
    await itemsRef!.doc(itemID).update({'itemName': itemName});
  }

  Future<void> editDueDate(String itemID, DateTime dueDate) async {
    DocumentSnapshot itemSnapshot = await itemsRef!.doc(itemID).get();
    if (itemSnapshot.exists == false) throw ItemRepositoryException('no-item');
    await itemsRef!
        .doc(itemID)
        .update({'dueDate': Timestamp.fromDate(dueDate)});
  }

  Future<void> editstatus(String itemID, ItemStatus status) async {
    DocumentSnapshot itemSnapshot = await itemsRef!.doc(itemID).get();
    if (itemSnapshot.exists == false) throw ItemRepositoryException('no-item');
    String statusStr = "ok";
    switch (status) {
      case (ItemStatus.ok):
        statusStr = 'ok';
        break;
      case (ItemStatus.lost):
        statusStr = 'lost';
        break;
      case (ItemStatus.noHost):
        statusStr = 'noHost';
        break;
      case (ItemStatus.trash):
        statusStr = 'trash';
        break;
      case (ItemStatus.warning):
        statusStr = 'warning';
        break;
    }
    await itemsRef!.doc(itemID).update({'status': statusStr});
  }

  Future<Item> getItem(String itemID) async {
    DocumentSnapshot itemSnapshot = await itemsRef!.doc(itemID).get();
    if (itemSnapshot.exists == false) throw ItemRepositoryException('no-item');
    DateTime inDate = itemSnapshot.get('inDate').toDate();
    DateTime dueDate = itemSnapshot.get('dueDate').toDate();
    ItemStatus status = ItemStatus.ok;
    switch (itemSnapshot.get('status')) {
      case ('lost'):
        status = ItemStatus.lost;
        break;
      case ('noHost'):
        status = ItemStatus.noHost;
        break;
      case ('trash'):
        status = ItemStatus.trash;
        break;
      case ('warning'):
        status = ItemStatus.warning;
        break;
    }
    return Item(
        itemSnapshot.get('itemID'),
        itemSnapshot.get('itemName'),
        itemSnapshot.get('uid'),
        inDate,
        dueDate,
        status,
        itemSnapshot.get('type'));
  }
}
