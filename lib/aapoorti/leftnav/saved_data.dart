import 'package:flutter/material.dart';

void main() => runApp(new Saved());

class Saved extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Material(
        child: new Center(
          child: new Text("Saved Data"),

        ),

      ),
    );
  }
}