import 'package:flutter/material.dart';
import 'package:helloworld/components/password_reset/self_certification.dart';
import 'package:helloworld/components/password_reset/password_reset_page.dart';

class Certification_Button_page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CertificationButton(),
    );
  }
}

class CertificationButton extends StatefulWidget {
  @override
  State<CertificationButton> createState() => _CertificationButtonState();
}

class _CertificationButtonState extends State<CertificationButton> {
  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20),
      primary: Color(0xff2C7B0C),
      onPrimary: Color(0xffE0E0E0),
    );

    return Center(
      child: SizedBox(
        width: 250,
        child: ElevatedButton(
          style: style,
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => PasswordReset()));
          },
          child: Text("본인 확인"),
        ),
      ),
    );
  }
}
