import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:jupgging/models/image.dart';
import 'package:jupgging/models/user.dart';

class PublicBoard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PublicBoard();
}

class _PublicBoard extends State<PublicBoard> {
  List<ImageURL> imglist = List();
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
        imglist.add(ImageURL.fromSnapshot(event.snapshot));
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Column(children: [
        imglist.length == 0
            ? CircularProgressIndicator()
            : Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      //child: GridTile(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Container(
                                color: const Color(0xFF88C26F),
                                height: 50,
                                child: Row(children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(55.0),
                                      child: Image.asset(
                                        'image/tree.jpg',
                                        width: 35,
                                        height: 35,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(10, 15, 35, 20),
                                    child: Text("nahye_on",
                                        style: TextStyle(
                                          color: Colors.white,
                                        )),
                                  )
                                ])),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed('/detail', arguments: imglist[index]);
                            },
                              child: Image.network(imglist[index].mapUrl,height:350, width:500, fit: BoxFit.cover),
                          )
                        ],
                      ),
                    );
                  },
                  itemCount: imglist.length,
                ),
              ),
      ]),
    ));
  }
}
