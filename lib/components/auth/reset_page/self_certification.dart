import 'package:flutter/material.dart';
import '/components/general/homepage_logo.dart';
import 'certification_form.dart';
import '/components/auth/signup_page/signup_page.dart';
import '/components/auth/login_page/login_page.dart';

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
                SizedBox(height: 8.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
