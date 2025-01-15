import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';

class NormalComing extends StatelessWidget{
  @override

  Widget build(BuildContext context){
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.cyan,
          textTheme: TextTheme(
            /* headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold, color: Colors.green),
          title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic,color: Colors.red),
          body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind',color: Colors.orange),*/
           //caption:  TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold, color: Colors.blueGrey),
          ),
          primarySwatch: Colors.teal,

        ),

        home: Scaffold(
          resizeToAvoidBottomInset: false,
          // //resizeToAvoidBottomPadding: true,
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor:Colors.cyan,
            title: Text('IREPS',style: TextStyle(color: Colors.white,
              fontWeight: FontWeight.bold,),),

          ),

          body: Container(

            decoration: BoxDecoration(
              color: Colors.grey[100],
              image: DecorationImage(
                image: AssetImage("assets/comingsoon.jpg"),
                fit: BoxFit.fitWidth,

              ),
            ),
            child: null /* add child content here */,
          ),

        )
    );
  }
}