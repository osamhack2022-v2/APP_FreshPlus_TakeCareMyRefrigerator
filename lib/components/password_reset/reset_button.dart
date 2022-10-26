import 'package:flutter/material.dart';
import 'package:helloworld/components/login_page/login_page.dart';

class Reset_button_page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ResetButton(),
    );
  }
}

class ResetButton extends StatefulWidget {
  @override
  State<ResetButton> createState() => _ResetButtonState();
}

class _ResetButtonState extends State<ResetButton> {
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
                context, MaterialPageRoute(builder: (_) => LoginPage()));
          },
          child: Text("비밀번호 재설정"),
        ),
      ),
    );
  }
}
