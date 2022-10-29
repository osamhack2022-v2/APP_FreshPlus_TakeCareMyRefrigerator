import 'package:flutter/material.dart';
import 'self_certification.dart';

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
          onPressed: () {},
          child: Text("비밀번호 재설정"),
        ),
      ),
    );
  }
}
