import 'package:flutter/material.dart';
import 'package:helloworld/components/general/homepage_logo.dart';
import 'package:helloworld/components/signup_page/signup_Page.dart';
import 'package:helloworld/components/password_reset/reset_form.dart';
import 'package:helloworld/components/password_reset/reset_button.dart';
import 'package:helloworld/components/login_page/login_page.dart';

class PasswordReset extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: ListView(
              children: [
                HomepageLogo(),
                SizedBox(height: 24.0),
                Text(
                  "비밀번호 재설정!",
                  style: TextStyle(
                    fontSize: 24,
                    color: Color(0xff2C7B0C),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.0),
                PasswordResetForm(),
                Reset_button_page(),
                SizedBox(height: 8.0),
                Form(
                  key: _formKey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => LoginPage()));
                          }
                        },
                        child: const Text(
                          '로그인',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.w500,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                      Text(
                        "|",
                        style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w500,
                          color: Color(0xff000000),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => SignupPage()));
                          }
                        },
                        child: const Text(
                          '회원가입',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.w500,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
