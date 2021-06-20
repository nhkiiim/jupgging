import 'package:flutter/material.dart';
import 'package:jupgging/runningInfo.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class JupggingEnd extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _JupggingEnd();
  final RunningInfo run;
  //run = ModalRoute.of(context)!.settings.arguments as RunningInfo;
  //run = ModalRoute.of(context).settings.arguments;
  JupggingEnd({Key key, @required this.run}) : super(key: key);
}

class _JupggingEnd extends State<JupggingEnd> {
  File _image;
  //final run = ModalRoute.of(context)!.settings.arguments as RunningInfo;

  void Photo(ImageSource source) async {
    File file = await ImagePicker.pickImage(source: source);
    setState(() => _image = file);
  }

  @override
  Widget build(BuildContext context) {
    var m = widget.run.minutes;
    var s = widget.run.seconds;
    return Scaffold(
      body: Container(
        child: Column(
            children: [
              //mapInfo((MediaQuery.of(context).size.height-50)*0.75),
              Container(  //지도 부분
                  color: Colors.lightGreen,
                  height: (MediaQuery.of(context).size.height-50)*0.75,
                  child: Center(
                    child: Text('지도', textAlign: TextAlign.center, style: TextStyle(color: Colors.amber, fontSize: 30),),
                  )
              ),
              Container(  //달린 거리, 시간 나오는 부분
                height: (MediaQuery.of(context).size.height-50)*0.25+50,
                color: Colors.white,
                child: Text('$m 분 $s 초',textAlign: TextAlign.center,style:TextStyle(fontSize: 30)),  //시간 계산
              ),]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _selectPhotoButton(context);
        },
        child: Icon(Icons.camera_alt),
        backgroundColor: Colors.lightBlueAccent,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
  void _selectPhotoButton(context){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
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

}