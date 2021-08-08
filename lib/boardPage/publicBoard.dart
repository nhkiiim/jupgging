import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jupgging/models/image.dart';
import 'package:jupgging/models/user.dart';
import 'dart:convert';
import 'package:jupgging/auth/url.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PublicBoard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PublicBoard();
}

class _PublicBoard extends State<PublicBoard> {
  List<ImageURL> imglist = List();
  List<String> idArr = List();
  String id;
  String profileImage;
  User user;
  FirebaseDatabase _database;
  DatabaseReference reference;
  DatabaseReference referenceImg;
  URL url=URL();
  String _databaseURL;
  static final storage = new FlutterSecureStorage();
  //Map<String, ImageURL> map = Map();

  @override
  void initState()  {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });

    _databaseURL=url.databaseURL;
    _database = FirebaseDatabase(databaseURL: _databaseURL);
    reference = _database.reference().child('user');
    referenceImg = _database.reference().child('image');

    referenceImg.orderByChild("createTime").onChildAdded.listen((event) {
      setState(() {
        imglist.add(ImageURL.fromSnapshot(event.snapshot));
      });
    });
  }

  _asyncMethod() async {
    id=await storage.read(key: "login");
  }

  Widget build(BuildContext context) {
    imglist = List.from(imglist.reversed);

    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return SafeArea(
      child:Scaffold(
        body: Container(
      child: Column(children: [
        if (imglist.length == 0) CircularProgressIndicator() else Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    reference.child(imglist[index].id).onChildAdded.listen((event) {
                        profileImage=User.fromSnapshot(event.snapshot).profileImg;
                      print("123123238472938479 ${User.fromSnapshot(event.snapshot).profileImg}");
                    });
                    return Container(
                      //child: GridTile(
                      child: Column(
                        children: [
                          Container(
                            child: Container(
                                color: const Color(0xFF88C26F),
                                height: 50,
                                child: Row(children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(w*0.03, 0, 0, 0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(55.0),
                                      child:
                                      Image.network(
                                        profileImage,
                                        width: 35,
                                        height: 35,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(w*0.03, h*0.001, 0, 0),
                                    child: Text(imglist[index].id,
                                        style: TextStyle(
                                          color: Colors.white,
                                            fontWeight: FontWeight.bold
                                        )),
                                  ),
                                ])),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed('/detail', arguments: imglist[index]);
                            },
                              child: Column(
                                children : [
                                  Image.network(imglist[index].mapUrl,height:h*0.45, width:w, fit: BoxFit.cover),
                                 Padding(
                                   padding: EdgeInsets.fromLTRB(w*0.03, h*0.02, 0, 0),
                                   child: Row(
                                    children:[
                                      Text( imglist[index].id, style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text('    ${imglist[index].comment}'),
                                      Padding(
                                          padding: EdgeInsets.fromLTRB(0, h*0.001, w*0.03,0 ),
                                      ),
                                    ]
                                   ),
                                 ),
                                ]
                              ),
                          )
                        ],
                      ),
                    );
                  },
                  itemCount: imglist.length,
                ),
              ),
      ]),
    )));
  }
}
