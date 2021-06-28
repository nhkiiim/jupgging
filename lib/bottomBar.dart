import 'package:flutter/material.dart';
import 'package:jupgging/PersonalBoard.dart';
import 'package:jupgging/firstPage.dart';

class BottomBar extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _BottomBar();
}

class _BottomBar extends State<BottomBar> with SingleTickerProviderStateMixin{
  TabController controller;

  void initState(){
    super.initState();
    controller = TabController(length: 3, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
          controller: controller,                     // 컨트롤러 연결
          children: [Red(), FirstPage(), PersonalBoard()]
      ),
      bottomNavigationBar: BottomAppBar(  //네비게이션바
        color: Colors.white,
        child: new TabBar(
          controller: controller,
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

class Red extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Card(color: Colors.red);
  }
}


