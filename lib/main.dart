import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jupgging/provider/location_provider.dart';
import 'package:provider/provider.dart';
import 'google_map_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(//여러 프로바이더 같이 사용하기
      providers: [ //하나의 데이터를 여러페이지에 공유가능
        ChangeNotifierProvider( //변하는 값 처리하기
          create:(context)=> LocationProvider(),//Location Provider 클래스 데이터 변하면 알려줌
          child: GoogleMapPage(),//googlemappage가 위치데이터에 접근가능
        )
      ],
      child:MaterialApp(
        title: 'Flutter Demo',
        home: GoogleMapPage(),
      ),
    );
  }
}

