import 'package:flutter/material.dart';
import 'dart:async';
import '../userPage/login.dart';

class IntroPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _IntroPage();
}

class _IntroPage extends State<IntroPage> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<Timer> loadData() async {
    return Timer(Duration(seconds: 5), onDoneLoading);
  }

  onDoneLoading() async {
    Navigator.of(context)
        .pushReplacementNamed('/login');
    //MaterialPageRoute(builder: (context) => LoginPage())
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF88C26F),
        child: Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0,0),
            child : Image.asset('image/logo_green1.jpg', width: 400),
          ),
        ),
      ),
    );
  }
}
