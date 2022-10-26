import 'package:flutter/material.dart';
import 'package:helloworld/components/general/homepage_logo.dart';
import 'package:helloworld/components/password_reset/certification_form.dart';
import 'package:helloworld/components/password_reset/certification_button.dart';
import 'package:helloworld/components/password_reset/self_certification.dart';
import 'package:helloworld/components/auth/signup_Page/signup_Page.dart';
import 'package:helloworld/components/password_reset/password_reset_page.dart';
import 'package:helloworld/components/login_page/login_page.dart';

class SelfCertification extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
                SizedBox(height: 24),
                CertificationForm(),
                Certification_Button_page(),
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
