import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String difficulty = 'hard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: RaisedButton(
              onPressed: () {
                Navigator.of(context)
                    .pushReplacementNamed('/GamePage', arguments: difficulty);
              },
              child: Text("Play"),
            ),
          )
        ],
      ),
    );
  }
}
