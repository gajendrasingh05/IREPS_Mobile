
// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
class MyAppnodata extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AAC-Item Annual...',
      home: Scaffold(   resizeToAvoidBottomInset: false,
        // //resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          iconTheme: new IconThemeData(color: Colors.white),
          backgroundColor: Colors.blue[800],
          title: Text('AAC-Item Annual...'),
        ),
        body: Center(
          child: Container(
          height: 700.0,
          child:  Column(
            children: <Widget>[
              Image.asset('assets/no_data.png',width: 500,height: 500,),

              Text("Sorry no data found!!!!! ",style:TextStyle(fontSize: 17),)
            ],
          ),color: Colors.white,

        )
        ),
      ),
    );
  }
}