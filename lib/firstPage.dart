import 'package:flutter/material.dart';

class FirstPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FirstPage();
}

class _FirstPage extends State<FirstPage> {
  var _icon = Icons.play_arrow; //시작버튼
  var _color = Colors.amber; //버튼 색깔
  var _isStart = false;

  @override
  Widget build(BuildContext context) {
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
                  height: (MediaQuery.of(context).size.height-50)*0.25,
                  color: Colors.white,
                  child: Text("시작을 눌러주세요",textAlign: TextAlign.center,style:TextStyle(fontSize: 30)),  //시간 계산
              ),]
        ),
      ),
      bottomNavigationBar: BottomAppBar(  //네비게이션바
        child: Container(
          color: Colors.black12,
          height: 50,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() {
          _click();
        }),
        child: Icon(_icon),
        backgroundColor: _color,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void _click() {
    _isStart = !_isStart;

    if (_isStart) {
      Navigator.of(context)
          .pushReplacementNamed('/main/info',);
    }
  }

}