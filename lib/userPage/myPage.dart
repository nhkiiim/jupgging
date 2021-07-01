import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:jupgging/data/user.dart';

class MyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyPage();
}

class _MyPage extends State<MyPage> {
  TextEditingController _pwTextController;
  TextEditingController _pwCheckTextController;
  TextEditingController _emailTextController;
  String id;
  User user;
  FirebaseDatabase _database;
  DatabaseReference reference;
  String _databaseURL =
      'https://flutterproject-86abc-default-rtdb.asia-southeast1.firebasedatabase.app/';

  @override
  void initState(){
    id = 'happy123';
    _database = FirebaseDatabase(databaseURL: _databaseURL);
    reference = _database.reference().child('user');
    reference
        .child(id)
        .onChildAdded
        .listen((event) {
      user = User.fromSnapshot(event.snapshot);});

    _pwTextController = TextEditingController(text: '기존 pw 불러오기');
    _pwCheckTextController = TextEditingController();
    _emailTextController = TextEditingController(text: 'y');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('mypage'),
      ),
      body: Container(
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
                        onPressed: () {},
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
                          child: Text('name'),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 110,
                          child: Text(user.name),
                        ),
                      ],
                      //mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 70,
                          child: Text('email'),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 110,
                          child: TextField(
                            controller: _emailTextController,
                            maxLines: 1,
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                      //mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 70,
                          child: Text('pw'),
                        ),
                        FlatButton(
                            onPressed: () {},
                            child: Text(
                              '비밀번호 변경',
                              style: TextStyle(),
                            ))
                      ],
                      //mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                        child: FlatButton(
                            onPressed: () {},
                            child: Text(
                              '회원 탈퇴하기',
                              style: TextStyle(color: Colors.blue),
                            ))
                    ),
                    Container(
                        child: FlatButton(
                            onPressed: () {},
                            child: Text(
                              '로그아웃',
                              style: TextStyle(color: Colors.blue),
                            ))
                    ),
                  ],
                ),
              ),
            ],
            //mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
      ),
    );
  }
}