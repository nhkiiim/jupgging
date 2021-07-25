import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:jupgging/models/user.dart';
import 'package:jupgging/auth/url.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> with SingleTickerProviderStateMixin {
  FirebaseDatabase _database;
  DatabaseReference reference;
  URL url=URL();
  String _databaseURL;

  double opacity = 0; //?
  AnimationController _animationController;
  Animation _animation;
  TextEditingController _idTextController;
  TextEditingController _pwTextController;

  @override
  void initState() {
    super.initState();
    _databaseURL=url.databaseURL;
    _idTextController = TextEditingController();
    _pwTextController = TextEditingController();

    //여기 뭐하는거지?
    Timer(Duration(seconds: 2), () {
      setState(() {
        opacity = 1;
      });
    });

    _database = FirebaseDatabase(databaseURL: _databaseURL);
    reference = _database.reference().child('user');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color:Colors.white,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              child: Center(
                  child: Column(
                    children: <Widget>[
                    Image.asset('image/logo2.jpg', width: 400),
                      AnimatedOpacity(
                        opacity: opacity,
                        duration: Duration(seconds: 1),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              width: 200,
                              child: TextField(
                                controller: _idTextController,
                                maxLines: 1,
                                decoration: InputDecoration(
                                    labelText: 'ID', border: OutlineInputBorder()),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: 200,
                              child: TextField(
                                controller: _pwTextController,
                                maxLines: 1,
                                decoration: InputDecoration(
                                    labelText: 'PW', border: OutlineInputBorder()),
                                obscureText: true,
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pushNamed('/sign');
                                    },
                                    child: Text('회원가입')),
                                FlatButton(
                                    onPressed: () {
                                      if (_idTextController.value.text.length == 0 ||
                                          _pwTextController.value.text.length == 0) {
                                        makeDialog('빈칸이 있습니다');
                                      } else {
                                        reference
                                            .child(_idTextController.value.text)
                                            .onValue
                                            .listen((event) {
                                          if (event.snapshot.value == null) {
                                            makeDialog('아이디가 없습니다');
                                          } else {
                                            reference
                                                .child(_idTextController.value.text)
                                                .onChildAdded
                                                .listen((event) {
                                              User user = User.fromSnapshot(event.snapshot);
                                              var bytes = utf8
                                                  .encode(_pwTextController.value.text);
                                              var digest = sha1.convert(bytes);
                                              if (user.pw == digest.toString()) {
                                                Navigator.of(context)
                                                    .pushReplacementNamed('/main',
                                                    arguments:
                                                    _idTextController.value.text);
                                              } else {
                                                makeDialog('비밀번호가 틀립니다');
                                              }
                                            });
                                          }
                                        });
                                      }
                                    },
                                    child: Text('로그인'))
                              ],
                              mainAxisAlignment: MainAxisAlignment.center,
                            )
                          ],
                        ),
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  )),
            ),
          ),
        ),
      ),
    );
  }

  void makeDialog(String text) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(text),
          );
        });
  }
}