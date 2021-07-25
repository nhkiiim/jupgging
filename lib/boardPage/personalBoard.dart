import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:jupgging/boardPage/personalDetail.dart';
import 'package:jupgging/models/user.dart';
import 'package:jupgging/models/image.dart';
import 'package:jupgging/auth/url.dart';

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
  URL url=URL();
  String _databaseURL;
  int totalHour,totalMinute,totalSec;
  double totalDistance;

  @override
  void initState() {
    super.initState();
    _databaseURL=url.databaseURL;
    id = 'bcb123';
    totalDistance = 0;
    totalHour=0;
    totalMinute=0;
    totalSec=0;
    _database = FirebaseDatabase(databaseURL: _databaseURL);
    reference = _database.reference().child('user');
    referenceImg = _database.reference().child('image');

    // reference.child(id).onChildAdded.listen((event) {
    //   user=User.fromSnapshot(event.snapshot);
    // });

    // ImageDownload().then((value)=>{
    //   setState(() {_imgUrl = value;})
    // });
    referenceImg..orderByChild("id")
        .equalTo(id).onChildAdded.listen((event) {
      print(event.snapshot.value.toString());
      setState(() {
        ImageURL temp = ImageURL.fromSnapshot(event.snapshot);
        _imgUrl.add(temp);
        print(double.parse(temp.distance));
        totalDistance += double.parse(temp.distance);
        totalHour += int.parse(temp.time.substring(0,2));
        totalMinute += int.parse(temp.time.substring(3,5));
        totalSec += int.parse(temp.time.substring(6,8));

        if(totalSec>=60){
          totalMinute+=1;
          totalSec%=60;
        }
        if(totalMinute>=60){
          totalHour+=1;
          totalMinute%=60;
        }
      });
    });
  }

  Widget build(BuildContext context) {
    _imgUrl = List.from(_imgUrl.reversed);
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        child: Column(children: [
          Container(
            color: const Color(0xFF88C26F),
            width: screenWidth,
            height: screenHeight*0.3,
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          (screenWidth*0.3-screenHeight*0.12)*0.7,
                          screenHeight*0.07,
                          (screenWidth*0.3-screenHeight*0.12)*0.5,
                          screenHeight*0.04
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(55.0),
                        child:
                        //Image.network(user.profileImg, fit: BoxFit.fill)
                        Image.asset(
                          'image/tree.jpg',
                          width: screenHeight*0.12,
                          height: screenHeight*0.12,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Container(
                        child: Column(
                          children: [
                            Padding(
                                padding: EdgeInsets.fromLTRB(screenWidth*0.1, screenHeight*0.02, 0, 0),
                                child: Text("Running",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white))),
                            Padding(
                                padding: EdgeInsets.fromLTRB(screenWidth*0.12, screenHeight*0.03, 0, 0),
                                child: Text(totalDistance.toString()+"km",
                                    style: TextStyle(color: Colors.white))),
                          ],
                        )),
                    Container(
                        child: Column(
                          children: [
                            Padding(
                                padding: EdgeInsets.fromLTRB(screenWidth*0.13, screenHeight*0.02, 0, 0),
                                child: Text("Time",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white))),
                            Padding(
                                padding: EdgeInsets.fromLTRB(screenWidth*0.12, screenHeight*0.03, 0, 0),
                                child: Text("${totalHour.toString().padLeft(2, '0')}:${totalMinute.toString().padLeft(2, '0')}:${totalSec.toString().padLeft(2, '0')}",
                                    style: TextStyle(color: Colors.white))),
                          ],
                        )),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: SizedBox(
                    height: screenHeight*0.05,
                    width: screenWidth*0.4,
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
                ),
              ],
            ),
          ),
          _imgUrl.length == 0 ? CircularProgressIndicator() : Expanded(
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
                          Navigator.of(context)
                              .pushNamed('/detail',
                              arguments: _imgUrl[index]
                              );
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