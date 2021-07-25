import 'package:flutter/material.dart';
import 'dart:async';
import '../userPage/login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class IntroPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _IntroPage();
}

class _IntroPage extends State<IntroPage> {
  String userId;
  String pageName;
  static final storage = new FlutterSecureStorage();
  @override
  void initState() {
    super.initState();
    //loadData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }
  _asyncMethod() async {
    userId=await storage.read(key: "login");
    print(userId);
    if (userId!=null) {
      pageName='/main';
    }
    else {
      pageName='/login';
    }
    loadData();
  }

  Future<Timer> loadData() async {
    return Timer(Duration(seconds: 3), onDoneLoading);
  }

  onDoneLoading() async {
    Navigator.of(context)
        .pushReplacementNamed(pageName);
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
