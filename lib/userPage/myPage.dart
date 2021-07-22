import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:jupgging/models/user.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyPage();
}

class _MyPage extends State<MyPage> {
  TextEditingController _pwTextController;
  TextEditingController _emailTextController;

  String id;
  User user;

  File _image;

  FirebaseDatabase _database;
  DatabaseReference reference;
  String _databaseURL =
      'https://flutterproject-86abc-default-rtdb.asia-southeast1.firebasedatabase.app/';

  void Photo(ImageSource source) async {
    File file = await ImagePicker.pickImage(source: source);
    setState(() => _image = file);
  }

  @override
  void initState() {
    super.initState();

    //id = 'happy123';
    _database = FirebaseDatabase(databaseURL: _databaseURL);
    reference = _database.reference().child('user');

    _pwTextController = TextEditingController();
    _emailTextController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    user = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '프로필 편집',
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              if (_pwTextController.value.text.length == 0) {
                makeDialog('비밀번호를 입력해주세요');
              } else {
                var bytes = utf8.encode(_pwTextController.value.text);
                var digest = sha1.convert(bytes);
                if (user.pw == digest.toString()) {
                  if (user.email != _emailTextController.value.text) {
                    User upUser = User(user.name, user.id, user.pw,
                        _emailTextController.value.text, user.createTime);
                    reference
                        .child(id)
                        .child(user.key)
                        .set(upUser.toJson())
                        .then((_) {
                      Navigator.of(context).pop();
                    });
                  } else {
                    makeDialog('기존 이메일과 똑같습니다');
                  }
                } else {
                  makeDialog('비밀번호가 일치하지 않습니다');
                }
              }
            },
            child: Text(
              '완료',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                  height: 200,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(55.0),
                        child: Image.asset(
                          'image/tree.jpg',
                          width: 90,
                          height: 90,
                          fit: BoxFit.fill,
                        ),
                      ),
                      FlatButton(
                          onPressed: () => setState(() {
                            _selectPhotoButton(context);
                          }),
                          child: Text(
                            '프로필 사진 바꾸기',
                            style: TextStyle(color: Colors.blue),
                          ))
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 70,
                            child: Text('이름'),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 110,
                            child: Text(user.name),
                          ),
                        ],
                        //mainAxisAlignment: MainAxisAlignment.center,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 70,
                            child: Text('아이디'),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 110,
                            child: Text(user.id),
                          ),
                        ],
                        //mainAxisAlignment: MainAxisAlignment.center,
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 70,
                            child: Text('이메일'),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 110,
                            child: TextField(
                              controller: _emailTextController,
                              maxLines: 1,
                              decoration: InputDecoration(
                                hintText: user.email,
                              ),
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                        //mainAxisAlignment: MainAxisAlignment.center,
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 70,
                            child: Text('비밀번호'),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 110,
                            child: TextField(
                              controller: _pwTextController,
                              maxLines: 1,
                              decoration: InputDecoration(
                                hintText: '비밀번호를 입력해주세요',
                              ),
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                        //mainAxisAlignment: MainAxisAlignment.center,
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 70,
                          ),
                          FlatButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacementNamed(
                                    '/pwChange',
                                    arguments: id);
                              },
                              child: Text(
                                '비밀번호 변경',
                                style: TextStyle(),
                              ))
                        ],
                        //mainAxisAlignment: MainAxisAlignment.center,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          child: FlatButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text('${user.id}님'),
                                        content: Text('회원탈퇴 하시겠습니까?'),
                                        actions: <Widget>[
                                          FlatButton(
                                              onPressed: () {
                                                reference
                                                    .child(user.id)
                                                    .remove()
                                                    .then((_) {
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context)
                                                      .pushReplacementNamed(
                                                    '/login',
                                                  );
                                                });
                                              },
                                              child: Text('예')),
                                          FlatButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('아니오'))
                                        ],
                                      );
                                    });
                              },
                              child: Text(
                                '회원 탈퇴하기',
                                style: TextStyle(color: Colors.blue),
                              ))),
                      Container(
                          child: FlatButton(
                              onPressed: () {},
                              child: Text(
                                '로그아웃',
                                style: TextStyle(color: Colors.blue),
                              ))),
                    ],
                  ),
                ),
              ],
              //mainAxisAlignment: MainAxisAlignment.center,
            ),
          ),
        ),
      ),
    );
  }

  void _selectPhotoButton(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text("사진 찍기"),
                  onTap: () => Photo(ImageSource.camera),
                ),
                ListTile(
                  leading: Icon(Icons.photo),
                  title: Text("앨범에서 가져오기"),
                  onTap: () => Photo(ImageSource.gallery),
                ),
              ],
            ),
          );
        });
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
