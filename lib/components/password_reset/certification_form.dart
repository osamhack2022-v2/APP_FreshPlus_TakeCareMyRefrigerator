import 'package:flutter/material.dart';

class CertificationForm extends StatefulWidget {
  const CertificationForm({Key? key}) : super(key: key);

  _CertificationFormState createState() => _CertificationFormState();
}

class _CertificationFormState extends State<CertificationForm> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
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
            TextFormField(
              controller: emailController,
              validator: (email) {
                if (email!.isEmpty) {
                  return '이메일을 입력하세요';
                } else if (email.contains('@') == false) {
                  return '@을 포함한 형식으로 입력해주세요';
                } else {
                  return null;
                }
              },
              //keyboardType: TextInputType.number,
              //inputFormatters: [
              //  FilteringTextInputFormatter.allow(RegExp('[0-9]')),
              //],
              //obscureText: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: Color(0x14212121),
                labelText: "이메일",
                labelStyle: TextStyle(
                    fontSize: 12.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
                hintText: "이메일을 입력해주세요",
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
            ),
            const SizedBox(height: 15.0),
          ],
        ),
      ),
    );
  }
}
