import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:jupgging/data/user.dart';

class SignPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignPage();
}

class _SignPage extends State<SignPage> {
  FirebaseDatabase _database;
  DatabaseReference reference;
  String _databaseURL =
      'https://flutterproject-86abc-default-rtdb.asia-southeast1.firebasedatabase.app/';

  TextEditingController _nameTextController;
  TextEditingController _idTextController;
  TextEditingController _pwTextController;
  TextEditingController _pwCheckTextController;
  TextEditingController _emailTextController;

  @override
  void initState() {
    super.initState();
    _nameTextController = TextEditingController();
    _idTextController = TextEditingController();
    _pwTextController = TextEditingController();
    _pwCheckTextController = TextEditingController();
    _emailTextController = TextEditingController();

    _database = FirebaseDatabase(databaseURL: _databaseURL);
    reference = _database.reference().child('user');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
      ),
      body: Container(
        child: Center(
          child: Expanded(
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _nameTextController,
                    maxLines: 1,
                    decoration: InputDecoration(
                        labelText: 'NAME', border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _idTextController,
                    maxLines: 1,
                    decoration: InputDecoration(
                        hintText: '4자 이상 입력해주세요',
                        labelText: 'ID',
                        border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _pwTextController,
                    obscureText: true,
                    maxLines: 1,
                    decoration: InputDecoration(
                        hintText: '6자 이상 입력해주세요',
                        labelText: 'PW',
                        border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _pwCheckTextController,
                    obscureText: true,
                    maxLines: 1,
                    decoration: InputDecoration(
                        labelText: 'PW CHECK', border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _emailTextController,
                    maxLines: 1,
                    decoration: InputDecoration(
                        labelText: 'EMAIL', border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                FlatButton(
                  onPressed: () {
                    if (_idTextController.value.text.length >= 4 &&
                        _pwTextController.value.text.length >= 6) {
                      if (_pwTextController.value.text ==
                          _pwCheckTextController.value.text) {
                        var bytes = utf8.encode(_pwTextController.value.text);
                        var digest = sha1.convert(bytes);
                        reference
                            .child(_idTextController.value.text)
                            .push()
                            .set(User(
                                    _nameTextController.value.text,
                                    _idTextController.value.text,
                                    digest.toString(),
                                    _emailTextController.value.text,
                                    DateTime.now().toIso8601String())
                                .toJson())
                            .then((_) {
                          Navigator.of(context).pop();
                        });
                      } else {
                        makeDialog('비밀번호가 틀립니다');
                      }
                    } else {
                      makeDialog('길이가 짧습니다');
                    }
                  },
                  child: Text(
                    '회원가입',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.deepOrange,
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
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
