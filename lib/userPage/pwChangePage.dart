import 'dart:math';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:jupgging/data/user.dart';

class PwChangePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PwChangePage();
}

class _PwChangePage extends State<PwChangePage> {
  TextEditingController _nowPwTextController;
  TextEditingController _newPwTextController;
  TextEditingController _newPwCheckTextController;

  String id;
  User user;
  FirebaseDatabase _database;
  DatabaseReference reference;
  String _databaseURL =
      'https://flutterproject-86abc-default-rtdb.asia-southeast1.firebasedatabase.app/';

  @override
  void initState() {
    super.initState();

    _nowPwTextController = TextEditingController();
    _newPwTextController = TextEditingController();
    _newPwCheckTextController = TextEditingController();

    _database = FirebaseDatabase(databaseURL: _databaseURL);
    reference = _database.reference().child('user');
  }

  @override
  Widget build(BuildContext context) {
    id = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('비밀번호 변경'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              //print('_nowPwTextController.value.text.length');
              if (_nowPwTextController.value.text.length == 0 ||
                  _newPwTextController.value.text.length == 0 ||
                  _newPwCheckTextController.value.text.length == 0) {
                makeDialog('빈칸이 있습니다');
              } else {
                reference.child(id).onChildAdded.listen((event) {
                  user = User.fromSnapshot(event.snapshot);
                  var bytes = utf8.encode(_nowPwTextController.value.text);
                  var digest = sha1.convert(bytes);
                  if (user.pw == digest.toString()) {
                    if (_newPwTextController.value.text ==
                        _newPwCheckTextController.value.text) {
                      if (_newPwTextController.value.text.length >= 6 &&
                          _newPwCheckTextController.value.text.length >= 6) {
                        var bytes1 = utf8.encode(_newPwTextController.value.text);
                        var digest1 = sha1.convert(bytes1);
                        User upUser = User(user.name, id, digest1.toString(),
                            user.email, user.createTime);
                        reference
                            .child(user.key)
                            .set(upUser.toJson())
                            .then((_) {
                          Navigator.of(context).pop();
                        });
                      } else {
                        makeDialog('비밀번호를 6자리이상 입력해주세요');
                      }
                    } else {
                      makeDialog('새 비밀번호가 일치하지 않습니다');
                    }
                  } else {
                    makeDialog('비밀번호가 틀립니다');
                  }
                });
              } //
            },
            child: Text(
              '저장',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nowPwTextController,
              maxLines: 1,
              decoration: InputDecoration(
                hintText: '현재 비밀번호',
              ),
              style: TextStyle(fontSize: 14),
            ),
            TextField(
              controller: _newPwTextController,
              maxLines: 1,
              decoration: InputDecoration(
                hintText: '새 비밀번호',
              ),
              style: TextStyle(fontSize: 14),
            ),
            TextField(
              controller: _newPwCheckTextController,
              maxLines: 1,
              decoration: InputDecoration(
                hintText: '새 비밀번호 다시 입력',
              ),
              style: TextStyle(fontSize: 14),
            ),
          ],
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
