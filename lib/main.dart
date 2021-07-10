import 'package:flutter/material.dart';
import 'package:jupgging/components/bottomBar.dart';
import 'package:jupgging/components/intro.dart';
import 'package:provider/provider.dart';
import 'package:jupgging/provider/location_provider.dart';
import 'package:jupgging/userPage/signPage.dart';
import 'package:jupgging/userPage/myPage.dart';
import 'package:jupgging/userPage/login.dart';
import 'package:jupgging/userPage/pwChangePage.dart';
import 'package:jupgging/mapPage/jupggingInfo.dart';
import 'package:jupgging/mapPage/jupggingEnd.dart';
import 'package:jupgging/mapPage/firstPage.dart';

import 'boardPage/personalBoard.dart';
import 'mapPage/jupggingAdd.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ //하나의 데이터를 여러페이지에 공유가능
        ChangeNotifierProvider(
          create:(context)=> LocationProvider(),//Location Provider 클래스 데이터 변하면 알려줌
          child: FirstPage(),//firstmappage가 위치데이터에 접근가능
        ),
        ChangeNotifierProvider(
          create:(context)=> LocationProvider(),
          child: JupggingInfo(),
        ),
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.lightGreen,
          ),
          initialRoute: '/intro',
          routes: {
            '/intro': (context) => IntroPage(),
            '/login': (context) => LoginPage(),
            '/sign': (context) => SignPage(),
            '/main': (context) => BottomBar(),
            '/main/info': (context) => JupggingInfo(),
            '/main/info/end': (context) => JupggingEnd(),
            '/add': (context) => JupggingAdd(),
            '/mypage': (context) => MyPage(),
            '/pwChange': (context) => PwChangePage(),
            '/personal': (context) => PersonalBoard(),
          }),
      );
  }
}

/*
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, @required this.title}) : super(key: key);



  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {

      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
*/
