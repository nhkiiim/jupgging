import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:jupgging/models/image.dart';
import 'package:jupgging/models/user.dart';

class PersonalDetail extends StatefulWidget{
  ImageURL imgUrl;

  @override
  State<StatefulWidget> createState() => _PesonalDetail();

}

class _PesonalDetail extends State<PersonalDetail>{

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    final imgUrl = ModalRoute.of(context).settings.arguments as ImageURL;

    return Scaffold(
        body:Container(
          child: Padding(
              padding: EdgeInsets.fromLTRB(0,screenHeight*0.04,0,0),
              child: Column(
                children:[
                    Container(
                        height:screenHeight*0.1,
                        child: Row(
                            children: [
                              IconButton(icon: Icon(Icons.arrow_back_outlined),
                                  onPressed: (){ Navigator.of(context).pop();}
                                  ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(screenWidth*0.02, 0, 0, 0),
                                child: Text("${(imgUrl.createTime).substring(0,10)}", style: TextStyle(fontSize: screenHeight*0.04)),
                              )
                            ]
                        )
                    ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(screenWidth*0.05, screenHeight*0.02, screenWidth*0.05, screenHeight*0.05),
                      child: Container(
                          child : ImageSlideshow(
                              height: screenHeight*0.5,
                              children: [
                                Image.network(imgUrl.mapUrl,
                                    fit: BoxFit.fill),
                                Image.asset(  //쓰레기 사진
                                  'image/tree.jpg',
                                  fit: BoxFit.fill,
                                ),
                              ],
                          ),
                      ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Text('${imgUrl.distance}km ${imgUrl.time}', style: TextStyle(fontSize: screenHeight*0.04)),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, screenHeight*0.04, 0, 0),
                          child: Container(
                            color: Color(0xFFC5E99B),
                            height: screenHeight*0.15,
                            width: screenWidth*0.8,
                            child: Text('${imgUrl.comment}', style: TextStyle(fontSize: screenHeight*0.03)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
          )
        )
    );
  }
}