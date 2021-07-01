import 'package:flutter/material.dart';

class PersonalBoard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PersonalBoard();
}

class _PersonalBoard extends State<PersonalBoard> {
  @override
  void initState() {
    super.initState();
  }

  GridView _imageGrid() {
    return GridView.count(

      shrinkWrap: true,
      crossAxisCount: 3,
      childAspectRatio: 1,
      children: [
        Image.asset('image/tree.jpg'),
        Image.asset('image/tree.jpg'),
        Image.asset('image/tree.jpg'),
        Image.asset('image/tree.jpg'),
        Image.asset('image/tree.jpg'),
        Image.asset('image/tree.jpg'),
        Image.asset('image/tree.jpg')
      ],
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
            children: [
              Container(
                color: Colors.black12,
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
                                    child: Text("Running",style:TextStyle(fontWeight: FontWeight.bold))
                                ),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(35, 0, 35, 20),
                                    child: Text("10km")
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
                                    child: Text("Time",style:TextStyle(fontWeight: FontWeight.bold))
                                ),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(20, 0, 35, 20),
                                    child: Text("14h")
                                ),
                              ],
                            )
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(100, 0, 100, 0),
                      child: RaisedButton(
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.settings),
                            Text('  setting')
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed('/mypage');
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