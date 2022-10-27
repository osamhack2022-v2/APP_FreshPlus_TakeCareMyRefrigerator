import 'package:flutter/material.dart';
import '/firebase/controller/main/item_add.dart';
import '/firebase/controller/main/general/dto.dart';

class EnterItem extends StatelessWidget {
  const EnterItem({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "아이템 추가",
            style: TextStyle(fontSize: 24, color: Color(0xff2C7B0C)),
          ),
          SizedBox(height: 20),
          Text(
            "아래 정보를 입력하신 후",
            style: TextStyle(fontSize: 14),
          ),
          Text(
            "오른쪽 아래 전송버튼을 누르시면 됩니다",
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 40),
          AddItemForm(),
        ],
      ),
    );
  }
}

class AddItemForm extends StatefulWidget {
  const AddItemForm({Key? key}) : super(key: key);
  _AddItemFormState createState() => _AddItemFormState();
}

class _AddItemFormState extends State<AddItemForm> {
  final _formKey = GlobalKey<FormState>();
  final foodnameController = TextEditingController();
  final expirationDateController = TextEditingController();
  final itemAddController = ItemAddController();
  ItemAddDTO? item = null;
  DateTime dueDate = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    itemAddController.init();
  }

  @override
  void dispose() {
    foodnameController.dispose();
    expirationDateController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 0.0, 23.0, 0.0),
        child: Column(
          children: [
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') {
                  return const Iterable<String>.empty();
                }
                return itemAddController
                    .getByName(textEditingValue.text)
                    .map((value) {
                  return value.itemName;
                });
              },
              onSelected: (String selection) {
                debugPrint('You just selected $selection');
                setState(
                  ()
                {item = itemAddController.getByCertName(selection);});
                
              },
              fieldViewBuilder:
                  (context, controller, focusNode, onEditingComplete) {
                return TextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  onEditingComplete: onEditingComplete,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Color(0x14212121),
                    labelText: "식품이름",
                    labelStyle: TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                    hintText: "식품이름을 입력해주세요",
                    hintStyle: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0x14212121)),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff6200EE))),
                    errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    errorStyle: TextStyle(
                      fontFamily: "Roboto",
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 15.0),
            const SizedBox(height: 15.0),
            InputDatePickerFormField(
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(Duration(days: 30)),
              initialDate: item!=null ? item!.dueDate : DateTime.now(),
              onDateSaved: (date) {
                setState(() {
                  dueDate = date;
                });
              },
            ),
            const SizedBox(height: 15.0),
            ElevatedButton(
                onPressed: () {
                  if (item != null) {
                    itemAddController.add(item!);
                  }
                },
                child: Text("아이템 추가"))
          ],
        ),
      ),
    );
  }
}
