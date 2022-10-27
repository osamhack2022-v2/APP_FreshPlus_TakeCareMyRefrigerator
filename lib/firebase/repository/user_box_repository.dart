import 'package:cloud_firestore/cloud_firestore.dart';
import 'item_repository.dart';

class UserBox {
  String uid;
  int itemNum;
  List<String> items;
  int warningNum;
  int trashNum;
  int lostNum;
  int notInNum;
  DateTime last;
  UserBox(this.uid, this.itemNum, this.items, this.warningNum, this.trashNum,
      this.lostNum, this.notInNum, this.last);
}

class UserBoxRepositoryException {
  String code;
  UserBoxRepositoryException(this.code);
}

class UserBoxRepository {
  String unitID;
  String fridgeID;
  CollectionReference? userBoxesRef;
  UserBoxRepository(this.unitID, this.fridgeID);
  void init() {
    //https://firebase.google.com/docs/firestore/solutions/aggregation?hl=ko Control way for warningNum, trashNum
    userBoxesRef = FirebaseFirestore.instance
        .collection('unit')
        .doc(unitID)
        .collection('fridges')
        .doc(fridgeID)
        .collection('userBoxes');
    if (userBoxesRef == null)
      throw UserBoxRepositoryException("null-userBoxes");
  }

  Future<void> addUserBox(UserBox userBox) async {
    DocumentSnapshot userBoxSnapshot =
        await userBoxesRef!.doc(userBox.uid).get();
    var userBoxDoc = {
      'uid': userBox.uid,
      'itemNum': userBox.itemNum,
      'items': [],
      'warningNum': 0,
      'trashNum': 0,
      'lostNum': 0,
      'notInNum': 0,
      'last': Timestamp.fromDate(DateTime.now())
    };
    if (userBoxSnapshot.exists == true) {
      throw UserBoxRepositoryException('already-exist');
    } else {
      await userBoxesRef!.doc(userBox.uid).set(userBoxDoc);
    }
  }

  Future<void> deleteUserBox(String uid) async {
    DocumentReference userBoxRef = userBoxesRef!.doc(uid);
    userBoxRef.delete();
  }

  //will be deleted soon
  Future<void> editItemNum(String uid, int num) async {
    DocumentSnapshot userBoxSnapshot = await userBoxesRef!.doc(uid).get();
    if (userBoxSnapshot.exists == false)
      throw UserBoxRepositoryException('no-userbox');
    int numPast = userBoxSnapshot.get('itemNum');
    await userBoxesRef!.doc(uid).update({'itemNum': (numPast + num)});
  }

  Future<void> editLast(String uid) async {
    await userBoxesRef!
        .doc(uid)
        .update({'last': Timestamp.fromDate(DateTime.now())});
  }

  Future<void> updateUserStats(String uid) async {
    DocumentReference userBoxRef = await userBoxesRef!.doc(uid);
    if ((await userBoxRef.get()).exists == false)
      throw UserBoxRepositoryException('no-userbox');
    int warningNum = (await (userBoxesRef!
                .doc(uid)
                .collection('items')
                .where("status", isEqualTo: "warning"))
            .get())
        .size;
    int trashNum = (await (userBoxesRef!
                .doc(uid)
                .collection('items')
                .where("status", isEqualTo: "trash"))
            .get())
        .size;
    int lostNum = (await (userBoxesRef!
                .doc(uid)
                .collection('items')
                .where("status", isEqualTo: "lost"))
            .get())
        .size;
    int notIn = (await (userBoxesRef!
                .doc(uid)
                .collection('items')
                .where("status", isEqualTo: "notIn"))
            .get())
        .size;
    await userBoxRef.update(
        {'warningNum': warningNum, 'trashNum': trashNum, 'lostNum': lostNum});
  }

  Future<void> addItems(String uid, String itemID) async {
    await userBoxesRef!.doc(uid).update({
      'items': FieldValue.arrayUnion([itemID])
    });
    await editItemNum(uid, 1);
  }

  Future<void> deleteItems(String uid, String itemID) async {
    await userBoxesRef!.doc(uid).update({
      'items': FieldValue.arrayRemove([itemID])
    });
    await editItemNum(uid, -1);
  }

  Future<UserBox> getUserBox(String uid) async {
    DocumentSnapshot userBoxSnapshot = await userBoxesRef!.doc(uid).get();
    if (userBoxSnapshot.exists == false)
      throw UserBoxRepositoryException('no-userbox');
    return UserBox(
        userBoxSnapshot.get('uid'),
        userBoxSnapshot.get('itemNum'),
        userBoxSnapshot.get('items').cast<String>(),
        userBoxSnapshot.get('warningNum'),
        userBoxSnapshot.get('trashNum'),
        userBoxSnapshot.get('lostNum'),
        userBoxSnapshot.get('notInNum'),
        userBoxSnapshot.get('last').toDate());
  }

  Future<List<Item>> getItemsQuery(
      String uid, String fieldName, String fieldValue) async {
    CollectionReference itemsRef = userBoxesRef!.doc(uid).collection("items");
    Query query = itemsRef.where(fieldName, isEqualTo: fieldValue);
    List<QueryDocumentSnapshot> queryDocSnapshotList = (await query.get()).docs;
    return queryDocSnapshotList.map((value) {
      if (value.exists == false) throw UserBoxRepositoryException('no-item');
      DateTime inDate = value.get('inDate').toDate();
      DateTime dueDate = value.get('dueDate').toDate();
      ItemStatus status = ItemStatus.ok;
      ItemType type = ItemType.drink;
      switch (value.get('status')) {
        case ('lost'):
          status = ItemStatus.lost;
          break;
        case ('notIn'):
          status = ItemStatus.notIn;
          break;
        case ('trash'):
          status = ItemStatus.trash;
          break;
        case ('warning'):
          status = ItemStatus.warning;
          break;
      }
      switch (value.get('type')) {
        case ("food"):
          type = ItemType.food;
          break;
      }
      return Item(
          value.get('itemID'),
          value.get('itemName'),
          value.get('itemCode'),
          value.get('uid'),
          inDate,
          dueDate,
          status,
          type);
    }).toList();
  }

  Future<List<Item>> getNoHost() async {
    CollectionReference itemsRef =
        userBoxesRef!.doc("noHost").collection("items");
    List<QueryDocumentSnapshot> queryDocSnapshotList =
     (await itemsRef.get()).docs;
    return queryDocSnapshotList.map((value) {
      if (value.exists == false) throw UserBoxRepositoryException('no-item');
      DateTime inDate = value.get('inDate').toDate();
      DateTime dueDate = value.get('dueDate').toDate();
      ItemStatus status = ItemStatus.ok;
      ItemType type = ItemType.drink;
      switch (value.get('status')) {
        case ('lost'):
          status = ItemStatus.lost;
          break;
        case ('notIn'):
          status = ItemStatus.notIn;
          break;
        case ('trash'):
          status = ItemStatus.trash;
          break;
        case ('warning'):
          status = ItemStatus.warning;
          break;
      }
      switch (value.get('type')) {
        case ("food"):
          type = ItemType.food;
          break;
      }
      return Item(
          value.get('itemID'),
          value.get('itemName'),
          value.get('itemCode'),
          value.get('uid'),
          inDate,
          dueDate,
          status,
          type);
    }).toList();
  }
}
