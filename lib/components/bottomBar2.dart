import 'package:flutter/material.dart';
import 'package:jupgging/boardPage/personalBoard.dart';
import 'package:jupgging/boardPage/publicBoard.dart';
import 'package:jupgging/mapPage/firstPage.dart';

class BottomBar2 extends StatefulWidget{
  final dynamic index;

  @override
  State<StatefulWidget> createState() => _BottomBar2();

  BottomBar2({Key key, @required this.index}) : super(key: key);
}

class _BottomBar2 extends State<BottomBar2> with SingleTickerProviderStateMixin{
  TabController controller;

  void initState(){
    super.initState();
    controller = TabController(length: 3, vsync: this, initialIndex: 2);
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: TabBarView(
          controller: controller,                     // 컨트롤러 연결
          children: [PublicBoard(), FirstPage(), PersonalBoard()]
      ),
      bottomNavigationBar: BottomAppBar(  //네비게이션바
        color: Colors.white,
        child: new TabBar(
          controller:controller,
          tabs: <Tab>[
            new Tab(icon: new Icon(Icons.assignment_outlined, color:Colors.grey),),
            new Tab(icon: new Icon(Icons.home, color:Colors.grey),),
            new Tab(icon: new Icon(Icons.child_care, color:Colors.grey)),
          ],
        ),
      ),
    );
  }
}


