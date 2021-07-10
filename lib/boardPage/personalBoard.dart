import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:jupgging/models/user.dart';
import 'package:jupgging/models/image.dart';

class PersonalBoard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PersonalBoard();
}

class _PersonalBoard extends State<PersonalBoard> {
  List<ImageURL> _imgUrl = List();
  String id;
  User user;
  FirebaseDatabase _database;
  DatabaseReference reference;
  DatabaseReference referenceImg;
  String _databaseURL =
      'https://flutterproject-86abc-default-rtdb.asia-southeast1.firebasedatabase.app/';

  @override
  void initState() {
    super.initState();

    id = 'happy123';
    _database = FirebaseDatabase(databaseURL: _databaseURL);
    reference = _database.reference().child('user');
    referenceImg = _database.reference().child('image');

    referenceImg.child(id).onChildAdded.listen((event) {
      print(event.snapshot.value.toString());
      setState(() {
        _imgUrl.add(ImageURL.fromSnapshot(event.snapshot));
      });
    });
  }

  Widget build(BuildContext context) {
    _imgUrl = List.from(_imgUrl.reversed);
    return Scaffold(
      body: Container(
        child: Column(children: [
          Container(
            color: Colors.lightGreen,
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(35, 35, 35, 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(55.0),
                        child: Image.asset(
                          'image/tree.jpg',
                          width: 90,
                          height: 90,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Container(
                        child: Column(
                          children: [
                            Padding(
                                padding: EdgeInsets.fromLTRB(30, 50, 35, 20),
                                child: Text("Running",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white))),
                            Padding(
                                padding: EdgeInsets.fromLTRB(35, 0, 35, 20),
                                child: Text("10km",
                                    style: TextStyle(color: Colors.white))),
                          ],
                        )),
                    Container(
                        child: Column(
                          children: [
                            Padding(
                                padding: EdgeInsets.fromLTRB(20, 50, 35, 20),
                                child: Text("Time",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white))),
                            Padding(
                                padding: EdgeInsets.fromLTRB(20, 0, 35, 20),
                                child: Text("14h",
                                    style: TextStyle(color: Colors.white))),
                          ],
                        )),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(100, 0, 100, 0),
                  child: RaisedButton(
                    color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.settings,
                          color: const Color(0xFF88C26F),
                        ),
                        Text('  setting',
                            style: TextStyle(color: const Color(0xFF88C26F)))
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    onPressed: () {
                      reference.child(id).onChildAdded.listen((event) {
                        user = User.fromSnapshot(event.snapshot);
                        Navigator.of(context)
                            .pushNamed('/mypage', arguments: user);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          _imgUrl.length == 0
              ? CircularProgressIndicator()
              : Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Card(
                  //child: GridTile(
                  child: Container(
                    //width: 200,
                    //padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: SizedBox(
                      child: GestureDetector(
                        onTap: () {
                          //누르면 인스타 개인 게시물처럼 보기
                        },
                        child:
                        //Text(_imgUrl[index].mapUrl),

                        Image.network(_imgUrl[index].mapUrl,
                            fit: BoxFit.fill),
                      ),
                    ),
                  ),
                  //),
                );
              },
              itemCount: _imgUrl.length,
            ),
          ),
        ]),
      ),
    );
  }
}