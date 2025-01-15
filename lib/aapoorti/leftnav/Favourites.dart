
import 'package:flutter/material.dart';

void main() => runApp(new Fav());

class Fav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Material(
        child: new Center(
          child: new Text("No favourites added !"),

        ),

      ),
    );
  }
}