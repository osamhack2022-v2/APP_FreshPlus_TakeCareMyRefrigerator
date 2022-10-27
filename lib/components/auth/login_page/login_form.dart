import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/firebase/repository/user_repository.dart';
import '/components/home_page/home_page.dart';
import 'package:get/get.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);
  _CustomFormState createState() => _CustomFormState();
}

class _CustomFormState extends State<LoginForm> {
  static final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final UserRepository repo = UserRepository();
  bool _isObscure = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
              validator: (value) {
                if (value!.isEmpty) {
                  return '이메일을 입력하세요';
                } else if (!RegExp(
                        r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                    .hasMatch(value)) {
                  return '이메일 형식이 바르지 않습니다';
                } else {
                  return null;
                }
              },
              //keyboardType: TextInputType.number,
              //inputFormatters: [
              // FilteringTextInputFormatter.allow(RegExp('[0-9]')),
              //],
              //obscureText: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: Color(0x14212121),
                labelText: "E-mail",
                labelStyle: TextStyle(
                    fontSize: 12.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
                hintText: "Input E-mail",
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
            TextFormField(
              controller: passwordController,
              validator: (value) {
                if (value!.isEmpty) {
                  return '비밀번호를 입력하세요';
                } else if (value.length < 8) {
                  return '비밀번호가 짧습니다';
                } else {
                  return null;
                }
              },
              obscureText: _isObscure,
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: const Color(0x14212121),
                labelText: "Password",
                labelStyle: const TextStyle(
                    fontSize: 12.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
                hintText: "Input Password",
                hintStyle: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscure ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0x14212121)),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4.0),
                      topRight: Radius.circular(4.0)),
                ),
                focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff6200EE))),
                errorBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
            ),
            const SizedBox(height: 17.0),
            SizedBox(
              width: 250.0,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    try {
                      _signIn(emailController.text.trim(),
                          passwordController.text.trim());
                    } on UserRepositoryException catch (e) {
                      print(e.code);
                    }
                  }
                },
                child: const Text(
                  '로그인test',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.w500,
                    color: Color(0xffFFFFFF),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xff2C7B0C),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _signIn(String email, String password) async {
    await repo.requestLogIn(
        emailController.text.trim(), passwordController.text.trim());
    Get.offAll(() => HomePage());
  }
}
