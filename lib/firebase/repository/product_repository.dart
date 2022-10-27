import '/firebase/controller/main/general/dto.dart';

class Product {
  int index;
  String itemName;
  String itemCode;
  String barcode;
  Duration day;
  String type;
  Product(this.index, this.itemName, this.itemCode, this.barcode, this.day,
      this.type);
}

class ProductRepository {
  List<Product> list = [
    Product(0, "액티비아", "activia", "", Duration(days: 16), "drink"),
    Product(1, "애플에이드", "appleade", "", Duration(days: 30), "drink"),
    Product(2, "바나나우유", "bananamilk", "", Duration(days: 7), "drink"),
    Product(3, "두유", "beanmilk", "", Duration(days: 7), "drink"),
    Product(4, "딸기우유", "berrymilk", "", Duration(days: 7), "drink"),
    Product(5, "치즈", "cheese", "", Duration(days: 10), "food"),
    Product(6, "닭가슴살", "chicken", "", Duration(days: 14), "food"),
    Product(7, "계란", "egg", "", Duration(days: 14), "food"),
    Product(8, "갈아만든배", "idh", "", Duration(days: 30), "drink"),
    Product(9, "피크닉", "picnic", "", Duration(days: 30), "drink"),
  ];

  List<Product> searchByName(String name) {
    List<Product> result = [];
    for (var product in list) {
      if (product.itemName.contains(name)) result.add(product);
    }
    return result;
  }

  Product? searchByCode(String code) {
    for (var product in list) {
      if (product.barcode == code) return product;
    }
    return null;
  }
}
