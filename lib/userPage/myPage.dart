import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyPage();
}

class _MyPage extends State<MyPage> {
  TextEditingController _pwTextController;
  TextEditingController _pwCheckTextController;
  TextEditingController _emailTextController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('mypage'),
      ),
      body: Container(
        child: Column(
          children: [
            Column(
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
            ),
          ],
        ),
      ),
    );
  }
}
