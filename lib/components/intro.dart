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
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('image/intro.png',
                  width: 200, height: 200, fit: BoxFit.scaleDown),
              Text('Jubgging',
                  style: TextStyle(
                      fontFamily: 'Pacifico',
                      fontSize: 40,
                      color: const Color(0xFF88C26F))),
            ],
          ),
        ),
      ),
    );
  }
}
