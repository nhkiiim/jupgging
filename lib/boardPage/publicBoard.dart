import 'package:flutter/material.dart';

class PublicBoard extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _PublicBoard();
}

class _PublicBoard extends State<PublicBoard>{
  @override
  void initState(){
  super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        child: Column(
          children:[
           Padding(
             padding: const EdgeInsets.fromLTRB(0,25,0,0),
             child: Container(
               color:Colors.black12,
               height:50,
               child: Row(
                   children: [
                     Container(
                       margin:EdgeInsets.fromLTRB(10, 0, 0, 0),
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
                      padding: EdgeInsets.fromLTRB(10, 15, 35, 20),
                        child: Text("nahye_on"),
                      )
                   ]
               )
              ),
           ),
          Container(
              child : Image.asset(
                'image/tree.jpg',
                width: 500,
                height: 300,
                fit: BoxFit.fill,
              )
          )
         ],
        )
      )
    );
  }
}