import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:jupgging/data/user.dart';

class PersonalBoard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PersonalBoard();
}

class _PersonalBoard extends State<PersonalBoard> {
  String _imgUrl="";
  String id;
  User user;
  FirebaseDatabase _database;
  DatabaseReference reference;
  String _databaseURL =
      'https://flutterproject-86abc-default-rtdb.asia-southeast1.firebasedatabase.app/';

  @override
  void initState() {
    super.initState();

    id = 'happy123';
    _database = FirebaseDatabase(databaseURL: _databaseURL);
    reference = _database.reference().child('user');

    ImageDownload().then((value)=>{
      setState(() {_imgUrl = value;})
    });
  }
  Future<String> ImageDownload() async{
    FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
    StorageReference storageReference = _firebaseStorage.ref().child("map/1625230640853.png");
    String downloadImg = await storageReference.getDownloadURL();
    return downloadImg;
  }
  GridView _imageGrid() {
    return GridView.count(

      shrinkWrap: true,
      crossAxisCount: 3,
      childAspectRatio: 1,
      children: [
        Image.network(_imgUrl,fit: BoxFit.fill)
      ],
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
            children: [
              Container(
                color: Colors.deepOrange,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
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
                                    padding: EdgeInsets.fromLTRB(
                                        30, 50, 35, 20),
                                    child: Text("Running",style:TextStyle(fontWeight: FontWeight.bold,color: Colors.white))
                                ),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(35, 0, 35, 20),
                                    child: Text("10km",style:TextStyle(color: Colors.white))
                                ),
                              ],
                            )
                        ),
                        Container(
                            child: Column(
                              children: [
                                Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        20, 50, 35, 20),
                                    child: Text("Time",style:TextStyle(fontWeight: FontWeight.bold,color: Colors.white))
                                ),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(20, 0, 35, 20),
                                    child: Text("14h",style:TextStyle(color: Colors.white))
                                ),
                              ],
                            )
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(100, 0, 100, 0),
                      child: RaisedButton(
                        color : Colors.white,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.settings, color: Colors.deepOrange,),
                            Text('  setting',style:TextStyle(color: Colors.deepOrange))
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

              AnimatedContainer(
                transform: Matrix4.translationValues(0, 0, 0),
                duration: Duration(milliseconds: 10),
                curve: Curves.linear,
                child: _imageGrid(),
              ),
            ]
        ),
      ),
    );
  }
}